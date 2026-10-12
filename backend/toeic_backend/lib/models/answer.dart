class Answer {
  final int? id;
  final int? questionId;
  final String label; // 'A', 'B', 'C', 'D'
  final String content;
  final bool isCorrect;

  Answer({
    this.id,
    this.questionId,
    required this.label,
    required this.content,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      'label': label,
      'content': content,
      'is_correct': isCorrect ? 1 : 0,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'] as int?,
      questionId: map['question_id'] as int?,
      label: map['label'] as String,
      content: map['content'] as String,
      isCorrect: (map['is_correct'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson({bool hideCorrect = false}) {
    return {
      'id': id,
      'label': label,
      'content': content,
      if (!hideCorrect) 'isCorrect': isCorrect,
    };
  }
}
