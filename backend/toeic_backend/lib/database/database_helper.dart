import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import '../models/exam.dart';
import '../models/exam_part.dart';
import '../models/passage.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../models/user_exam.dart';
import '../models/user_answer.dart';

class DatabaseHelper {
  final Database _db;

  DatabaseHelper(this._db) {
    _initSchema();
  }

  factory DatabaseHelper.openFile(String path) {
    final file = File(path);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    final db = sqlite3.open(path);
    return DatabaseHelper(db);
  }

  factory DatabaseHelper.openInMemory() {
    final db = sqlite3.openInMemory();
    return DatabaseHelper(db);
  }

  Database get db => _db;

  void close() {
    _db.close();
  }

  void _initSchema() {
    _db.execute('PRAGMA foreign_keys = ON;');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS exams (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL DEFAULT 75,
        total_questions INTEGER NOT NULL DEFAULT 100,
        created_at TEXT NOT NULL
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS exam_parts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER NOT NULL,
        part_number INTEGER NOT NULL,
        title TEXT NOT NULL,
        instructions TEXT,
        FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS passages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        part_id INTEGER NOT NULL,
        title TEXT,
        content TEXT NOT NULL,
        image_name TEXT,
        order_index INTEGER DEFAULT 0,
        FOREIGN KEY (part_id) REFERENCES exam_parts(id) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exam_id INTEGER NOT NULL,
        part_id INTEGER NOT NULL,
        passage_id INTEGER,
        question_number INTEGER NOT NULL,
        content TEXT NOT NULL,
        explanation TEXT,
        order_index INTEGER DEFAULT 0,
        FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
        FOREIGN KEY (part_id) REFERENCES exam_parts(id) ON DELETE CASCADE,
        FOREIGN KEY (passage_id) REFERENCES passages(id) ON DELETE SET NULL
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        label TEXT NOT NULL,
        content TEXT NOT NULL,
        is_correct INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS user_exams (
        id TEXT PRIMARY KEY,
        exam_id INTEGER NOT NULL,
        user_name TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        duration_seconds INTEGER DEFAULT 4500,
        is_submitted INTEGER DEFAULT 0,
        score INTEGER DEFAULT 0,
        correct_count INTEGER DEFAULT 0,
        wrong_count INTEGER DEFAULT 0,
        skipped_count INTEGER DEFAULT 0,
        FOREIGN KEY (exam_id) REFERENCES exams(id)
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS user_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_exam_id TEXT NOT NULL,
        question_id INTEGER NOT NULL,
        selected_answer TEXT,
        is_correct INTEGER,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_exam_id) REFERENCES user_exams(id) ON DELETE CASCADE,
        FOREIGN KEY (question_id) REFERENCES questions(id),
        UNIQUE(user_exam_id, question_id)
      );
    ''');

    // Create Indexes for query performance
    _db.execute('CREATE INDEX IF NOT EXISTS idx_questions_exam ON questions(exam_id);');
    _db.execute('CREATE INDEX IF NOT EXISTS idx_questions_passage ON questions(passage_id);');
    _db.execute('CREATE INDEX IF NOT EXISTS idx_answers_question ON answers(question_id);');
    _db.execute('CREATE INDEX IF NOT EXISTS idx_user_answers_session ON user_answers(user_exam_id);');
  }

  /// Inserts a fully validated Exam into the database using a strict TRANSACTION (All-or-Nothing).
  int insertExamAllOrNothing(Exam exam) {
    _db.execute('BEGIN TRANSACTION;');
    try {
      final stmtExam = _db.prepare(
        'INSERT INTO exams (title, duration_minutes, total_questions, created_at) VALUES (?, ?, ?, ?) RETURNING id;',
      );
      final examRow = stmtExam.select([
        exam.title,
        exam.durationMinutes,
        exam.totalQuestions,
        exam.createdAt.toIso8601String(),
      ]);
      stmtExam.close();
      final examId = examRow.first['id'] as int;

      for (final part in exam.parts) {
        final stmtPart = _db.prepare(
          'INSERT INTO exam_parts (exam_id, part_number, title, instructions) VALUES (?, ?, ?, ?) RETURNING id;',
        );
        final partRow = stmtPart.select([
          examId,
          part.partNumber,
          part.title,
          part.instructions,
        ]);
        stmtPart.close();
        final partId = partRow.first['id'] as int;

        // Insert independent questions (Part 5)
        for (final q in part.independentQuestions) {
          _insertQuestion(examId, partId, null, q);
        }

        // Insert passages and their questions (Part 6 & 7)
        for (final passage in part.passages) {
          final stmtPassage = _db.prepare(
            'INSERT INTO passages (part_id, title, content, image_name, order_index) VALUES (?, ?, ?, ?, ?) RETURNING id;',
          );
          final passageRow = stmtPassage.select([
            partId,
            passage.title,
            passage.content,
            passage.imageName,
            passage.orderIndex,
          ]);
          stmtPassage.close();
          final passageId = passageRow.first['id'] as int;

          for (final q in passage.questions) {
            _insertQuestion(examId, partId, passageId, q);
          }
        }
      }

      _db.execute('COMMIT;');
      return examId;
    } catch (e) {
      _db.execute('ROLLBACK;');
      rethrow;
    }
  }

  void _insertQuestion(int examId, int partId, int? passageId, Question q) {
    final stmtQ = _db.prepare(
      'INSERT INTO questions (exam_id, part_id, passage_id, question_number, content, explanation, order_index) VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING id;',
    );
    final qRow = stmtQ.select([
      examId,
      partId,
      passageId,
      q.questionNumber,
      q.content,
      q.explanation,
      q.orderIndex,
    ]);
    stmtQ.close();
    final qId = qRow.first['id'] as int;

    final stmtAns = _db.prepare(
      'INSERT INTO answers (question_id, label, content, is_correct) VALUES (?, ?, ?, ?);',
    );
    for (final ans in q.answers) {
      stmtAns.execute([
        qId,
        ans.label,
        ans.content,
        ans.isCorrect ? 1 : 0,
      ]);
    }
    stmtAns.close();
  }

  List<Exam> getAllExams() {
    final rows = _db.select('SELECT * FROM exams ORDER BY id DESC;');
    return rows.map((r) => Exam.fromMap(r)).toList();
  }

  Exam? getExamById(int id, {bool includeDetails = true}) {
    final examRows = _db.select('SELECT * FROM exams WHERE id = ?;', [id]);
    if (examRows.isEmpty) return null;
    final examMap = examRows.first;

    if (!includeDetails) {
      return Exam.fromMap(examMap);
    }

    final partRows = _db.select('SELECT * FROM exam_parts WHERE exam_id = ? ORDER BY part_number ASC;', [id]);
    final parts = <ExamPart>[];

    for (final pRow in partRows) {
      final partId = pRow['id'] as int;

      // Independent questions
      final indQRows = _db.select(
        'SELECT * FROM questions WHERE part_id = ? AND passage_id IS NULL ORDER BY question_number ASC;',
        [partId],
      );
      final independentQuestions = indQRows.map((qRow) {
        final qId = qRow['id'] as int;
        final ansRows = _db.select('SELECT * FROM answers WHERE question_id = ? ORDER BY label ASC;', [qId]);
        final answers = ansRows.map((a) => Answer.fromMap(a)).toList();
        return Question.fromMap(qRow, answers: answers);
      }).toList();

      // Passages
      final passageRows = _db.select('SELECT * FROM passages WHERE part_id = ? ORDER BY order_index ASC;', [partId]);
      final passages = passageRows.map((passRow) {
        final passId = passRow['id'] as int;
        final qRows = _db.select(
          'SELECT * FROM questions WHERE passage_id = ? ORDER BY question_number ASC;',
          [passId],
        );
        final questions = qRows.map((qRow) {
          final qId = qRow['id'] as int;
          final ansRows = _db.select('SELECT * FROM answers WHERE question_id = ? ORDER BY label ASC;', [qId]);
          final answers = ansRows.map((a) => Answer.fromMap(a)).toList();
          return Question.fromMap(qRow, answers: answers);
        }).toList();
        return Passage.fromMap(passRow, questions: questions);
      }).toList();

      parts.add(ExamPart.fromMap(
        pRow,
        passages: passages,
        independentQuestions: independentQuestions,
      ));
    }

    return Exam.fromMap(examMap, parts: parts);
  }

  bool updateQuestion(int id, {
    String? content,
    String? explanation,
    String? correctAnswer,
    Map<String, String>? options,
  }) {
    final updates = <String>[];
    final params = <dynamic>[];
    if (content != null) {
      updates.add('content = ?');
      params.add(content);
    }
    if (explanation != null) {
      updates.add('explanation = ?');
      params.add(explanation);
    }
    if (updates.isNotEmpty) {
      params.add(id);
      _db.execute('UPDATE questions SET ${updates.join(', ')} WHERE id = ?;', params);
    }

    // Update options if provided
    if (options != null) {
      for (final entry in options.entries) {
        final label = entry.key;
        final text = entry.value;
        _db.execute(
          'UPDATE answers SET content = ? WHERE question_id = ? AND label = ?;',
          [text, id, label],
        );
      }
    }

    // Update correctAnswer if provided
    if (correctAnswer != null && correctAnswer.isNotEmpty) {
      _db.execute(
        'UPDATE answers SET is_correct = CASE WHEN label = ? THEN 1 ELSE 0 END WHERE question_id = ?;',
        [correctAnswer, id],
      );
    }

    return true;
  }

  bool updatePassage(int passageId, {String? title, String? content}) {
    final updates = <String>[];
    final params = <dynamic>[];
    if (title != null) {
      updates.add('title = ?');
      params.add(title);
    }
    if (content != null) {
      updates.add('content = ?');
      params.add(content);
    }
    if (updates.isEmpty) return false;
    params.add(passageId);
    _db.execute('UPDATE passages SET ${updates.join(', ')} WHERE id = ?;', params);
    return true;
  }

  bool updateExam(int examId, {String? title, int? durationMinutes}) {
    final updates = <String>[];
    final params = <dynamic>[];
    if (title != null) {
      updates.add('title = ?');
      params.add(title);
    }
    if (durationMinutes != null) {
      updates.add('duration_minutes = ?');
      params.add(durationMinutes);
    }
    if (updates.isEmpty) return false;
    params.add(examId);
    _db.execute('UPDATE exams SET ${updates.join(', ')} WHERE id = ?;', params);
    return true;
  }

  bool updateAnswer(int answerId, {String? content, bool? isCorrect}) {
    final updates = <String>[];
    final params = <dynamic>[];
    if (content != null) {
      updates.add('content = ?');
      params.add(content);
    }
    if (isCorrect != null) {
      updates.add('is_correct = ?');
      params.add(isCorrect ? 1 : 0);
    }
    if (updates.isEmpty) return false;
    params.add(answerId);
    _db.execute('UPDATE answers SET ${updates.join(', ')} WHERE id = ?;', params);
    return true;
  }

  void saveUserExamSession(UserExam session) {
    final stmt = _db.prepare('''
      INSERT INTO user_exams (id, exam_id, user_name, start_time, duration_seconds, is_submitted)
      VALUES (?, ?, ?, ?, ?, ?);
    ''');
    stmt.execute([
      session.id,
      session.examId,
      session.userName,
      session.startTime.toIso8601String(),
      session.durationSeconds,
      session.isSubmitted ? 1 : 0,
    ]);
    stmt.close();
  }

  UserExam? getUserExamSession(String sessionId) {
    final rows = _db.select('SELECT * FROM user_exams WHERE id = ?;', [sessionId]);
    if (rows.isEmpty) return null;
    final sessionMap = rows.first;

    final ansRows = _db.select('''
      SELECT ua.*, q.question_number
      FROM user_answers ua
      JOIN questions q ON ua.question_id = q.id
      WHERE ua.user_exam_id = ?
      ORDER BY q.question_number ASC;
    ''', [sessionId]);

    final answers = ansRows.map((r) => UserAnswer.fromMap(r)).toList();
    return UserExam.fromMap(sessionMap, userAnswers: answers);
  }

  void saveOrUpdateUserAnswer(String sessionId, int questionId, String? selectedAnswer) {
    final stmt = _db.prepare('''
      INSERT INTO user_answers (user_exam_id, question_id, selected_answer, updated_at)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(user_exam_id, question_id) DO UPDATE SET
        selected_answer = excluded.selected_answer,
        updated_at = excluded.updated_at;
    ''');
    stmt.execute([
      sessionId,
      questionId,
      selectedAnswer,
      DateTime.now().toIso8601String(),
    ]);
    stmt.close();
  }

  void completeUserExamSession({
    required String sessionId,
    required DateTime endTime,
    required int score,
    required int correctCount,
    required int wrongCount,
    required int skippedCount,
  }) {
    final stmt = _db.prepare('''
      UPDATE user_exams SET
        end_time = ?,
        is_submitted = 1,
        score = ?,
        correct_count = ?,
        wrong_count = ?,
        skipped_count = ?
      WHERE id = ?;
    ''');
    stmt.execute([
      endTime.toIso8601String(),
      score,
      correctCount,
      wrongCount,
      skippedCount,
      sessionId,
    ]);
    stmt.close();
  }
}
