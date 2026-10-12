import 'question.dart';

class Passage {
  final int? id;
  final int? partId;
  final String title;
  final String content;
  final String? imageName;
  final int orderIndex;
  final List<Question> questions;

  Passage({
    this.id,
    this.partId,
    this.title = '',
    required this.content,
    this.imageName,
    this.orderIndex = 0,
    this.questions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      'title': title,
      'content': content,
      'image_name': imageName,
      'order_index': orderIndex,
    };
  }

  factory Passage.fromMap(Map<String, dynamic> map, {List<Question> questions = const []}) {
    return Passage(
      id: map['id'] as int?,
      partId: map['part_id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String,
      imageName: map['image_name'] as String?,
      orderIndex: map['order_index'] as int? ?? 0,
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageName': imageName,
      'orderIndex': orderIndex,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
