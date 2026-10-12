import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_multipart/shelf_multipart.dart';
import '../services/exam_service.dart';

class ApiController {
  final ExamService examService;

  ApiController(this.examService);

  Router get router {
    final router = Router();

    // 1. Upload & Import Exam (.docx)
    router.post('/api/exams/upload', _handleUploadDocx);
    router.post('/api/exams/import-default', _handleImportDefaultExam);

    // 2. Exam listings & Details & Edit Exam
    router.get('/api/exams', _handleGetExams);
    router.get('/api/exams/<id|[0-9]+>', _handleGetExamDetail);
    router.put('/api/exams/<id|[0-9]+>', _handleUpdateExam);

    // 3. Edit Question, Passage & Answer (Admin)
    router.put('/api/questions/<id|[0-9]+>', _handleUpdateQuestion);
    router.put('/api/passages/<id|[0-9]+>', _handleUpdatePassage);
    router.put('/api/answers/<id|[0-9]+>', _handleUpdateAnswer);

    // 4. Test Session (Student)
    router.post('/api/sessions/start', _handleStartSession);
    router.get('/api/sessions/<id>', _handleGetSessionStatus);
    router.post('/api/sessions/<id>/answer', _handleRecordAnswer);
    router.post('/api/sessions/<id>/submit', _handleSubmitSession);

    return router;
  }

  Response _jsonResponse(dynamic data, {int statusCode = 200}) {
    return Response(
      statusCode,
      body: jsonEncode(data),
      headers: {
        'content-type': 'application/json; charset=utf-8',
        'access-control-allow-origin': '*',
      },
    );
  }

  Response _errorResponse(String message, {int statusCode = 400, dynamic extra}) {
    return _jsonResponse({
      'success': false,
      'error': message,
      if (extra != null) 'data': extra,
    }, statusCode: statusCode);
  }

  /// Handles .docx file upload via multipart/form-data or raw binary body
  Future<Response> _handleUploadDocx(Request request) async {
    try {
      Uint8List? docxBytes;

      final form = request.formData();
      if (form != null) {
        await for (final data in form.formData) {
          if (data.filename != null) {
            docxBytes = await data.part.readBytes();
            break;
          }
        }
      } else {
        // Raw binary upload fallback
        final byteList = await request.read().fold<List<int>>([], (prev, chunk) => prev..addAll(chunk));
        if (byteList.isNotEmpty) {
          docxBytes = Uint8List.fromList(byteList);
        }
      }

      if (docxBytes == null || docxBytes.isEmpty) {
        return _errorResponse('Vui lòng chọn file Word (.docx) để tải lên');
      }

      final importResponse = examService.importExamFromDocx(docxBytes);
      if (!importResponse.success) {
        return _jsonResponse({
          'success': false,
          'message': 'File không đúng định dạng chuẩn. Toàn bộ nội dung đã bị hủy bỏ theo cơ chế All-or-Nothing.',
          'errors': importResponse.validationResult.errors.map((e) => e.toJson()).toList(),
        }, statusCode: 422);
      }

      return _jsonResponse({
        'success': true,
        'message': 'Tạo đề thi thành công từ file Word!',
        'examId': importResponse.examId,
        'exam': importResponse.exam?.toJson(includeDetails: false),
      });
    } catch (e) {
      return _errorResponse('Lỗi máy chủ khi xử lý file: ${e.toString()}', statusCode: 500);
    }
  }

  Future<Response> _handleImportDefaultExam(Request request) async {
    try {
      final candidates = [
        r'c:\Users\ASUS\Downloads\kt\Reading_v01_Tagged.docx',
        p.join(Directory.current.path, 'Reading_v01_Tagged.docx'),
        p.join(Directory.current.path, '..', 'Reading_v01_Tagged.docx'),
        p.join(Directory.current.path, '..', '..', 'Reading_v01_Tagged.docx'),
      ];

      File? foundFile;
      for (final candidate in candidates) {
        final f = File(candidate);
        if (f.existsSync()) {
          foundFile = f;
          break;
        }
      }

      if (foundFile == null) {
        return _errorResponse('Không tìm thấy file Reading_v01_Tagged.docx trên máy chủ.', statusCode: 404);
      }

      final bytes = await foundFile.readAsBytes();
      final importResponse = examService.importExamFromDocx(bytes);
      if (!importResponse.success) {
        return _jsonResponse({
          'success': false,
          'message': 'File không đúng định dạng chuẩn. Toàn bộ nội dung đã bị hủy bỏ theo cơ chế All-or-Nothing.',
          'errors': importResponse.validationResult.errors.map((e) => e.toJson()).toList(),
        }, statusCode: 422);
      }

      return _jsonResponse({
        'success': true,
        'message': 'Đã nạp thành công đề thi chuẩn hóa từ file Reading_v01_Tagged.docx!',
        'examId': importResponse.examId,
        'exam': importResponse.exam?.toJson(includeDetails: false),
      });
    } catch (e) {
      return _errorResponse('Lỗi máy chủ khi nạp file mặc định: ${e.toString()}', statusCode: 500);
    }
  }

  Future<Response> _handleGetExams(Request request) async {
    try {
      final exams = examService.getExamsList();
      return _jsonResponse({
        'success': true,
        'total': exams.length,
        'exams': exams.map((e) => e.toJson(includeDetails: false)).toList(),
      });
    } catch (e) {
      return _errorResponse(e.toString(), statusCode: 500);
    }
  }

  Future<Response> _handleGetExamDetail(Request request, String idStr) async {
    final id = int.tryParse(idStr);
    if (id == null) return _errorResponse('Mã đề thi không hợp lệ');

    final isStudent = request.url.queryParameters['role'] == 'student';
    final exam = examService.getExamDetail(id, isStudent: isStudent);
    if (exam == null) return _errorResponse('Không tìm thấy đề thi #$id', statusCode: 404);

    return _jsonResponse({
      'success': true,
      'exam': exam.toJson(includeDetails: true),
    });
  }

  Future<Response> _handleUpdateExam(Request request, String idStr) async {
    final id = int.tryParse(idStr);
    if (id == null) return _errorResponse('Mã đề thi không hợp lệ');

    try {
      final bodyStr = await request.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final title = body['title'] as String?;
      final durationMinutes = body['durationMinutes'] as int?;

      final success = examService.updateExam(id, title: title, durationMinutes: durationMinutes);
      if (!success) return _errorResponse('Không tìm thấy đề thi để cập nhật', statusCode: 404);

      return _jsonResponse({
        'success': true,
        'message': 'Cập nhật thông tin đề thi thành công',
      });
    } catch (e) {
      return _errorResponse('Lỗi dữ liệu: ${e.toString()}');
    }
  }

  Future<Response> _handleUpdatePassage(Request request, String idStr) async {
    final id = int.tryParse(idStr);
    if (id == null) return _errorResponse('Mã đoạn văn không hợp lệ');

    try {
      final bodyStr = await request.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final title = body['title'] as String?;
      final content = body['content'] as String?;

      final success = examService.updatePassage(id, title: title, content: content);
      if (!success) return _errorResponse('Không tìm thấy đoạn văn để cập nhật', statusCode: 404);

      return _jsonResponse({
        'success': true,
        'message': 'Cập nhật đoạn văn thành công',
      });
    } catch (e) {
      return _errorResponse('Lỗi dữ liệu: ${e.toString()}');
    }
  }

  Future<Response> _handleUpdateQuestion(Request request, String idStr) async {
    final id = int.tryParse(idStr);
    if (id == null) return _errorResponse('Mã câu hỏi không hợp lệ');

    try {
      final bodyStr = await request.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final content = body['content'] as String?;
      final explanation = body['explanation'] as String?;
      final correctAnswer = body['correctAnswer'] as String?;
      final rawOptions = body['options'] as Map<String, dynamic>?;
      final options = rawOptions?.map((k, v) => MapEntry(k, v.toString()));

      final success = examService.updateQuestion(
        id,
        content: content,
        explanation: explanation,
        correctAnswer: correctAnswer,
        options: options,
      );
      if (!success) return _errorResponse('Không tìm thấy câu hỏi để cập nhật', statusCode: 404);

      return _jsonResponse({
        'success': true,
        'message': 'Cập nhật câu hỏi thành công',
      });
    } catch (e) {
      return _errorResponse('Lỗi dữ liệu: ${e.toString()}');
    }
  }

  Future<Response> _handleUpdateAnswer(Request request, String idStr) async {
    final id = int.tryParse(idStr);
    if (id == null) return _errorResponse('Mã đáp án không hợp lệ');

    try {
      final bodyStr = await request.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final content = body['content'] as String?;
      final isCorrect = body['isCorrect'] as bool?;

      final success = examService.updateAnswer(id, content: content, isCorrect: isCorrect);
      if (!success) return _errorResponse('Không tìm thấy đáp án để cập nhật', statusCode: 404);

      return _jsonResponse({
        'success': true,
        'message': 'Cập nhật đáp án thành công',
      });
    } catch (e) {
      return _errorResponse('Lỗi dữ liệu: ${e.toString()}');
    }
  }

  Future<Response> _handleStartSession(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final examId = body['examId'] as int?;
      final userName = body['userName'] as String? ?? 'Thí sinh';

      if (examId == null) {
        return _errorResponse('Vui lòng chọn examId');
      }

      final session = examService.startSession(examId, userName);
      return _jsonResponse({
        'success': true,
        'message': 'Bắt đầu phiên làm bài thi (75 phút)',
        'session': session.toJson(),
      });
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }

  Future<Response> _handleGetSessionStatus(Request request, String id) async {
    try {
      final status = examService.getSessionStatus(id);
      return _jsonResponse({
        'success': true,
        'status': status,
      });
    } catch (e) {
      return _errorResponse(e.toString(), statusCode: 404);
    }
  }

  Future<Response> _handleRecordAnswer(Request request, String id) async {
    try {
      final bodyStr = await request.readAsString();
      final body = jsonDecode(bodyStr) as Map<String, dynamic>;

      final questionId = body['questionId'] as int?;
      final selectedAnswer = body['selectedAnswer'] as String?; // null or 'A'..'D'

      if (questionId == null) {
        return _errorResponse('Thiếu questionId');
      }

      examService.recordUserAnswer(id, questionId, selectedAnswer);
      return _jsonResponse({
        'success': true,
        'message': 'Đã ghi nhận lựa chọn câu hỏi #$questionId',
        'selectedAnswer': selectedAnswer,
      });
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }

  Future<Response> _handleSubmitSession(Request request, String id) async {
    try {
      final bodyStr = await request.readAsString();
      final body = bodyStr.isNotEmpty ? jsonDecode(bodyStr) as Map<String, dynamic> : <String, dynamic>{};
      final forceSubmit = body['forceSubmit'] as bool? ?? false;

      final scoring = examService.submitSession(id, forceSubmit: forceSubmit);
      return _jsonResponse({
        'success': true,
        'message': 'Nộp bài và chấm điểm hoàn tất!',
        'result': scoring.toJson(),
      });
    } on UnansweredQuestionsException catch (e) {
      return _jsonResponse({
        'success': false,
        'isWarning': true,
        'unansweredCount': e.unansweredCount,
        'message': e.message,
      }, statusCode: 400);
    } catch (e) {
      return _errorResponse(e.toString());
    }
  }
}
