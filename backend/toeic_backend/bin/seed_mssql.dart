import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:toeic_backend/services/docx_parser.dart';

void main() async {
  print('====================================================');
  print('  MSSQL SEEDER: TOEIC READING 100 QUESTIONS');
  print('====================================================');

  final docxPath = 'c:\\Users\\ASUS\\Downloads\\kt\\Reading_v01_Tagged.docx';
  final docxFile = File(docxPath);
  if (!docxFile.existsSync()) {
    print('Error: Could not find file at $docxPath');
    exit(1);
  }

  print('Reading and parsing $docxPath...');
  final bytes = docxFile.readAsBytesSync();
  final parseOutput = DocxParser.parseDocxBytes(bytes);

  if (!parseOutput.validationResult.isValid || parseOutput.exam == null) {
    print('Validation failed:');
    for (final e in parseOutput.validationResult.errors) {
      print(' - ${e.message}');
    }
    exit(1);
  }

  final exam = parseOutput.exam!;
  print('Successfully parsed exam: "${exam.title}"');
  print('Total parts: ${exam.parts.length}');

  // Generate T-SQL script
  final sb = StringBuffer();
  sb.writeln('USE ToeicExamDb;');
  sb.writeln('GO');
  sb.writeln('SET NOCOUNT ON;');
  sb.writeln('BEGIN TRANSACTION;');
  sb.writeln('BEGIN TRY');

  // Escape SQL strings
  String esc(String? s) {
    if (s == null) return "NULL";
    return "N'" + s.replaceAll("'", "''") + "'";
  }

  // 1. Insert Exam
  sb.writeln('''
    DECLARE @ExamId INT;
    INSERT INTO dbo.Exams (Title, DurationMinutes, TotalQuestions, CreatedAt)
    VALUES (${esc(exam.title)}, ${exam.durationMinutes}, ${exam.totalQuestions}, GETDATE());
    SET @ExamId = SCOPE_IDENTITY();
  ''');

  int totalQCount = 0;
  int totalAnsCount = 0;

  for (final part in exam.parts) {
    sb.writeln('''
      DECLARE @PartId_${part.partNumber} INT;
      INSERT INTO dbo.ExamParts (ExamId, PartNumber, Title, Instructions)
      VALUES (@ExamId, ${part.partNumber}, ${esc(part.title)}, ${esc(part.instructions)});
      SET @PartId_${part.partNumber} = SCOPE_IDENTITY();
    ''');

    // Part 5 independent questions
    for (final q in part.independentQuestions) {
      totalQCount++;
      sb.writeln('''
        DECLARE @QId_${q.questionNumber} INT;
        INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
        VALUES (@ExamId, @PartId_${part.partNumber}, NULL, ${q.questionNumber}, ${esc(q.content)}, ${esc(q.explanation)}, ${q.orderIndex});
        SET @QId_${q.questionNumber} = SCOPE_IDENTITY();
      ''');

      for (final a in q.answers) {
        totalAnsCount++;
        sb.writeln('''
          INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
          VALUES (@QId_${q.questionNumber}, ${esc(a.label)}, ${esc(a.content)}, ${a.isCorrect ? 1 : 0});
        ''');
      }
    }

    // Part 6 & 7 Passages
    for (int pIdx = 0; pIdx < part.passages.length; pIdx++) {
      final passage = part.passages[pIdx];
      final pVar = '@PassageId_${part.partNumber}_$pIdx';
      sb.writeln('''
        DECLARE $pVar INT;
        INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
        VALUES (@PartId_${part.partNumber}, ${esc(passage.title)}, ${esc(passage.content)}, ${esc(passage.imageName)}, ${passage.orderIndex});
        SET $pVar = SCOPE_IDENTITY();
      ''');

      for (final q in passage.questions) {
        totalQCount++;
        sb.writeln('''
          DECLARE @QId_${q.questionNumber} INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_${part.partNumber}, $pVar, ${q.questionNumber}, ${esc(q.content)}, ${esc(q.explanation)}, ${q.orderIndex});
          SET @QId_${q.questionNumber} = SCOPE_IDENTITY();
        ''');

        for (final a in q.answers) {
          totalAnsCount++;
          sb.writeln('''
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_${q.questionNumber}, ${esc(a.label)}, ${esc(a.content)}, ${a.isCorrect ? 1 : 0});
          ''');
        }
      }
    }
  }

  sb.writeln('    COMMIT TRANSACTION;');
  sb.writeln("    PRINT N'SEED MSSQL THANH CONG: 1 EXAM, $totalQCount QUESTIONS, $totalAnsCount ANSWERS!';");
  sb.writeln('END TRY');
  sb.writeln('BEGIN CATCH');
  sb.writeln('    ROLLBACK TRANSACTION;');
  sb.writeln("    PRINT N'SEED MSSQL THAT BAI: ' + ERROR_MESSAGE();");
  sb.writeln('    THROW;');
  sb.writeln('END CATCH');
  sb.writeln('GO');

  final outSqlPath = p.join(Directory.current.path, 'sql', 'seed_exam_data.sql');
  File(outSqlPath).writeAsStringSync(sb.toString());
  print('Saved T-SQL seed script to: $outSqlPath');

  print('Executing seed script on Microsoft SQL Server (localhost)...');
  final result = await Process.run('sqlcmd', [
    '-S', 'localhost',
    '-E',
    '-d', 'ToeicExamDb',
    '-f', '65001',
    '-i', outSqlPath,
  ]);

  print(result.stdout);
  if (result.stderr.toString().isNotEmpty) {
    print('Errors: ${result.stderr}');
  }
}
