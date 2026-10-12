import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:toeic_backend/database/database_helper.dart';
import 'package:toeic_backend/services/exam_service.dart';
import 'package:toeic_backend/controllers/api_controller.dart';
import 'package:toeic_backend/controllers/admin_web_controller.dart';
import 'package:shelf_router/shelf_router.dart';

void main() {
  group('Server Route Integration Tests', () {
    late DatabaseHelper dbHelper;
    late ExamService examService;
    late Handler handler;

    setUp(() {
      dbHelper = DatabaseHelper.openInMemory();
      examService = ExamService(dbHelper);

      final router = Router();
      final apiCtrl = ApiController(examService);
      final webCtrl = AdminWebController();

      router.mount('/', webCtrl.router.call);
      router.mount('/', apiCtrl.router.call);

      handler = const Pipeline().addHandler(router.call);
    });

    tearDown(() {
      dbHelper.close();
    });

    test('GET / renders Web Admin Dashboard HTML', () async {
      final request = Request('GET', Uri.parse('http://localhost/'));
      final response = await handler(request);

      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], contains('text/html'));
      final body = await response.readAsString();
      expect(body, contains('TOEIC Reading System'));
      expect(body, contains('All-or-Nothing'));
    });

    test('GET /api/exams returns JSON list', () async {
      final request = Request('GET', Uri.parse('http://localhost/api/exams'));
      final response = await handler(request);

      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], contains('application/json'));
      final body = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      expect(body['exams'], isList);
    });
  });
}
