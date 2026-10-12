class UserAnswer {
  final int? id;
  final String userExamId;
  final int questionId;
  final int? questionNumber;
  final String? selectedAnswer; // 'A', 'B', 'C', 'D' or null
  final bool? isCorrect;
  final DateTime updatedAt;

  UserAnswer({
    this.id,
    required this.userExamId,
    required this.questionId,
    this.questionNumber,
    this.selectedAnswer,
    this.isCorrect,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_exam_id': userExamId,
      'question_id': questionId,
      'selected_answer': selectedAnswer,
      'is_correct': isCorrect == null ? null : (isCorrect! ? 1 : 0),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserAnswer.fromMap(Map<String, dynamic> map, {int? questionNumber}) {
    return UserAnswer(
      id: map['id'] as int?,
      userExamId: map['user_exam_id'] as String,
      questionId: map['question_id'] as int,
      questionNumber: questionNumber ?? map['question_number'] as int?,
      selectedAnswer: map['selected_answer'] as String?,
      isCorrect: map['is_correct'] == null ? null : (map['is_correct'] as int == 1),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userExamId': userExamId,
      'questionId': questionId,
      if (questionNumber != null) 'questionNumber': questionNumber,
      'selectedAnswer': selectedAnswer,
      'isCorrect': isCorrect,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
