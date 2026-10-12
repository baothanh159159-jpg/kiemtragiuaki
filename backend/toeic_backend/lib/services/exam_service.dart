import 'dart:typed_data';
import '../database/database_helper.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../models/user_exam.dart';
import '../models/validation_error.dart';
import 'docx_parser.dart';
import 'scoring_service.dart';

class ImportExamResponse {
  final bool success;
  final int? examId;
  final Exam? exam;
  final ValidationResult validationResult;

  ImportExamResponse({
    required this.success,
    this.examId,
    this.exam,
    required this.validationResult,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (examId != null) 'examId': examId,
      'validation': validationResult.toJson(),
    };
  }
}

class ExamService {
  final DatabaseHelper dbHelper;

  ExamService(this.dbHelper);

  /// Imports an exam from a .docx file with strict All-or-Nothing validation.
  ImportExamResponse importExamFromDocx(Uint8List bytes) {
    final parseOutput = DocxParser.parseDocxBytes(bytes);

    if (!parseOutput.validationResult.isValid || parseOutput.exam == null) {
      return ImportExamResponse(
        success: false,
        validationResult: parseOutput.validationResult,
      );
    }

    try {
      final examId = dbHelper.insertExamAllOrNothing(parseOutput.exam!);
      final savedExam = dbHelper.getExamById(examId);

      return ImportExamResponse(
        success: true,
        examId: examId,
        exam: savedExam,
        validationResult: ValidationResult.success(),
      );
    } catch (e) {
      return ImportExamResponse(
        success: false,
        validationResult: ValidationResult.failure([
          ValidationError(
            errorCode: 'DB_INSERT_ERROR',
            message: 'Lỗi ghi cơ sở dữ liệu: ${e.toString()}',
          ),
        ]),
      );
    }
  }

  List<Exam> getExamsList() {
    return dbHelper.getAllExams();
  }

  Exam? getExamDetail(int id, {bool isStudent = false}) {
    final exam = dbHelper.getExamById(id, includeDetails: true);
    return exam;
  }

  bool updateQuestion(int id, {
    String? content,
    String? explanation,
    String? correctAnswer,
    Map<String, String>? options,
  }) {
    return dbHelper.updateQuestion(
      id,
      content: content,
      explanation: explanation,
      correctAnswer: correctAnswer,
      options: options,
    );
  }

  bool updatePassage(int id, {String? title, String? content}) {
    return dbHelper.updatePassage(id, title: title, content: content);
  }

  bool updateExam(int id, {String? title, int? durationMinutes}) {
    return dbHelper.updateExam(id, title: title, durationMinutes: durationMinutes);
  }

  bool updateAnswer(int id, {String? content, bool? isCorrect}) {
    return dbHelper.updateAnswer(id, content: content, isCorrect: isCorrect);
  }

  UserExam startSession(int examId, String userName) {
    final exam = dbHelper.getExamById(examId, includeDetails: false);
    if (exam == null) {
      throw Exception('Không tìm thấy đề thi với ID $examId');
    }

    // Generate unique session id
    final sessionId = 'sess_${DateTime.now().millisecondsSinceEpoch}_${(userName.hashCode & 0xFFFF)}';
    final session = UserExam(
      id: sessionId,
      examId: examId,
      userName: userName,
      startTime: DateTime.now(),
      durationSeconds: exam.durationMinutes * 60,
      isSubmitted: false,
    );

    dbHelper.saveUserExamSession(session);
    return session;
  }

  void recordUserAnswer(String sessionId, int questionId, String? selectedAnswer) {
    final session = dbHelper.getUserExamSession(sessionId);
    if (session == null) {
      throw Exception('Không tìm thấy phiên làm bài $sessionId');
    }
    if (session.isSubmitted) {
      throw Exception('Bài thi đã nộp, không thể thay đổi đáp án');
    }
    if (session.isExpired) {
      // Auto submit if expired
      submitSession(sessionId, forceSubmit: true);
      throw Exception('Hết thời gian làm bài, hệ thống đã tự động thu bài');
    }

    dbHelper.saveOrUpdateUserAnswer(sessionId, questionId, selectedAnswer);
  }

  Map<String, dynamic> getSessionStatus(String sessionId) {
    final session = dbHelper.getUserExamSession(sessionId);
    if (session == null) {
      throw Exception('Không tìm thấy phiên làm bài $sessionId');
    }

    final exam = dbHelper.getExamById(session.examId, includeDetails: true);
    if (exam == null) {
      throw Exception('Không tìm thấy thông tin đề thi');
    }

    final allQuestions = <Question>[];
    for (final p in exam.parts) {
      allQuestions.addAll(p.independentQuestions);
      for (final pass in p.passages) {
        allQuestions.addAll(pass.questions);
      }
    }

    final answeredQuestionIds = session.userAnswers
        .where((a) => a.selectedAnswer != null && a.selectedAnswer!.isNotEmpty)
        .map((a) => a.questionId)
        .toSet();

    final totalCount = allQuestions.length;
    final answeredCount = answeredQuestionIds.length;
    final remainingCount = totalCount - answeredCount;

    return {
      'sessionId': session.id,
      'userName': session.userName,
      'examTitle': exam.title,
      'startTime': session.startTime.toIso8601String(),
      'durationSeconds': session.durationSeconds,
      'remainingSeconds': session.remainingSeconds,
      'isSubmitted': session.isSubmitted,
      'isExpired': session.isExpired,
      'totalQuestions': totalCount,
      'answeredQuestions': answeredCount,
      'unansweredQuestions': remainingCount,
      'userAnswers': session.userAnswers.map((a) => a.toJson()).toList(),
    };
  }

  ExamScoringResult submitSession(String sessionId, {bool forceSubmit = false}) {
    final session = dbHelper.getUserExamSession(sessionId);
    if (session == null) {
      throw Exception('Không tìm thấy phiên làm bài $sessionId');
    }

    final exam = dbHelper.getExamById(session.examId, includeDetails: true);
    if (exam == null) {
      throw Exception('Không tìm thấy đề thi');
    }

    final correctAnswersMap = <int, String>{};
    final explanationsMap = <int, String?>{};
    final questionIdToNumber = <int, int>{};

    for (final p in exam.parts) {
      for (final q in p.independentQuestions) {
        correctAnswersMap[q.questionNumber] = q.correctAnswerLabel ?? 'A';
        explanationsMap[q.questionNumber] = q.explanation;
        if (q.id != null) questionIdToNumber[q.id!] = q.questionNumber;
      }
      for (final pass in p.passages) {
        for (final q in pass.questions) {
          correctAnswersMap[q.questionNumber] = q.correctAnswerLabel ?? 'A';
          explanationsMap[q.questionNumber] = q.explanation;
          if (q.id != null) questionIdToNumber[q.id!] = q.questionNumber;
        }
      }
    }

    // Map user answers
    final userAnswersMap = <int, String?>{};
    for (final ua in session.userAnswers) {
      final qNum = ua.questionNumber ?? questionIdToNumber[ua.questionId];
      if (qNum != null) {
        userAnswersMap[qNum] = ua.selectedAnswer;
      }
    }

    // Check unanswered questions
    int unanswered = 0;
    for (final qNum in correctAnswersMap.keys) {
      if (userAnswersMap[qNum] == null || userAnswersMap[qNum]!.isEmpty) {
        unanswered++;
      }
    }

    // If there are unanswered questions and not forceSubmit and not expired
    if (unanswered > 0 && !forceSubmit && !session.isExpired && !session.isSubmitted) {
      throw UnansweredQuestionsException(
        unansweredCount: unanswered,
        message: 'Bạn còn $unanswered câu chưa hoàn thành. Vui lòng xác nhận để nộp bài.',
      );
    }

    final scoringResult = ScoringService.calculateScore(
      correctAnswersMap: correctAnswersMap,
      userAnswersMap: userAnswersMap,
      explanationsMap: explanationsMap,
    );

    dbHelper.completeUserExamSession(
      sessionId: sessionId,
      endTime: DateTime.now(),
      score: scoringResult.toeicScore,
      correctCount: scoringResult.correctCount,
      wrongCount: scoringResult.wrongCount,
      skippedCount: scoringResult.skippedCount,
    );

    return scoringResult;
  }
}

class UnansweredQuestionsException implements Exception {
  final int unansweredCount;
  final String message;

  UnansweredQuestionsException({
    required this.unansweredCount,
    required this.message,
  });

  @override
  String toString() => message;
}
