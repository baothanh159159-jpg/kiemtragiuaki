import 'exam_part.dart';

class Exam {
  final int? id;
  final String title;
  final int durationMinutes;
  final int totalQuestions;
  final DateTime createdAt;
  final List<ExamPart> parts;

  Exam({
    this.id,
    required this.title,
    this.durationMinutes = 75,
    this.totalQuestions = 100,
    DateTime? createdAt,
    this.parts = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'duration_minutes': durationMinutes,
      'total_questions': totalQuestions,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map, {List<ExamPart> parts = const []}) {
    return Exam(
      id: map['id'] as int?,
      title: map['title'] as String,
      durationMinutes: map['duration_minutes'] as int? ?? 75,
      totalQuestions: map['total_questions'] as int? ?? 100,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : DateTime.now(),
      parts: parts,
    );
  }

  Map<String, dynamic> toJson({bool includeDetails = false}) {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'totalQuestions': totalQuestions,
      'createdAt': createdAt.toIso8601String(),
      if (includeDetails) 'parts': parts.map((p) => p.toJson()).toList(),
    };
  }
}
