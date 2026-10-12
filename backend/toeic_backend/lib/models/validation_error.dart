class ValidationError {
  final int? lineNumber;
  final int? questionNumber;
  final String errorCode;
  final String message;

  ValidationError({
    this.lineNumber,
    this.questionNumber,
    required this.errorCode,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      if (lineNumber != null) 'lineNumber': lineNumber,
      if (questionNumber != null) 'questionNumber': questionNumber,
      'errorCode': errorCode,
      'message': message,
    };
  }

  @override
  String toString() {
    final prefix = questionNumber != null ? '[Câu $questionNumber]' : (lineNumber != null ? '[Dòng $lineNumber]' : '');
    return '$prefix $errorCode: $message';
  }
}

class ValidationResult {
  final bool isValid;
  final List<ValidationError> errors;

  ValidationResult({
    required this.isValid,
    this.errors = const [],
  });

  factory ValidationResult.success() => ValidationResult(isValid: true);

  factory ValidationResult.failure(List<ValidationError> errors) =>
      ValidationResult(isValid: false, errors: errors);

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'errors': errors.map((e) => e.toJson()).toList(),
    };
  }
}
