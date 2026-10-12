class Exam {
  final int id;
  final String title;
  final int durationMinutes;
  final int totalQuestions;
  final String createdAt;
  final List<ExamPart> parts;

  Exam({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.totalQuestions,
    this.createdAt = '',
    this.parts = const [],
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as int? ?? 1,
      title: json['title'] as String? ?? 'TOEIC Reading Actual Test 01',
      durationMinutes: json['durationMinutes'] as int? ?? 75,
      totalQuestions: json['totalQuestions'] as int? ?? 100,
      createdAt: json['createdAt'] as String? ?? '',
      parts: (json['parts'] as List<dynamic>?)
              ?.map((p) => ExamPart.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ExamPart {
  final int partNumber;
  final String title;
  final String instructions;
  final List<Passage> passages;
  final List<Question> independentQuestions;

  ExamPart({
    required this.partNumber,
    required this.title,
    this.instructions = '',
    this.passages = const [],
    this.independentQuestions = const [],
  });

  factory ExamPart.fromJson(Map<String, dynamic> json) {
    return ExamPart(
      partNumber: json['partNumber'] as int? ?? 5,
      title: json['title'] as String? ?? 'Part 5',
      instructions: json['instructions'] as String? ?? '',
      passages: (json['passages'] as List<dynamic>?)
              ?.map((p) => Passage.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      independentQuestions: (json['independentQuestions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Passage {
  final int id;
  final String title;
  final String content;
  final String? imageName;
  final int orderIndex;
  final List<Question> questions;

  Passage({
    required this.id,
    required this.title,
    required this.content,
    this.imageName,
    this.orderIndex = 0,
    this.questions = const [],
  });

  factory Passage.fromJson(Map<String, dynamic> json) {
    return Passage(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageName: json['imageName'] as String?,
      orderIndex: json['orderIndex'] as int? ?? 0,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Question {
  final int id;
  final int questionNumber;
  final String content;
  final String? explanation;
  final String? correctAnswer;
  final int orderIndex;
  final int? passageId;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.questionNumber,
    required this.content,
    this.explanation,
    this.correctAnswer,
    this.orderIndex = 0,
    this.passageId,
    this.answers = const [],
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int? ?? 0,
      questionNumber: json['questionNumber'] as int? ?? 101,
      content: json['content'] as String? ?? '',
      explanation: json['explanation'] as String?,
      correctAnswer: json['correctAnswer'] as String?,
      orderIndex: json['orderIndex'] as int? ?? 0,
      passageId: json['passageId'] as int?,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => Answer.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Question copyWith({
    String? content,
    String? explanation,
    String? correctAnswer,
    List<Answer>? answers,
  }) {
    return Question(
      id: id,
      questionNumber: questionNumber,
      content: content ?? this.content,
      explanation: explanation ?? this.explanation,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      orderIndex: orderIndex,
      passageId: passageId,
      answers: answers ?? this.answers,
    );
  }
}

class Answer {
  final int id;
  final String label;
  final String content;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.label,
    required this.content,
    this.isCorrect = false,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as int? ?? 0,
      label: json['label'] as String? ?? 'A',
      content: json['content'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }
}

class ExamResult {
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final int toeicScore;
  final double accuracyPercentage;
  final List<QuestionResultDetail> details;

  ExamResult({
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.toeicScore,
    required this.accuracyPercentage,
    this.details = const [],
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      totalQuestions: json['totalQuestions'] as int? ?? 100,
      correctCount: json['correctCount'] as int? ?? 0,
      wrongCount: json['wrongCount'] as int? ?? 0,
      skippedCount: json['skippedCount'] as int? ?? 0,
      toeicScore: json['toeicScore'] as int? ?? 5,
      accuracyPercentage: (json['accuracyPercentage'] as num?)?.toDouble() ?? 0.0,
      details: (json['details'] as List<dynamic>?)
              ?.map((d) => QuestionResultDetail.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class QuestionResultDetail {
  final int questionNumber;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final bool isSkipped;
  final String? explanation;

  QuestionResultDetail({
    required this.questionNumber,
    this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.isSkipped,
    this.explanation,
  });

  factory QuestionResultDetail.fromJson(Map<String, dynamic> json) {
    return QuestionResultDetail(
      questionNumber: json['questionNumber'] as int? ?? 101,
      selectedAnswer: json['selectedAnswer'] as String?,
      correctAnswer: json['correctAnswer'] as String? ?? 'A',
      isCorrect: json['isCorrect'] as bool? ?? false,
      isSkipped: json['isSkipped'] as bool? ?? false,
      explanation: json['explanation'] as String?,
    );
  }
}
