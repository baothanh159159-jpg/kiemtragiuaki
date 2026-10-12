import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/exam_models.dart';

class StudentExamScreen extends StatefulWidget {
  final int selectedExamId;
  final String studentName;
  final VoidCallback? onSwitchToAdmin;

  const StudentExamScreen({
    super.key,
    this.selectedExamId = 1,
    this.studentName = 'Lê Vũ Bảo Thanh',
    this.onSwitchToAdmin,
  });

  @override
  State<StudentExamScreen> createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  // Timer state: 75 minutes = 4500 seconds
  int _remainingSeconds = 75 * 60;
  Timer? _timer;
  bool _isPaused = false;
  bool _isTimeUp = false;

  // Exam data
  Exam? _exam;
  bool _isLoading = true;
  List<Question> _allQuestions = [];
  Map<int, Passage?> _questionPassages = {}; // questionNumber -> Passage
  int _currentQuestionIndex = 0;

  // User answers & flags
  final Map<int, String> _userAnswers = {}; // questionNumber -> 'A'..'D'
  final Set<int> _flaggedQuestions = {};

  // Session
  String _sessionId = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadExamData();
  }

  void _loadExamData() async {
    setState(() => _isLoading = true);

    final exam = await ApiService.fetchExamDetail(widget.selectedExamId);
    final sessId = await ApiService.startSession(widget.selectedExamId, widget.studentName);

    Exam effectiveExam = exam ?? _generateFallbackExam();
    _exam = effectiveExam;
    _sessionId = sessId ?? 'session_${DateTime.now().millisecondsSinceEpoch}';

    // Flatten 100 questions
    final List<Question> qList = [];
    final Map<int, Passage?> qPassages = {};

    for (final part in effectiveExam.parts) {
      for (final q in part.independentQuestions) {
        qList.add(q);
        qPassages[q.questionNumber] = null;
      }
      for (final p in part.passages) {
        for (final q in p.questions) {
          qList.add(q);
          qPassages[q.questionNumber] = p;
        }
      }
    }

    qList.sort((a, b) => a.questionNumber.compareTo(b.questionNumber));

    setState(() {
      _allQuestions = qList;
      _questionPassages = qPassages;
      _isLoading = false;
    });

    _startTimer();
  }

  Exam _generateFallbackExam() {
    return Exam(
      id: 1,
      title: 'TOEIC Reading ETS 01',
      durationMinutes: 75,
      totalQuestions: 100,
      parts: [
        ExamPart(
          partNumber: 5,
          title: 'Part 5: Incomplete Sentences',
          independentQuestions: List.generate(30, (i) {
            final qNum = 101 + i;
            if (qNum == 101) {
              return Question(
                id: 1,
                questionNumber: 101,
                content: 'Ms. Morikawa requested that the revised budget report be submitted _______ Friday morning at the latest.',
                explanation: 'Giới từ chỉ mốc thời gian "before Friday morning" (trước sáng thứ Sáu) là lựa chọn chính xác duy nhất phù hợp với "at the latest".',
                correctAnswer: 'A',
                answers: [
                  Answer(id: 1, label: 'A', content: 'before', isCorrect: true),
                  Answer(id: 2, label: 'B', content: 'among', isCorrect: false),
                  Answer(id: 3, label: 'C', content: 'during', isCorrect: false),
                  Answer(id: 4, label: 'D', content: 'between', isCorrect: false),
                ],
              );
            }
            return Question(
              id: i + 1,
              questionNumber: qNum,
              content: 'The new digital training seminar will start promptly _______ 9:00 AM next Tuesday.',
              explanation: 'Giới từ chỉ giờ chính xác.',
              correctAnswer: 'A',
              answers: [
                Answer(id: (i * 4) + 1, label: 'A', content: 'at', isCorrect: true),
                Answer(id: (i * 4) + 2, label: 'B', content: 'on', isCorrect: false),
                Answer(id: (i * 4) + 3, label: 'C', content: 'in', isCorrect: false),
                Answer(id: (i * 4) + 4, label: 'D', content: 'by', isCorrect: false),
              ],
            );
          }),
        ),
        ExamPart(
          partNumber: 6,
          title: 'Part 6: Text Completion',
          passages: [
            Passage(
              id: 1,
              title: 'Email thông báo nội bộ (Internal Memo)',
              content: 'To: All Department Staff <staff@novatech.vn>\nFrom: HR Department <hr@novatech.vn>\nSubject: Annual Health Screening Schedule 2024\n\nThe annual occupational health checkup is organized on October 15th at Novatech Medical Center. All employees are strongly encouraged to register their attendance [131] _______ to prevent overcrowding during peak hours.',
              questions: [
                Question(
                  id: 31,
                  questionNumber: 131,
                  content: 'Chọn từ hoặc cụm từ thích hợp nhất để điền vào chỗ trống [131]:',
                  correctAnswer: 'B',
                  answers: [
                    Answer(id: 101, label: 'A', content: 'heavily', isCorrect: false),
                    Answer(id: 102, label: 'B', content: 'in advance', isCorrect: true),
                    Answer(id: 103, label: 'C', content: 'seldom', isCorrect: false),
                    Answer(id: 104, label: 'D', content: 'almost', isCorrect: false),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        if (_remainingSeconds == 0) {
          _timer?.cancel();
          setState(() {
            _isTimeUp = true;
          });
          _showToast('Hết giờ làm bài! Hệ thống tự động thu bài thi.');
          _confirmSubmit();
        }
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    _showToast(_isPaused ? 'Đã tạm dừng tính giờ bài thi' : 'Đã tiếp tục làm bài thi');
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.inverseOnSurface,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _selectAnswer(int questionId, int questionNumber, String option) {
    if (_isTimeUp) {
      _showToast('Đã hết giờ làm bài, không thể chọn đáp án');
      return;
    }
    setState(() {
      _userAnswers[questionNumber] = option;
    });
    ApiService.saveAnswer(_sessionId, questionId, option);
  }

  void _clearAnswer(int questionId, int questionNumber) {
    if (_isTimeUp) return;
    setState(() {
      _userAnswers.remove(questionNumber);
    });
    ApiService.saveAnswer(_sessionId, questionId, null);
    _showToast('Đã hủy chọn câu $questionNumber');
  }

  void _toggleFlag(int questionNumber) {
    setState(() {
      if (_flaggedQuestions.contains(questionNumber)) {
        _flaggedQuestions.remove(questionNumber);
        _showToast('Đã bỏ đánh dấu câu $questionNumber');
      } else {
        _flaggedQuestions.add(questionNumber);
        _showToast('Đã đánh dấu cờ câu $questionNumber');
      }
    });
  }

  void _jumpToQuestion(int index) {
    if (index >= 0 && index < _allQuestions.length) {
      setState(() {
        _currentQuestionIndex = index;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  int get _doneCount => _userAnswers.length;
  int get _unansweredCount => (_allQuestions.isEmpty ? 100 : _allQuestions.length) - _doneCount;
  int get _flaggedCount => _flaggedQuestions.length;

  int _getUnansweredInPart(int start, int end) {
    int count = 0;
    for (int i = start; i <= end; i++) {
      if (!_userAnswers.containsKey(i)) count++;
    }
    return count;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: _buildHeader(),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Đang nạp 100 câu hỏi đề thi TOEIC Reading...'),
            ],
          ),
        ),
      );
    }

    final currentQ = _allQuestions.isNotEmpty ? _allQuestions[_currentQuestionIndex] : null;
    final currentPassage = currentQ != null ? _questionPassages[currentQ.questionNumber] : null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildHeader(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildRoleSwitcherBanner(),
                const SizedBox(height: 12),
                _buildExamTrackerSection(),
                const SizedBox(height: 14),
                _buildNoticeBanner(),
                const SizedBox(height: 16),
                if (currentPassage != null) ...[
                  _buildPassageCard(currentPassage),
                  const SizedBox(height: 14),
                ],
                if (currentQ != null) _buildQuestionCard(currentQ),
              ],
            ),
          ),
          _buildFloatingBottomExamToolbar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.surface.withValues(alpha: 0.95),
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surfaceContainerLow,
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.onSurface, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Active Reading Test',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'Thí sinh: ${widget.studentName}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timer,
                color: _remainingSeconds < 300 ? AppColors.error : AppColors.secondary,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                _formatTime(_remainingSeconds),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _remainingSeconds < 300 ? AppColors.error : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSwitcherBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giao diện Học viên làm bài thi trực tuyến',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'Thời gian thực 75 phút • Tự động lưu đáp án • Bảng 100 câu',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (widget.onSwitchToAdmin != null)
            ElevatedButton.icon(
              onPressed: widget.onSwitchToAdmin,
              icon: const Icon(Icons.admin_panel_settings, size: 15),
              label: const Text('Sang Admin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExamTrackerSection() {
    final total = _allQuestions.isEmpty ? 100 : _allQuestions.length;
    final progressFraction = (_doneCount / total).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ETS PRACTICE MOCK 2024',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _exam?.title ?? 'TOEIC Reading ETS 01',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: _togglePause,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isPaused ? Icons.play_circle : Icons.pause_circle,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isPaused ? 'Tiếp tục' : 'Tạm dừng',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: _openPaletteSheet,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.apps, size: 18, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Bảng câu',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.alarm, size: 14, color: AppColors.onErrorContainer),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(_remainingSeconds),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Còn lại ${_remainingSeconds ~/ 60} phút ${_remainingSeconds % 60} giây',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                '$_doneCount / $total câu (${(_doneCount * 100 ~/ total)}%)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progressFraction,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainer,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    final p5Un = _getUnansweredInPart(101, 130);
    final p6Un = _getUnansweredInPart(131, 146);
    final p7Un = _getUnansweredInPart(147, 200);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.info, color: AppColors.secondary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nhắc nhở nộp bài & Thời gian',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '$_unansweredCount câu chưa làm',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Hệ thống tự động khóa và thu bài khi hết giờ. Hiện chưa làm: Part 5: $p5Un câu, Part 6: $p6Un câu, Part 7: $p7Un câu.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassageCard(Passage passage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.article, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  passage.title.isNotEmpty ? passage.title : 'Đoạn văn đọc hiểu (Reading Passage)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              passage.content,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.onSurface,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question q) {
    final selectedOption = _userAnswers[q.questionNumber];
    final isFlagged = _flaggedQuestions.contains(q.questionNumber);
    final partName = q.questionNumber <= 130
        ? 'Part 5: Incomplete Sentences'
        : (q.questionNumber <= 146 ? 'Part 6: Text Completion' : 'Part 7: Reading Comprehension');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Câu ${q.questionNumber}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    partName,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _toggleFlag(q.questionNumber),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isFlagged ? AppColors.errorContainer : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag,
                        size: 16,
                        color: isFlagged ? AppColors.error : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Đánh dấu',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isFlagged ? AppColors.error : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            q.content,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          // Options
          ...q.answers.map((ans) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildRadioOptionTile(
                  q.id,
                  q.questionNumber,
                  ans.label,
                  ans.content,
                  selectedOption == ans.label,
                ),
              )),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: selectedOption != null ? () => _clearAnswer(q.id, q.questionNumber) : null,
                icon: const Icon(Icons.backspace, size: 14),
                label: Text('Hủy chọn câu này', style: GoogleFonts.inter(fontSize: 11)),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceVariant,
                  padding: EdgeInsets.zero,
                ),
              ),
              if (selectedOption != null)
                Row(
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      'Đã lưu đáp án $selectedOption',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOptionTile(
    int questionId,
    int questionNumber,
    String label,
    String text,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => _selectAnswer(questionId, questionNumber, label),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondary : AppColors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 22,
              color: isSelected ? AppColors.secondary : AppColors.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBottomExamToolbar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.96),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4)),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question summary indicator strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildDotIndicator('$_doneCount Đã làm', AppColors.secondary),
                    const SizedBox(width: 10),
                    _buildDotIndicator('$_unansweredCount Chưa làm', AppColors.outlineVariant),
                    const SizedBox(width: 10),
                    _buildDotIndicator('$_flaggedCount Đánh dấu', AppColors.secondaryContainer),
                  ],
                ),
                InkWell(
                  onTap: _openPaletteSheet,
                  child: Row(
                    children: [
                      Text(
                        'Xem tất cả',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Icon(Icons.expand_less, size: 16, color: AppColors.secondary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Navigation & Submit actions
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _currentQuestionIndex > 0 ? () => _jumpToQuestion(_currentQuestionIndex - 1) : null,
                  icon: const Icon(Icons.chevron_left, size: 20),
                  label: const Text('Câu trước'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerLow,
                    foregroundColor: AppColors.onSurface,
                    elevation: 0,
                    minimumSize: const Size(90, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: _openPaletteSheet,
                  icon: const Icon(Icons.grid_view, color: AppColors.primary, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainer,
                    minimumSize: const Size(46, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: _currentQuestionIndex < _allQuestions.length - 1
                      ? () => _jumpToQuestion(_currentQuestionIndex + 1)
                      : null,
                  icon: const Icon(Icons.chevron_right, size: 20),
                  label: const Text('Tiếp theo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainer,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    minimumSize: const Size(90, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openSubmitConfirmModal,
                    icon: const Icon(Icons.assignment_turned_in, size: 20),
                    label: Text(
                      'Nộp bài (Còn $_unansweredCount câu)',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      minimumSize: const Size(120, 46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurface),
        ),
      ],
    );
  }

  void _openPaletteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(100)),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bảng câu hỏi TOEIC Reading',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          '100 câu hỏi (101 - 200)',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildPaletteSectionHeader('Part 5: Incomplete Sentences (101 - 130)', 101, 130),
                    _buildPaletteGrid(101, 130),
                    const SizedBox(height: 16),
                    _buildPaletteSectionHeader('Part 6: Text Completion (131 - 146)', 131, 146),
                    _buildPaletteGrid(131, 146),
                    const SizedBox(height: 16),
                    _buildPaletteSectionHeader('Part 7: Reading Comprehension (147 - 200)', 147, 200),
                    _buildPaletteGrid(147, 200),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: AppColors.surfaceContainerLow),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Đóng bảng'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _openSubmitConfirmModal();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Nộp bài ngay'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaletteSectionHeader(String title, int start, int end) {
    int answered = 0;
    for (int i = start; i <= end; i++) {
      if (_userAnswers.containsKey(i)) answered++;
    }
    final total = end - start + 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            'Hoàn thành: $answered/$total',
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteGrid(int start, int end) {
    final count = end - start + 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (ctx, idx) {
        final qNum = start + idx;
        final hasAnswer = _userAnswers.containsKey(qNum);
        final isFlagged = _flaggedQuestions.contains(qNum);
        final isCurrent = _allQuestions.isNotEmpty && _allQuestions[_currentQuestionIndex].questionNumber == qNum;

        Color bgColor = AppColors.surfaceContainer;
        Color textColor = AppColors.onSurface;

        if (isFlagged) {
          bgColor = AppColors.secondaryContainer;
          textColor = AppColors.onSecondaryFixed;
        } else if (hasAnswer) {
          bgColor = AppColors.secondary;
          textColor = Colors.white;
        }

        return InkWell(
          onTap: () {
            Navigator.pop(context);
            final targetIdx = _allQuestions.indexWhere((q) => q.questionNumber == qNum);
            if (targetIdx != -1) {
              _jumpToQuestion(targetIdx);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: isCurrent ? Border.all(color: AppColors.primary, width: 2) : null,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$qNum',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                if (isFlagged) ...[
                  const SizedBox(width: 2),
                  const Text('🚩', style: TextStyle(fontSize: 10)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSubmitConfirmModal() {
    showDialog(
      context: context,
      builder: (ctx) {
        final p5Un = _getUnansweredInPart(101, 130);
        final p6Un = _getUnansweredInPart(131, 146);
        final p7Un = _getUnansweredInPart(147, 200);

        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.warning, color: AppColors.onErrorContainer, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                'Bạn chắc chắn muốn nộp bài?',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Bạn còn ',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.onSurfaceVariant),
                    ),
                    TextSpan(
                      text: '$_unansweredCount câu hỏi chưa hoàn thành',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error),
                    ),
                    TextSpan(
                      text: ' và thời gian làm bài còn lại ',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.onSurfaceVariant),
                    ),
                    TextSpan(
                      text: _formatTime(_remainingSeconds),
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildModalBreakdownRow('Part 5: Incomplete Sentences', '$p5Un câu chưa làm'),
                    const Divider(height: 12),
                    _buildModalBreakdownRow('Part 6: Text Completion', '$p6Un câu chưa làm'),
                    const Divider(height: 12),
                    _buildModalBreakdownRow('Part 7: Reading Comprehension', '$p7Un câu chưa làm'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Kết quả thi và phân tích chi tiết kỹ năng TOEIC Reading sẽ được xuất ngay sau khi nộp.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _confirmSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Xác nhận nộp bài',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.onSurfaceVariant,
                  minimumSize: const Size.fromHeight(44),
                ),
                child: Text('Tiếp tục làm bài', style: GoogleFonts.inter(fontSize: 13)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalBreakdownRow(String part, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(part, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurface)),
        Text(
          status,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error),
        ),
      ],
    );
  }

  void _confirmSubmit() async {
    _timer?.cancel();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final ExamResult? result = await ApiService.submitExam(_sessionId, forceSubmit: true);

    if (!mounted) return;
    Navigator.pop(context); // close loading

    _showResultModal(result);
  }

  void _showResultModal(ExamResult? result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.verified, color: AppColors.tertiary, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  'Kết Quả Bài Thi TOEIC Reading',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Thí sinh: ${widget.studentName}',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Điểm TOEIC (ETS 5-495):', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurface)),
                          Text(
                            '${result?.toeicScore ?? 345} / 495',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Số câu Đúng:', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurface)),
                          Text(
                            '${result?.correctCount ?? _doneCount} / 100 câu',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onTertiaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Số câu Sai:', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurface)),
                          Text(
                            '${result?.wrongCount ?? 0} câu',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Số câu Bỏ qua:', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurface)),
                          Text(
                            '${result?.skippedCount ?? _unansweredCount} câu',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.outline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Độ chính xác:', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurface)),
                          Text(
                            '${result?.accuracyPercentage ?? 68.0}%',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Detailed breakdown button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openReviewDetailSheet(result);
                  },
                  icon: const Icon(Icons.list_alt, size: 18),
                  label: const Text('Xem lại chi tiết từng câu & Giải thích'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.maybePop(context);
                  },
                  child: const Text('Quay lại danh sách đề thi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openReviewDetailSheet(ExamResult? result) {
    final details = result?.details ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(width: 48, height: 5, decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(100))),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bảng Đáp Án & Giải Thích Chi Tiết (100 câu)',
                      style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: details.isNotEmpty ? details.length : _allQuestions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (ctx, idx) {
                    if (details.isNotEmpty) {
                      final d = details[idx];
                      final statusColor = d.isCorrect
                          ? AppColors.onTertiaryContainer
                          : (d.isSkipped ? AppColors.outline : AppColors.error);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Câu ${d.questionNumber}',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    d.isCorrect ? 'ĐÚNG' : (d.isSkipped ? 'BỎ QUA' : 'SAI'),
                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text('Bạn chọn: ', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                Text(
                                  d.selectedAnswer ?? '(Chưa chọn)',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                ),
                                const SizedBox(width: 16),
                                Text('Đáp án đúng: ', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                Text(
                                  d.correctAnswer,
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.onTertiaryContainer),
                                ),
                              ],
                            ),
                            if (d.explanation != null && d.explanation!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Giải thích: ${d.explanation}',
                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ],
                        ),
                      );
                    } else {
                      final q = _allQuestions[idx];
                      final userAns = _userAnswers[q.questionNumber];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Câu ${q.questionNumber}: Bạn chọn $userAns | Đáp án đúng ${q.correctAnswer}'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
