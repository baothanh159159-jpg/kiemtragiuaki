import 'dart:io';
import 'package:test/test.dart';
import 'package:toeic_backend/database/database_helper.dart';
import 'package:toeic_backend/services/docx_parser.dart';
import 'package:toeic_backend/services/exam_service.dart';
import 'package:toeic_backend/services/scoring_service.dart';

void main() {
  group('TOEIC Reading System Tests', () {
    late DatabaseHelper dbHelper;
    late ExamService examService;

    setUp(() {
      dbHelper = DatabaseHelper.openInMemory();
      examService = ExamService(dbHelper);
    });

    tearDown(() {
      dbHelper.close();
    });

    test('All-or-Nothing validation rejects invalid formats', () {
      final invalidLines = [
        '[EXAM_START]',
        '[EXAM_TITLE: Test Invalid]',
        '[EXAM_TIME: 75]',
        '[TOTAL_QUESTIONS: 2]',
        '[PART: 5]',
        '[Q: 101]',
        'Sample question without 4 options',
        '[A] Only option A',
        '[KEY: A]',
        '[/Q]',
        // Question 102 is missing
      ];

      final parseOutput = DocxParser.parseLines(invalidLines);
      expect(parseOutput.validationResult.isValid, isFalse);
      expect(parseOutput.validationResult.errors.isNotEmpty, isTrue);

      final errorMessages = parseOutput.validationResult.errors.map((e) => e.message).join('; ');
      print('Expected caught errors: $errorMessages');
      expect(errorMessages, contains('thiếu đáp án'));
    });

    test('Can parse and import real Reading_v01_Tagged.docx file', () {
      final file = File('c:\\Users\\ASUS\\Downloads\\kt\\Reading_v01_Tagged.docx');
      expect(file.existsSync(), isTrue, reason: 'File Reading_v01_Tagged.docx must exist');

      final bytes = file.readAsBytesSync();
      final importResult = examService.importExamFromDocx(bytes);

      expect(importResult.success, isTrue, reason: 'Import should succeed 100%');
      expect(importResult.examId, isNotNull);
      print('Imported Exam ID: ${importResult.examId}');

      // Verify in Database
      final exam = examService.getExamDetail(importResult.examId!);
      expect(exam, isNotNull);
      expect(exam!.totalQuestions, equals(100));
      expect(exam.parts.length, equals(3)); // Part 5, 6, 7

      final part5 = exam.parts.firstWhere((p) => p.partNumber == 5);
      final part6 = exam.parts.firstWhere((p) => p.partNumber == 6);
      final part7 = exam.parts.firstWhere((p) => p.partNumber == 7);

      expect(part5.independentQuestions.length, equals(30)); // 101 to 130
      expect(part6.passages.length, equals(4)); // 131 to 146 (16 questions)
      expect(part7.passages.length, equals(15)); // 147 to 200 (54 questions)

      int totalQCount = part5.independentQuestions.length;
      for (final pass in part6.passages) {
        totalQCount += pass.questions.length;
      }
      for (final pass in part7.passages) {
        totalQCount += pass.questions.length;
      }
      expect(totalQCount, equals(100));
      print('Verified database contents: $totalQCount questions loaded successfully!');

      // Check first question
      final q101 = part5.independentQuestions.first;
      expect(q101.questionNumber, equals(101));
      expect(q101.answers.length, equals(4));
      expect(q101.correctAnswerLabel, equals('B'));

      // Check last question
      final lastPassage = part7.passages.last;
      final q200 = lastPassage.questions.last;
      expect(q200.questionNumber, equals(200));
      expect(q200.answers.length, equals(4));
    });

    test('Can start exam session, answer questions, and calculate score', () {
      final file = File('c:\\Users\\ASUS\\Downloads\\kt\\Reading_v01_Tagged.docx');
      final bytes = file.readAsBytesSync();
      final importResult = examService.importExamFromDocx(bytes);
      final examId = importResult.examId!;

      // 1. Start session
      final session = examService.startSession(examId, 'Lê Vũ Bảo Thanh');
      expect(session.id, isNotEmpty);
      expect(session.userName, equals('Lê Vũ Bảo Thanh'));
      expect(session.durationSeconds, equals(4500));

      // 2. Answer question 101 correctly (key B)
      final exam = examService.getExamDetail(examId)!;
      final part5 = exam.parts.firstWhere((p) => p.partNumber == 5);
      final q101 = part5.independentQuestions.first;

      examService.recordUserAnswer(session.id, q101.id!, 'B');

      // 3. Answer question 102 wrongly
      final q102 = part5.independentQuestions[1];
      examService.recordUserAnswer(session.id, q102.id!, 'A');

      // 4. Check status
      final status = examService.getSessionStatus(session.id);
      expect(status['answeredQuestions'], equals(2));
      expect(status['unansweredQuestions'], equals(98));

      // 5. Submit with forceSubmit
      final result = examService.submitSession(session.id, forceSubmit: true);
      expect(result.correctCount, equals(1));
      expect(result.wrongCount, equals(1));
      expect(result.skippedCount, equals(98));
      expect(result.toeicScore, isPositive);
      print('Calculated score for 1 correct: ${result.toeicScore} points');
    });

    test('ScoringService ETS conversion accuracy', () {
      expect(ScoringService.convertToToeicScale(0), equals(5));
      expect(ScoringService.convertToToeicScale(50), equals(220));
      expect(ScoringService.convertToToeicScale(100), equals(495));
    });
  });
}
