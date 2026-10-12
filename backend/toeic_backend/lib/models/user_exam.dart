import 'user_answer.dart';

class UserExam {
  final String id;
  final int examId;
  final String userName;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds; // 4500 (75 min)
  final bool isSubmitted;
  final int score; // 5 - 495
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final List<UserAnswer> userAnswers;

  UserExam({
    required this.id,
    required this.examId,
    required this.userName,
    required this.startTime,
    this.endTime,
    this.durationSeconds = 4500,
    this.isSubmitted = false,
    this.score = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.skippedCount = 0,
    this.userAnswers = const [],
  });

  int get remainingSeconds {
    if (isSubmitted) return 0;
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    final remaining = durationSeconds - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  bool get isExpired => remainingSeconds <= 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exam_id': examId,
      'user_name': userName,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration_seconds': durationSeconds,
      'is_submitted': isSubmitted ? 1 : 0,
      'score': score,
      'correct_count': correctCount,
      'wrong_count': wrongCount,
      'skipped_count': skippedCount,
    };
  }

  factory UserExam.fromMap(Map<String, dynamic> map, {List<UserAnswer> userAnswers = const []}) {
    return UserExam(
      id: map['id'] as String,
      examId: map['exam_id'] as int,
      userName: map['user_name'] as String,
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time'] as String) : null,
      durationSeconds: map['duration_seconds'] as int? ?? 4500,
      isSubmitted: (map['is_submitted'] as int? ?? 0) == 1,
      score: map['score'] as int? ?? 0,
      correctCount: map['correct_count'] as int? ?? 0,
      wrongCount: map['wrong_count'] as int? ?? 0,
      skippedCount: map['skipped_count'] as int? ?? 0,
      userAnswers: userAnswers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examId': examId,
      'userName': userName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationSeconds': durationSeconds,
      'remainingSeconds': remainingSeconds,
      'isSubmitted': isSubmitted,
      'isExpired': isExpired,
      'score': score,
      'correctCount': correctCount,
      'wrongCount': wrongCount,
      'skippedCount': skippedCount,
      'userAnswers': userAnswers.map((a) => a.toJson()).toList(),
    };
  }
}
