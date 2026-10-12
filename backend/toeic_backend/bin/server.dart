import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:toeic_backend/database/database_helper.dart';
import 'package:toeic_backend/services/exam_service.dart';
import 'package:toeic_backend/controllers/api_controller.dart';
import 'package:toeic_backend/controllers/admin_web_controller.dart';

void main(List<String> args) async {
  // Use PORT environment variable or default to 8080
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Database initialization
  final dbPath = p.join(Directory.current.path, 'toeic_reading.db');
  print('Initializing SQLite database at: $dbPath');
  final dbHelper = DatabaseHelper.openFile(dbPath);
  final examService = ExamService(dbHelper);

  // Auto-seed Reading_v01_Tagged.docx if no exams exist yet
  final existingExams = examService.getExamsList();
  if (existingExams.isEmpty) {
    print('Empty database detected. Checking for Reading_v01_Tagged.docx to auto-import...');
    final sampleDocxCandidates = [
      p.join(Directory.current.path, 'Reading_v01_Tagged.docx'),
      p.join(Directory.current.parent.path, 'Reading_v01_Tagged.docx'),
      p.join(Directory.current.parent.parent.path, 'Reading_v01_Tagged.docx'),
      'c:\\Users\\ASUS\\Downloads\\kt\\Reading_v01_Tagged.docx',
    ];

    File? foundFile;
    for (final candidate in sampleDocxCandidates) {
      final f = File(candidate);
      if (f.existsSync()) {
        foundFile = f;
        break;
      }
    }

    if (foundFile != null) {
      print('Auto-importing sample exam from: ${foundFile.path}');
      try {
        final bytes = foundFile.readAsBytesSync();
        final importRes = examService.importExamFromDocx(bytes);
        if (importRes.success) {
          print('Successfully pre-loaded exam #${importRes.examId} (${importRes.exam?.totalQuestions} questions, 3 parts)!');
        } else {
          print('Auto-import warning: ${importRes.validationResult.errors.map((e) => e.message).join('; ')}');
        }
      } catch (e) {
        print('Auto-import error: $e');
      }
    }
  } else {
    print('Database already contains ${existingExams.length} exams.');
  }

  // Setup Routes
  final mainRouter = Router();

  final apiController = ApiController(examService);
  final adminWebController = AdminWebController();

  mainRouter.mount('/', adminWebController.router.call);
  mainRouter.mount('/', apiController.router.call);

  // Pipeline with CORS and Logging
  final handler = const Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(mainRouter.call);

  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('===============================================================');
  print('  TOEIC READING EXAMINATION SYSTEM (DART BACKEND)');
  print('===============================================================');
  print('  HTTP Server running at: http://localhost:${server.port}');
  print('  Web Admin Dashboard:    http://localhost:${server.port}/admin/');
  print('  REST API Base URL:      http://localhost:${server.port}/api/');
  print('===============================================================');
}
