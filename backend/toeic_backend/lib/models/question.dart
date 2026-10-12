import 'answer.dart';

class Question {
  final int? id;
  final int? examId;
  final int? partId;
  final int? passageId;
  final int questionNumber; // 101 .. 200
  final String content;
  final String? explanation;
  final int orderIndex;
  final List<Answer> answers;

  Question({
    this.id,
    this.examId,
    this.partId,
    this.passageId,
    required this.questionNumber,
    required this.content,
    this.explanation,
    this.orderIndex = 0,
    this.answers = const [],
  });

  String? get correctAnswerLabel {
    for (final a in answers) {
      if (a.isCorrect) return a.label;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (examId != null) 'exam_id': examId,
      if (partId != null) 'part_id': partId,
      'passage_id': passageId,
      'question_number': questionNumber,
      'content': content,
      'explanation': explanation,
      'order_index': orderIndex,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map, {List<Answer> answers = const []}) {
    return Question(
      id: map['id'] as int?,
      examId: map['exam_id'] as int?,
      partId: map['part_id'] as int?,
      passageId: map['passage_id'] as int?,
      questionNumber: map['question_number'] as int,
      content: map['content'] as String,
      explanation: map['explanation'] as String?,
      orderIndex: map['order_index'] as int? ?? 0,
      answers: answers,
    );
  }

  Map<String, dynamic> toJson({bool hideCorrect = false}) {
    return {
      'id': id,
      'questionNumber': questionNumber,
      'content': content,
      if (!hideCorrect) 'explanation': explanation,
      if (!hideCorrect) 'correctAnswer': correctAnswerLabel,
      'orderIndex': orderIndex,
      'passageId': passageId,
      'answers': answers.map((a) => a.toJson(hideCorrect: hideCorrect)).toList(),
    };
  }
}
