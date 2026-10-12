class ExamScoringResult {
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final int toeicScore; // 5 - 495
  final double accuracyPercentage;
  final List<QuestionResultDetail> details;

  ExamScoringResult({
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.toeicScore,
    required this.accuracyPercentage,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalQuestions': totalQuestions,
      'correctCount': correctCount,
      'wrongCount': wrongCount,
      'skippedCount': skippedCount,
      'toeicScore': toeicScore,
      'accuracyPercentage': double.parse(accuracyPercentage.toStringAsFixed(1)),
      'details': details.map((d) => d.toJson()).toList(),
    };
  }
}

class QuestionResultDetail {
  final int questionNumber;
  final String? selectedAnswer; // 'A', 'B', 'C', 'D' or null
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

  Map<String, dynamic> toJson() {
    return {
      'questionNumber': questionNumber,
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
      'isSkipped': isSkipped,
      'explanation': explanation,
    };
  }
}

class ScoringService {
  /// Standard ETS TOEIC Reading score conversion table (0 to 100 correct answers -> 5 to 495 scale)
  static final Map<int, int> _readingScaleTable = {
    0: 5, 1: 5, 2: 5, 3: 5, 4: 5, 5: 5, 6: 5, 7: 5, 8: 5, 9: 5,
    10: 10, 11: 15, 12: 20, 13: 25, 14: 30, 15: 35, 16: 40, 17: 45, 18: 50, 19: 55,
    20: 60, 21: 65, 22: 70, 23: 75, 24: 80, 25: 85, 26: 90, 27: 95, 28: 100, 29: 105,
    30: 110, 31: 115, 32: 120, 33: 125, 34: 130, 35: 135, 36: 140, 37: 145, 38: 150, 39: 155,
    40: 160, 41: 165, 42: 170, 43: 175, 44: 180, 45: 185, 46: 190, 47: 195, 48: 200, 49: 210,
    50: 220, 51: 225, 52: 230, 53: 235, 54: 240, 55: 245, 56: 250, 57: 255, 58: 260, 59: 265,
    60: 270, 61: 275, 62: 280, 63: 285, 64: 290, 65: 295, 66: 300, 67: 305, 68: 310, 69: 315,
    70: 320, 71: 325, 72: 330, 73: 335, 74: 340, 75: 345, 76: 350, 77: 355, 78: 360, 79: 365,
    80: 375, 81: 380, 82: 385, 83: 390, 84: 400, 85: 405, 86: 410, 87: 415, 88: 420, 89: 425,
    90: 435, 91: 440, 92: 445, 93: 450, 94: 460, 95: 470, 96: 475, 97: 485, 98: 490, 99: 495,
    100: 495,
  };

  /// Calculates the ETS score from the number of correct questions.
  static int convertToToeicScale(int correctCount) {
    if (correctCount <= 0) return 5;
    if (correctCount >= 100) return 495;
    return _readingScaleTable[correctCount] ?? (5 + (correctCount * 4.9).round());
  }

  /// Evaluates submitted answers against actual question answers.
  static ExamScoringResult calculateScore({
    required Map<int, String> correctAnswersMap, // questionNumber -> 'A'
    required Map<int, String?> userAnswersMap,    // questionNumber -> selected 'A' or null
    Map<int, String?> explanationsMap = const {}, // questionNumber -> explanation
  }) {
    int correctCount = 0;
    int wrongCount = 0;
    int skippedCount = 0;
    final details = <QuestionResultDetail>[];

    final sortedQNums = correctAnswersMap.keys.toList()..sort();

    for (final qNum in sortedQNums) {
      final correct = correctAnswersMap[qNum]!;
      final userAns = userAnswersMap[qNum];
      final explanation = explanationsMap[qNum];

      if (userAns == null || userAns.trim().isEmpty) {
        skippedCount++;
        details.add(QuestionResultDetail(
          questionNumber: qNum,
          selectedAnswer: null,
          correctAnswer: correct,
          isCorrect: false,
          isSkipped: true,
          explanation: explanation,
        ));
      } else if (userAns.trim().toUpperCase() == correct.toUpperCase()) {
        correctCount++;
        details.add(QuestionResultDetail(
          questionNumber: qNum,
          selectedAnswer: userAns.trim().toUpperCase(),
          correctAnswer: correct,
          isCorrect: true,
          isSkipped: false,
          explanation: explanation,
        ));
      } else {
        wrongCount++;
        details.add(QuestionResultDetail(
          questionNumber: qNum,
          selectedAnswer: userAns.trim().toUpperCase(),
          correctAnswer: correct,
          isCorrect: false,
          isSkipped: false,
          explanation: explanation,
        ));
      }
    }

    final totalQuestions = sortedQNums.length;
    final toeicScore = convertToToeicScale(correctCount);
    final accuracy = totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0;

    return ExamScoringResult(
      totalQuestions: totalQuestions,
      correctCount: correctCount,
      wrongCount: wrongCount,
      skippedCount: skippedCount,
      toeicScore: toeicScore,
      accuracyPercentage: accuracy,
      details: details,
    );
  }
}
