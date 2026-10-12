import 'package:test/test.dart';
import 'package:toeic_backend/database/mssql_database_helper.dart';

void main() {
  group('Live Microsoft SQL Server 2022 Tests', () {
    late MssqlDatabaseHelper mssql;

    setUp(() {
      mssql = MssqlDatabaseHelper();
    });

    test('Can query live Microsoft SQL Server Exams table', () async {
      final exams = await mssql.getAllExams();
      expect(exams.isNotEmpty, isTrue, reason: 'Exams should exist in ToeicExamDb');

      final firstExam = exams.first;
      print('MSSQL Exam: #${firstExam.id} - ${firstExam.title}');
      expect(firstExam.durationMinutes, equals(75));
      expect(firstExam.totalQuestions, equals(100));
    });

    test('Can query full 100 questions and 3 parts from Microsoft SQL Server', () async {
      final exams = await mssql.getAllExams();
      final targetId = exams.first.id!;

      final exam = await mssql.getExamById(targetId, includeDetails: true);
      expect(exam, isNotNull);
      expect(exam!.parts.length, equals(3));

      final part5 = exam.parts.firstWhere((p) => p.partNumber == 5);
      final part6 = exam.parts.firstWhere((p) => p.partNumber == 6);
      final part7 = exam.parts.firstWhere((p) => p.partNumber == 7);

      expect(part5.independentQuestions.length, equals(30));
      expect(part6.passages.length, equals(4));
      expect(part7.passages.length, equals(15));

      int totalQ = part5.independentQuestions.length;
      for (final p in part6.passages) {
        totalQ += p.questions.length;
      }
      for (final p in part7.passages) {
        totalQ += p.questions.length;
      }

      print('Verified Microsoft SQL Server contains exactly: $totalQ questions!');
      expect(totalQ, equals(100));
    });

    test('Can simulate live exam session in Microsoft SQL Server', () async {
      final exams = await mssql.getAllExams();
      final targetId = exams.first.id!;
      final sessionId = 'test_sess_${DateTime.now().millisecondsSinceEpoch}';

      // 1. Create session
      await mssql.executeSql('''
        INSERT INTO dbo.UserExams (Id, ExamId, UserName, StartTime, DurationSeconds, IsSubmitted)
        VALUES ('$sessionId', $targetId, N'Lê Vũ Bảo Thanh', GETDATE(), 4500, 0);
      ''');

      // 2. Answer question
      final qSql = 'SELECT TOP 1 Id FROM dbo.Questions WHERE QuestionNumber = 101;';
      final qId = int.parse(await mssql.executeSql(qSql));
      await mssql.saveOrUpdateUserAnswer(sessionId, qId, 'B');

      // 3. Verify session
      final session = await mssql.getUserExamSession(sessionId);
      expect(session, isNotNull);
      expect(session!.userAnswers.length, equals(1));
      expect(session.userAnswers.first.selectedAnswer, equals('B'));

      // 4. Clean up test session
      await mssql.executeSql("DELETE FROM dbo.UserExams WHERE Id = '$sessionId';");
      print('Live MSSQL session test passed!');
    });
  });
}
