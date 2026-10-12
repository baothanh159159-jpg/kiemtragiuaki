import 'dart:convert';
import 'dart:io';
import '../models/exam.dart';
import '../models/exam_part.dart';
import '../models/passage.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../models/user_exam.dart';
import '../models/user_answer.dart';

/// Database helper connecting directly to Microsoft SQL Server (ToeicExamDb)
/// using SQL Server's native JSON engine (FOR JSON PATH).
class MssqlDatabaseHelper {
  final String server;
  final String database;

  MssqlDatabaseHelper({
    this.server = 'localhost',
    this.database = 'ToeicExamDb',
  });

  /// Executes a T-SQL query on Microsoft SQL Server and returns the output.
  Future<String> executeSql(String sql) async {
    final result = await Process.run('sqlcmd', [
      '-S', server,
      '-E',
      '-d', database,
      '-y', '0',
      '-Q', 'SET NOCOUNT ON; $sql',
    ], stdoutEncoding: systemEncoding);

    if (result.exitCode != 0) {
      throw Exception('SQL Server Error: ${result.stderr.toString().isNotEmpty ? result.stderr : result.stdout}');
    }

    return result.stdout.toString().trim();
  }

  String _sanitizeJson(String raw) {
    final buffer = StringBuffer();
    bool inString = false;
    bool escaped = false;
    for (int i = 0; i < raw.length; i++) {
      final char = raw[i];
      final code = char.codeUnitAt(0);

      if (char == '"' && !escaped) {
        inString = !inString;
        buffer.write(char);
      } else if (inString && (code < 0x20 || (code >= 0x7F && code <= 0x9F))) {
        if (char == '\n') {
          buffer.write(r'\n');
        } else if (char == '\r') {
          buffer.write(r'\r');
        } else if (char == '\t') {
          buffer.write(r'\t');
        } else {
          buffer.write(' ');
        }
      } else {
        buffer.write(char);
      }
      escaped = inString && (char == '\\') && !escaped;
    }
    return buffer.toString();
  }

  /// Executes a T-SQL query that returns JSON data
  Future<dynamic> _queryJson(String sql) async {
    final raw = await executeSql(sql);
    if (raw.isEmpty || raw == 'null') return null;

    final lines = raw.split(RegExp(r'\r?\n'));
    final cleanJson = lines
        .map((l) => l.trimRight())
        .where((l) => l.isNotEmpty && !l.startsWith('('))
        .join('');

    if (cleanJson.isEmpty || cleanJson == 'null') return null;
    final sanitized = _sanitizeJson(cleanJson);
    return jsonDecode(sanitized);
  }

  String _esc(String? s) {
    if (s == null) return 'NULL';
    return "N'" + s.replaceAll("'", "''") + "'";
  }

  /// Inserts exam into Microsoft SQL Server with strict All-or-Nothing Transaction.
  Future<int> insertExamAllOrNothing(Exam exam) async {
    final sb = StringBuffer();
    sb.writeln('BEGIN TRANSACTION;');
    sb.writeln('BEGIN TRY');

    sb.writeln('''
      DECLARE @ExamId INT;
      INSERT INTO dbo.Exams (Title, DurationMinutes, TotalQuestions, CreatedAt)
      VALUES (${_esc(exam.title)}, ${exam.durationMinutes}, ${exam.totalQuestions}, GETDATE());
      SET @ExamId = SCOPE_IDENTITY();
    ''');

    for (final part in exam.parts) {
      sb.writeln('''
        DECLARE @PartId_${part.partNumber} INT;
        INSERT INTO dbo.ExamParts (ExamId, PartNumber, Title, Instructions)
        VALUES (@ExamId, ${part.partNumber}, ${_esc(part.title)}, ${_esc(part.instructions)});
        SET @PartId_${part.partNumber} = SCOPE_IDENTITY();
      ''');

      for (final q in part.independentQuestions) {
        sb.writeln('''
          DECLARE @QId_${q.questionNumber} INT;
          INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
          VALUES (@ExamId, @PartId_${part.partNumber}, NULL, ${q.questionNumber}, ${_esc(q.content)}, ${_esc(q.explanation)}, ${q.orderIndex});
          SET @QId_${q.questionNumber} = SCOPE_IDENTITY();
        ''');

        for (final a in q.answers) {
          sb.writeln('''
            INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
            VALUES (@QId_${q.questionNumber}, ${_esc(a.label)}, ${_esc(a.content)}, ${a.isCorrect ? 1 : 0});
          ''');
        }
      }

      for (int pIdx = 0; pIdx < part.passages.length; pIdx++) {
        final passage = part.passages[pIdx];
        final pVar = '@PassageId_${part.partNumber}_$pIdx';
        sb.writeln('''
          DECLARE $pVar INT;
          INSERT INTO dbo.Passages (PartId, Title, Content, ImageName, OrderIndex)
          VALUES (@PartId_${part.partNumber}, ${_esc(passage.title)}, ${_esc(passage.content)}, ${_esc(passage.imageName)}, ${passage.orderIndex});
          SET $pVar = SCOPE_IDENTITY();
        ''');

        for (final q in passage.questions) {
          sb.writeln('''
            DECLARE @QId_${q.questionNumber} INT;
            INSERT INTO dbo.Questions (ExamId, PartId, PassageId, QuestionNumber, Content, Explanation, OrderIndex)
            VALUES (@ExamId, @PartId_${part.partNumber}, $pVar, ${q.questionNumber}, ${_esc(q.content)}, ${_esc(q.explanation)}, ${q.orderIndex});
            SET @QId_${q.questionNumber} = SCOPE_IDENTITY();
          ''');

          for (final a in q.answers) {
            sb.writeln('''
              INSERT INTO dbo.Answers (QuestionId, Label, Content, IsCorrect)
              VALUES (@QId_${q.questionNumber}, ${_esc(a.label)}, ${_esc(a.content)}, ${a.isCorrect ? 1 : 0});
            ''');
          }
        }
      }
    }

    sb.writeln('    COMMIT TRANSACTION;');
    sb.writeln("    SELECT @ExamId AS ExamId FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;");
    sb.writeln('END TRY');
    sb.writeln('BEGIN CATCH');
    sb.writeln('    ROLLBACK TRANSACTION;');
    sb.writeln('    THROW;');
    sb.writeln('END CATCH');

    final jsonRes = await _queryJson(sb.toString());
    return (jsonRes['ExamId'] as num).toInt();
  }

  Future<List<Exam>> getAllExams() async {
    const sql = '''
      SELECT 
        Id AS id, 
        Title AS title, 
        DurationMinutes AS duration_minutes, 
        TotalQuestions AS total_questions, 
        CONVERT(NVARCHAR(30), CreatedAt, 126) AS created_at
      FROM dbo.Exams
      ORDER BY Id DESC
      FOR JSON PATH;
    ''';
    final jsonList = await _queryJson(sql);
    if (jsonList == null || jsonList is! List) return [];
    return jsonList.map((m) => Exam.fromMap(m as Map<String, dynamic>)).toList();
  }

  Future<Exam?> getExamById(int id, {bool includeDetails = true}) async {
    final examSql = '''
      SELECT 
        Id AS id, 
        Title AS title, 
        DurationMinutes AS duration_minutes, 
        TotalQuestions AS total_questions, 
        CONVERT(NVARCHAR(30), CreatedAt, 126) AS created_at
      FROM dbo.Exams
      WHERE Id = $id
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
    ''';
    final examMap = await _queryJson(examSql);
    if (examMap == null || examMap is! Map<String, dynamic>) return null;

    if (!includeDetails) {
      return Exam.fromMap(examMap);
    }

    final partsSql = '''
      SELECT 
        Id AS id, 
        ExamId AS exam_id, 
        PartNumber AS part_number, 
        Title AS title, 
        Instructions AS instructions
      FROM dbo.ExamParts
      WHERE ExamId = $id
      ORDER BY PartNumber ASC
      FOR JSON PATH;
    ''';
    final partsJson = await _queryJson(partsSql) as List<dynamic>? ?? [];
    final parts = <ExamPart>[];

    for (final pItem in partsJson) {
      final pMap = pItem as Map<String, dynamic>;
      final partId = pMap['id'] as int;

      // Independent questions
      final indQSql = '''
        SELECT 
          q.Id AS id, 
          q.ExamId AS exam_id, 
          q.PartId AS part_id, 
          q.PassageId AS passage_id, 
          q.QuestionNumber AS question_number, 
          q.Content AS content, 
          q.Explanation AS explanation, 
          q.OrderIndex AS order_index,
          JSON_QUERY((
            SELECT Id AS id, QuestionId AS question_id, Label AS label, Content AS content, CAST(IsCorrect AS INT) AS is_correct
            FROM dbo.Answers a
            WHERE a.QuestionId = q.Id
            ORDER BY Label ASC
            FOR JSON PATH
          )) AS answers
        FROM dbo.Questions q
        WHERE q.PartId = $partId AND q.PassageId IS NULL
        ORDER BY q.QuestionNumber ASC
        FOR JSON PATH;
      ''';
      final indQJson = await _queryJson(indQSql) as List<dynamic>? ?? [];
      final independentQuestions = indQJson.map((qItem) {
        final qMap = qItem as Map<String, dynamic>;
        final ansRaw = qMap['answers'];
        final ansList = (ansRaw is List)
            ? ansRaw.map((a) => Answer.fromMap(a as Map<String, dynamic>)).toList()
            : <Answer>[];
        return Question.fromMap(qMap, answers: ansList);
      }).toList();

      // Passages
      final passSql = '''
        SELECT 
          Id AS id, 
          PartId AS part_id, 
          Title AS title, 
          Content AS content, 
          ImageName AS image_name, 
          OrderIndex AS order_index
        FROM dbo.Passages
        WHERE PartId = $partId
        ORDER BY OrderIndex ASC
        FOR JSON PATH;
      ''';
      final passJson = await _queryJson(passSql) as List<dynamic>? ?? [];
      final passages = <Passage>[];

      for (final passItem in passJson) {
        final passMap = passItem as Map<String, dynamic>;
        final passId = passMap['id'] as int;

        final qSql = '''
          SELECT 
            q.Id AS id, 
            q.ExamId AS exam_id, 
            q.PartId AS part_id, 
            q.PassageId AS passage_id, 
            q.QuestionNumber AS question_number, 
            q.Content AS content, 
            q.Explanation AS explanation, 
            q.OrderIndex AS order_index,
            JSON_QUERY((
              SELECT Id AS id, QuestionId AS question_id, Label AS label, Content AS content, CAST(IsCorrect AS INT) AS is_correct
              FROM dbo.Answers a
              WHERE a.QuestionId = q.Id
              ORDER BY Label ASC
              FOR JSON PATH
            )) AS answers
          FROM dbo.Questions q
          WHERE q.PassageId = $passId
          ORDER BY q.QuestionNumber ASC
          FOR JSON PATH;
        ''';
        final qJson = await _queryJson(qSql) as List<dynamic>? ?? [];
        final questions = qJson.map((qItem) {
          final qMap = qItem as Map<String, dynamic>;
          final ansRaw = qMap['answers'];
          final ansList = (ansRaw is List)
              ? ansRaw.map((a) => Answer.fromMap(a as Map<String, dynamic>)).toList()
              : <Answer>[];
          return Question.fromMap(qMap, answers: ansList);
        }).toList();

        passages.add(Passage.fromMap(passMap, questions: questions));
      }

      parts.add(ExamPart.fromMap(
        pMap,
        passages: passages,
        independentQuestions: independentQuestions,
      ));
    }

    return Exam.fromMap(examMap, parts: parts);
  }

  Future<bool> updateQuestion(int id, {String? content, String? explanation}) async {
    final updates = <String>[];
    if (content != null) updates.add("Content = ${_esc(content)}");
    if (explanation != null) updates.add("Explanation = ${_esc(explanation)}");
    if (updates.isEmpty) return false;

    final sql = "UPDATE dbo.Questions SET ${updates.join(', ')} WHERE Id = $id;";
    await executeSql(sql);
    return true;
  }

  Future<bool> updateAnswer(int answerId, {String? content, bool? isCorrect}) async {
    final updates = <String>[];
    if (content != null) updates.add("Content = ${_esc(content)}");
    if (isCorrect != null) updates.add("IsCorrect = ${isCorrect ? 1 : 0}");
    if (updates.isEmpty) return false;

    final sql = "UPDATE dbo.Answers SET ${updates.join(', ')} WHERE Id = $answerId;";
    await executeSql(sql);
    return true;
  }

  Future<void> saveUserExamSession(UserExam session) async {
    final sql = '''
      INSERT INTO dbo.UserExams (Id, ExamId, UserName, StartTime, DurationSeconds, IsSubmitted)
      VALUES (${_esc(session.id)}, ${session.examId}, ${_esc(session.userName)}, ${_esc(session.startTime.toIso8601String())}, ${session.durationSeconds}, ${session.isSubmitted ? 1 : 0});
    ''';
    await executeSql(sql);
  }

  Future<UserExam?> getUserExamSession(String sessionId) async {
    final sql = '''
      SELECT 
        Id AS id, 
        ExamId AS exam_id, 
        UserName AS user_name, 
        CONVERT(NVARCHAR(30), StartTime, 126) AS start_time, 
        CONVERT(NVARCHAR(30), EndTime, 126) AS end_time, 
        DurationSeconds AS duration_seconds, 
        CAST(IsSubmitted AS INT) AS is_submitted, 
        Score AS score, 
        CorrectCount AS correct_count, 
        WrongCount AS wrong_count, 
        SkippedCount AS skipped_count
      FROM dbo.UserExams
      WHERE Id = ${_esc(sessionId)}
      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
    ''';
    final map = await _queryJson(sql);
    if (map == null || map is! Map<String, dynamic>) return null;

    final ansSql = '''
      SELECT 
        ua.Id AS id, 
        ua.UserExamId AS user_exam_id, 
        ua.QuestionId AS question_id, 
        q.QuestionNumber AS question_number, 
        ua.SelectedAnswer AS selected_answer, 
        CAST(ua.IsCorrect AS INT) AS is_correct, 
        CONVERT(NVARCHAR(30), ua.UpdatedAt, 126) AS updated_at
      FROM dbo.UserAnswers ua
      JOIN dbo.Questions q ON ua.QuestionId = q.Id
      WHERE ua.UserExamId = ${_esc(sessionId)}
      ORDER BY q.QuestionNumber ASC
      FOR JSON PATH;
    ''';
    final ansJson = await _queryJson(ansSql) as List<dynamic>? ?? [];
    final answers = ansJson.map((r) => UserAnswer.fromMap(r as Map<String, dynamic>)).toList();

    return UserExam.fromMap(map, userAnswers: answers);
  }

  Future<void> saveOrUpdateUserAnswer(String sessionId, int questionId, String? selectedAnswer) async {
    final sql = '''
      MERGE INTO dbo.UserAnswers AS target
      USING (SELECT ${_esc(sessionId)} AS UserExamId, $questionId AS QuestionId) AS source
      ON target.UserExamId = source.UserExamId AND target.QuestionId = source.QuestionId
      WHEN MATCHED THEN
        UPDATE SET SelectedAnswer = ${_esc(selectedAnswer)}, UpdatedAt = GETDATE()
      WHEN NOT MATCHED THEN
        INSERT (UserExamId, QuestionId, SelectedAnswer, UpdatedAt)
        VALUES (${_esc(sessionId)}, $questionId, ${_esc(selectedAnswer)}, GETDATE());
    ''';
    await executeSql(sql);
  }

  Future<void> completeUserExamSession({
    required String sessionId,
    required DateTime endTime,
    required int score,
    required int correctCount,
    required int wrongCount,
    required int skippedCount,
  }) async {
    final sql = '''
      UPDATE dbo.UserExams SET
        EndTime = ${_esc(endTime.toIso8601String())},
        IsSubmitted = 1,
        Score = $score,
        CorrectCount = $correctCount,
        WrongCount = $wrongCount,
        SkippedCount = $skippedCount
      WHERE Id = ${_esc(sessionId)};
    ''';
    await executeSql(sql);
  }
}
