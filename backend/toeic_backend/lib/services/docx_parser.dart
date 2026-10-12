import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import '../models/exam.dart';
import '../models/exam_part.dart';
import '../models/passage.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../models/validation_error.dart';

class DocxParseOutput {
  final Exam? exam;
  final ValidationResult validationResult;
  final List<String> rawLines;
  final Map<String, Uint8List> extractedImages;

  DocxParseOutput({
    this.exam,
    required this.validationResult,
    required this.rawLines,
    this.extractedImages = const {},
  });
}

class DocxParser {
  /// Extracts all paragraph texts and media images from a .docx byte array.
  static DocxParseOutput parseDocxBytes(Uint8List bytes) {
    final rawLines = <String>[];
    final extractedImages = <String, Uint8List>{};

    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      final docFile = archive.findFile('word/document.xml');
      if (docFile == null) {
        return DocxParseOutput(
          validationResult: ValidationResult.failure([
            ValidationError(
              errorCode: 'DOCX_INVALID',
              message: 'File Word không hợp lệ (không tìm thấy word/document.xml)',
            ),
          ]),
          rawLines: [],
        );
      }

      // Extract images if any
      for (final file in archive.files) {
        if (file.name.startsWith('word/media/')) {
          final fileName = file.name.substring('word/media/'.length);
          extractedImages[fileName] = file.content;
        }
      }

      final xmlString = utf8.decode(docFile.content);
      final document = XmlDocument.parse(xmlString);

      // Find all paragraphs <w:p>
      final paragraphs = document.findAllElements('w:p');
      for (final p in paragraphs) {
        final textElements = p.findAllElements('w:t');
        final textBuffer = StringBuffer();
        for (final t in textElements) {
          textBuffer.write(t.innerText);
        }
        final line = textBuffer.toString().trim();
        if (line.isNotEmpty) {
          rawLines.add(line);
        }
      }
    } catch (e) {
      return DocxParseOutput(
        validationResult: ValidationResult.failure([
          ValidationError(
            errorCode: 'DOCX_READ_ERROR',
            message: 'Lỗi khi đọc file Word: ${e.toString()}',
          ),
        ]),
        rawLines: [],
      );
    }

    return parseLines(rawLines, extractedImages: extractedImages);
  }

  /// Parses text lines into structured Exam with complete validation.
  static DocxParseOutput parseLines(
    List<String> lines, {
    Map<String, Uint8List> extractedImages = const {},
  }) {
    final errors = <ValidationError>[];

    String examTitle = 'TOEIC Reading Test';
    int examDuration = 75;
    int declaredTotalQuestions = 100;
    bool hasExamStart = false;

    // Check basic exam header tags
    for (int i = 0; i < lines.length && i < 15; i++) {
      final line = lines[i];
      if (line.contains('[EXAM_START]')) hasExamStart = true;
      final titleMatch = RegExp(r'\[EXAM_TITLE:\s*(.+?)\]').firstMatch(line);
      if (titleMatch != null) examTitle = titleMatch.group(1)!.trim();
      final timeMatch = RegExp(r'\[EXAM_TIME:\s*(\d+)\]').firstMatch(line);
      if (timeMatch != null) examDuration = int.parse(timeMatch.group(1)!);
      final totalMatch = RegExp(r'\[TOTAL_QUESTIONS:\s*(\d+)\]').firstMatch(line);
      if (totalMatch != null) declaredTotalQuestions = int.parse(totalMatch.group(1)!);
    }

    if (!hasExamStart) {
      errors.add(ValidationError(
        lineNumber: 1,
        errorCode: 'MISSING_TAG',
        message: 'Thiếu thẻ khởi tạo đề thi [EXAM_START] ở phần đầu file',
      ));
    }

    final parts = <ExamPart>[];
    int currentPartNumber = 0;
    String currentPartTitle = '';
    String currentPartInstructions = '';
    final currentIndependentQuestions = <Question>[];
    final currentPassages = <Passage>[];

    // Passage state
    bool insidePassage = false;
    final passageLines = <String>[];
    String? passageImage;
    String passageTitle = '';
    int passageStartIndex = 0;

    // Question state
    bool insideQuestion = false;
    int? currentQNum;
    int questionStartIndex = 0;
    final questionContentLines = <String>[];
    final optionsMap = <String, String>{};
    String? correctKey;
    String? explanation;

    void flushCurrentQuestion() {
      if (!insideQuestion || currentQNum == null) return;

      final qNum = currentQNum!;
      if (questionContentLines.isEmpty && currentPartNumber == 5) {
        errors.add(ValidationError(
          lineNumber: questionStartIndex + 1,
          questionNumber: qNum,
          errorCode: 'EMPTY_QUESTION',
          message: 'Câu $qNum không có nội dung câu hỏi',
        ));
      }

      // Validate options
      for (final opt in ['A', 'B', 'C', 'D']) {
        if (!optionsMap.containsKey(opt) || optionsMap[opt]!.trim().isEmpty) {
          errors.add(ValidationError(
            lineNumber: questionStartIndex + 1,
            questionNumber: qNum,
            errorCode: 'MISSING_OPTION',
            message: 'Câu $qNum thiếu đáp án [$opt]',
          ));
        }
      }

      // Validate KEY
      if (correctKey == null || !['A', 'B', 'C', 'D'].contains(correctKey)) {
        errors.add(ValidationError(
          lineNumber: questionStartIndex + 1,
          questionNumber: qNum,
          errorCode: 'INVALID_KEY',
          message: 'Câu $qNum thiếu hoặc sai định dạng đáp án đúng [KEY: A/B/C/D]',
        ));
      }

      final answers = ['A', 'B', 'C', 'D'].map((label) {
        return Answer(
          label: label,
          content: optionsMap[label] ?? '',
          isCorrect: label == correctKey,
        );
      }).toList();

      final question = Question(
        questionNumber: qNum,
        content: questionContentLines.join('\n').trim(),
        explanation: explanation,
        orderIndex: qNum,
        answers: answers,
      );

      // In Part 6 and 7, attach to the most recent passage
      if (currentPartNumber != 5 && currentPassages.isNotEmpty) {
        final lastPassage = currentPassages.removeLast();
        currentPassages.add(Passage(
          id: lastPassage.id,
          title: lastPassage.title,
          content: lastPassage.content,
          imageName: lastPassage.imageName,
          orderIndex: lastPassage.orderIndex,
          questions: [...lastPassage.questions, question],
        ));
      } else {
        currentIndependentQuestions.add(question);
      }

      // Reset question state
      insideQuestion = false;
      currentQNum = null;
      questionContentLines.clear();
      optionsMap.clear();
      correctKey = null;
      explanation = null;
    }

    void flushCurrentPart() {
      if (currentPartNumber > 0) {
        parts.add(ExamPart(
          partNumber: currentPartNumber,
          title: currentPartTitle.isNotEmpty ? currentPartTitle : 'Part $currentPartNumber',
          instructions: currentPartInstructions,
          passages: List.from(currentPassages),
          independentQuestions: List.from(currentIndependentQuestions),
        ));
      }
      currentIndependentQuestions.clear();
      currentPassages.clear();
      currentPartInstructions = '';
    }

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Part tag
      final partMatch = RegExp(r'\[PART:\s*(\d+)\]').firstMatch(line);
      if (partMatch != null) {
        flushCurrentQuestion();
        flushCurrentPart();
        currentPartNumber = int.parse(partMatch.group(1)!);
        currentPartTitle = 'Part $currentPartNumber';
        continue;
      }

      // Passage tags
      if (line.contains('[PASSAGE_START]')) {
        flushCurrentQuestion();
        if (insidePassage) {
          errors.add(ValidationError(
            lineNumber: i + 1,
            errorCode: 'NESTED_PASSAGE',
            message: 'Phát hiện thẻ [PASSAGE_START] lồng nhau mà chưa đóng [PASSAGE_END]',
          ));
        }
        insidePassage = true;
        passageLines.clear();
        passageImage = null;
        passageTitle = '';
        passageStartIndex = i;
        continue;
      }

      if (line.contains('[PASSAGE_END]')) {
        if (!insidePassage) {
          errors.add(ValidationError(
            lineNumber: i + 1,
            errorCode: 'UNMATCHED_PASSAGE_END',
            message: 'Phát hiện thẻ [PASSAGE_END] thừa mà không có [PASSAGE_START]',
          ));
        } else {
          insidePassage = false;
          final passageText = passageLines.join('\n').trim();
          if (passageText.isEmpty) {
            errors.add(ValidationError(
              lineNumber: passageStartIndex + 1,
              errorCode: 'EMPTY_PASSAGE',
              message: 'Đoạn văn bắt đầu tại dòng ${passageStartIndex + 1} có nội dung rỗng',
            ));
          }
          currentPassages.add(Passage(
            title: passageTitle,
            content: passageText,
            imageName: passageImage,
            orderIndex: currentPassages.length + 1,
            questions: [],
          ));
        }
        continue;
      }

      // Check Image tag inside passage
      final imgMatch = RegExp(r'\[IMAGE:\s*(.+?)\]').firstMatch(line);
      if (imgMatch != null) {
        passageImage = imgMatch.group(1)!.trim();
        continue;
      }

      // Question start tag [Q: 101]
      final qMatch = RegExp(r'\[Q:\s*(\d+)\]').firstMatch(line);
      if (qMatch != null) {
        if (insideQuestion) {
          errors.add(ValidationError(
            lineNumber: i + 1,
            questionNumber: currentQNum,
            errorCode: 'MISSING_Q_CLOSE',
            message: 'Câu $currentQNum chưa đóng bằng thẻ [/Q] trước khi mở câu mới',
          ));
          flushCurrentQuestion();
        }
        insideQuestion = true;
        currentQNum = int.parse(qMatch.group(1)!);
        questionStartIndex = i;
        continue;
      }

      // Question end tag [/Q]
      if (line.contains('[/Q]')) {
        if (!insideQuestion) {
          errors.add(ValidationError(
            lineNumber: i + 1,
            errorCode: 'UNMATCHED_Q_CLOSE',
            message: 'Phát hiện thẻ [/Q] mà không có [Q: ...] mở',
          ));
        } else {
          flushCurrentQuestion();
        }
        continue;
      }

      // If inside question, check for options, key, explanation, or question content
      if (insideQuestion) {
        final optMatch = RegExp(r'^\[([ABCD])\]\s*(.*)$').firstMatch(line);
        if (optMatch != null) {
          final label = optMatch.group(1)!;
          final optContent = optMatch.group(2)!.trim();
          optionsMap[label] = optContent;
          continue;
        }

        final keyMatch = RegExp(r'^\[KEY:\s*([ABCD])\]').firstMatch(line);
        if (keyMatch != null) {
          correctKey = keyMatch.group(1)!.trim();
          continue;
        }

        final expMatch = RegExp(r'^\[EXPLANATION:\s*(.*?)\]?$').firstMatch(line);
        if (expMatch != null) {
          explanation = expMatch.group(1)!.trim();
          continue;
        }

        // Otherwise it's part of question content
        if (!line.startsWith('[') && !line.startsWith('PART')) {
          questionContentLines.add(line);
        }
        continue;
      }

      // If inside passage, accumulate passage lines
      if (insidePassage) {
        passageLines.add(line);
        continue;
      }

      // Header directions or instructions
      if (line.startsWith('Directions:')) {
        currentPartInstructions = line;
      }
    }

    // Flush remaining
    flushCurrentQuestion();
    flushCurrentPart();

    // Verify all question numbers (101 to 200)
    final allQuestions = <Question>[];
    for (final p in parts) {
      allQuestions.addAll(p.independentQuestions);
      for (final pass in p.passages) {
        allQuestions.addAll(pass.questions);
      }
    }

    allQuestions.sort((a, b) => a.questionNumber.compareTo(b.questionNumber));

    // Check total question count
    if (allQuestions.length != declaredTotalQuestions) {
      errors.add(ValidationError(
        errorCode: 'QUESTION_COUNT_MISMATCH',
        message: 'Tổng số câu hỏi tìm thấy (${allQuestions.length}) không khớp với số lượng đề ra ($declaredTotalQuestions)',
      ));
    }

    // Check sequential question numbers
    if (allQuestions.isNotEmpty) {
      int expectedNum = allQuestions.first.questionNumber;
      for (final q in allQuestions) {
        if (q.questionNumber != expectedNum) {
          errors.add(ValidationError(
            questionNumber: q.questionNumber,
            errorCode: 'NON_SEQUENTIAL_QUESTION',
            message: 'Sai thứ tự câu: mong đợi câu $expectedNum nhưng tìm thấy câu ${q.questionNumber}',
          ));
        }
        expectedNum = q.questionNumber + 1;
      }
    }

    if (errors.isNotEmpty) {
      return DocxParseOutput(
        validationResult: ValidationResult.failure(errors),
        rawLines: lines,
        extractedImages: extractedImages,
      );
    }

    final exam = Exam(
      title: examTitle,
      durationMinutes: examDuration,
      totalQuestions: allQuestions.length,
      parts: parts,
    );

    return DocxParseOutput(
      exam: exam,
      validationResult: ValidationResult.success(),
      rawLines: lines,
      extractedImages: extractedImages,
    );
  }
}
