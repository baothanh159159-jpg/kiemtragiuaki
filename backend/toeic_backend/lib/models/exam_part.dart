import 'passage.dart';
import 'question.dart';

class ExamPart {
  final int? id;
  final int? examId;
  final int partNumber;
  final String title;
  final String instructions;
  final List<Passage> passages;
  final List<Question> independentQuestions;

  ExamPart({
    this.id,
    this.examId,
    required this.partNumber,
    required this.title,
    this.instructions = '',
    this.passages = const [],
    this.independentQuestions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (examId != null) 'exam_id': examId,
      'part_number': partNumber,
      'title': title,
      'instructions': instructions,
    };
  }

  factory ExamPart.fromMap(
    Map<String, dynamic> map, {
    List<Passage> passages = const [],
    List<Question> independentQuestions = const [],
  }) {
    return ExamPart(
      id: map['id'] as int?,
      examId: map['exam_id'] as int?,
      partNumber: map['part_number'] as int,
      title: map['title'] as String? ?? 'Part ${map['part_number']}',
      instructions: map['instructions'] as String? ?? '',
      passages: passages,
      independentQuestions: independentQuestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partNumber': partNumber,
      'title': title,
      'instructions': instructions,
      'passages': passages.map((p) => p.toJson()).toList(),
      'independentQuestions': independentQuestions.map((q) => q.toJson()).toList(),
    };
  }
}
