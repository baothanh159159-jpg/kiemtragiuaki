import '../utils/file_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/exam_models.dart';

class AdminScreen extends StatefulWidget {
  final VoidCallback? onSwitchToStudent;

  const AdminScreen({super.key, this.onSwitchToStudent});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _activeTab = 'part-5';
  final Set<int> _flaggedQuestions = {};
  int _navIndex = 1; // 1 = Import

  // Loaded Exam Data from Database
  Exam? _currentExam;
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _part5Key = GlobalKey();
  final GlobalKey _part6Key = GlobalKey();
  final GlobalKey _part7Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadExamData();
  }

  List<Exam> _allExams = [];
  int? _selectedExamId;

  void _loadExamData({int? preferredExamId}) async {
    setState(() => _isLoading = true);
    final exams = await ApiService.fetchExams();

    if (exams.isNotEmpty) {
      final targetId = preferredExamId ?? _selectedExamId ?? exams.last.id;
      final detail = await ApiService.fetchExamDetail(targetId);
      if (mounted) {
        setState(() {
          _allExams = exams;
          _selectedExamId = targetId;
          _currentExam = detail ?? exams.last;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _allExams = [];
          _currentExam = Exam(
            id: 1,
            title: 'TOEIC Reading Actual Test 01',
            durationMinutes: 75,
            totalQuestions: 100,
          );
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToSection(String section) {
    setState(() {
      _activeTab = section;
    });
    GlobalKey? targetKey;
    if (section == 'part-5') targetKey = _part5Key;
    if (section == 'part-6') targetKey = _part6Key;
    if (section == 'part-7') targetKey = _part7Key;

    if (targetKey != null && targetKey.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey.currentContext!,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showToast(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.inverseSurface,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.info,
              color: AppColors.tertiaryFixed,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inverseOnSurface,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleFlag(int qNum) {
    setState(() {
      if (_flaggedQuestions.contains(qNum)) {
        _flaggedQuestions.remove(qNum);
        _showToast('Đã bỏ gắn cờ câu hỏi $qNum');
      } else {
        _flaggedQuestions.add(qNum);
        _showToast('Đã gắn cờ câu hỏi $qNum cần thẩm định');
      }
    });
  }

  // --- MỤC 4: CHỨC NĂNG CHỈNH SỬA CÂU HỎI & NỘI DUNG ĐỀ THI (1 ĐIỂM) ---
  void _openEditQuestionModal(Question q) {
    final contentCtrl = TextEditingController(text: q.content);
    final expCtrl = TextEditingController(text: q.explanation ?? '');

    String optA = '';
    String optB = '';
    String optC = '';
    String optD = '';
    for (final a in q.answers) {
      if (a.label == 'A') optA = a.content;
      if (a.label == 'B') optB = a.content;
      if (a.label == 'C') optC = a.content;
      if (a.label == 'D') optD = a.content;
    }

    final ctrlA = TextEditingController(text: optA);
    final ctrlB = TextEditingController(text: optB);
    final ctrlC = TextEditingController(text: optC);
    final ctrlD = TextEditingController(text: optD);
    String selectedKey = q.correctAnswer ?? 'A';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surfaceContainerLowest,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_note, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chỉnh Sửa Câu Hỏi #${q.questionNumber}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Cập nhật nội dung câu hỏi, 4 phương án và lời giải vào CSDL',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nội dung câu hỏi:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: contentCtrl,
                        maxLines: 3,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Nhập nội dung câu hỏi...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: AppColors.surfaceContainerLow,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('4 Phương án trả lời & Chọn đáp án đúng (*):', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      _buildOptionEditRow('A', ctrlA, selectedKey == 'A', () {
                        setDialogState(() => selectedKey = 'A');
                      }),
                      const SizedBox(height: 6),
                      _buildOptionEditRow('B', ctrlB, selectedKey == 'B', () {
                        setDialogState(() => selectedKey = 'B');
                      }),
                      const SizedBox(height: 6),
                      _buildOptionEditRow('C', ctrlC, selectedKey == 'C', () {
                        setDialogState(() => selectedKey = 'C');
                      }),
                      const SizedBox(height: 6),
                      _buildOptionEditRow('D', ctrlD, selectedKey == 'D', () {
                        setDialogState(() => selectedKey = 'D');
                      }),
                      const SizedBox(height: 14),
                      Text('Giải thích đáp án & Dịch nghĩa:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: expCtrl,
                        maxLines: 3,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Nhập giải thích và dịch thuật tiếng Việt...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: AppColors.surfaceContainerLow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Hủy bỏ'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final newContent = contentCtrl.text.trim();
                    if (newContent.isEmpty) {
                      _showToast('Nội dung câu hỏi không được để trống', isSuccess: false);
                      return;
                    }
                    Navigator.pop(ctx);
                    final success = await ApiService.updateQuestion(
                      q.id,
                      content: newContent,
                      explanation: expCtrl.text.trim(),
                      correctAnswer: selectedKey,
                      options: {
                        'A': ctrlA.text.trim(),
                        'B': ctrlB.text.trim(),
                        'C': ctrlC.text.trim(),
                        'D': ctrlD.text.trim(),
                      },
                    );
                    if (mounted) {
                      if (success) {
                        _showToast('✔ Đã lưu thành công câu ${q.questionNumber} vào CSDL!');
                        _loadExamData();
                      } else {
                        _showToast('Lỗi khi lưu câu hỏi vào CSDL', isSuccess: false);
                      }
                    }
                  },
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Lưu vào CSDL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOptionEditRow(String label, TextEditingController ctrl, bool isCorrect, VoidCallback onSelectCorrect) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCorrect ? AppColors.tertiaryContainer.withValues(alpha: 0.3) : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCorrect ? AppColors.tertiary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onSelectCorrect,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCorrect ? AppColors.tertiary : AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isCorrect ? Colors.white : AppColors.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: ctrl,
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                hintText: 'Nội dung phương án $label',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.surfaceContainerLowest,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onSelectCorrect,
            icon: Icon(
              isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCorrect ? AppColors.tertiary : AppColors.onSurfaceVariant,
              size: 20,
            ),
            tooltip: isCorrect ? 'Đáp án đúng hiện tại' : 'Đặt làm đáp án đúng',
          ),
        ],
      ),
    );
  }

  void _openEditPassageModal(Passage passage) {
    final titleCtrl = TextEditingController(text: passage.title);
    final contentCtrl = TextEditingController(text: passage.content);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.article, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                'Sửa Bài Đọc (Passage #${passage.id})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tiêu đề bài đọc / Loại văn bản:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleCtrl,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'VD: Email thông báo nội bộ, Memo, Schedule...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Nội dung bài đọc:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: contentCtrl,
                    maxLines: 8,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Nhập nội dung bài đọc...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: AppColors.surfaceContainerLow,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(ctx);
                final success = await ApiService.updatePassage(
                  passage.id,
                  title: titleCtrl.text.trim(),
                  content: contentCtrl.text.trim(),
                );
                if (mounted) {
                  if (success) {
                    _showToast('✔ Đã lưu thay đổi bài đọc #${passage.id} vào CSDL!');
                    _loadExamData();
                  } else {
                    _showToast('Lỗi khi lưu bài đọc vào CSDL', isSuccess: false);
                  }
                }
              },
              icon: const Icon(Icons.save, size: 16),
              label: const Text('Lưu bài đọc'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openEditExamModal() {
    final titleCtrl = TextEditingController(text: _currentExam?.title ?? '');
    final durCtrl = TextEditingController(text: (_currentExam?.durationMinutes ?? 75).toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.assignment, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                'Sửa Thông Tin Đề Thi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên đề thi:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                  ),
                ),
                const SizedBox(height: 14),
                Text('Thời lượng làm bài (phút):', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                TextField(
                  controller: durCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                if (_currentExam == null) return;
                Navigator.pop(ctx);
                final success = await ApiService.updateExam(
                  _currentExam!.id,
                  title: titleCtrl.text.trim(),
                  durationMinutes: int.tryParse(durCtrl.text.trim()) ?? 75,
                );
                if (mounted) {
                  if (success) {
                    _showToast('✔ Đã lưu thông tin đề thi vào CSDL!');
                    _loadExamData();
                  } else {
                    _showToast('Lỗi khi lưu thông tin đề thi', isSuccess: false);
                  }
                }
              },
              icon: const Icon(Icons.save, size: 16),
              label: const Text('Lưu thông tin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- MỤC 3: CHỨC NĂNG UPLOAD FILE WORD VÀ KIỂM DUYỆT ALL-OR-NOTHING (1 ĐIỂM) ---
  void _openUploadDocxDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.upload_file, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Upload File Đề Thi Word (.docx)',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hệ thống áp dụng cơ chế kiểm duyệt All-or-Nothing:\n'
                '• Kiểm tra cấu trúc thẻ Tags: [EXAM], [PART], [PASSAGE], [Q], [A], [KEY], [EXP]\n'
                '• Đủ 100 câu hỏi, mỗi câu đủ 4 đáp án và 1 đáp án đúng\n'
                '• Nếu phát hiện bất kỳ lỗi nào, hệ thống sẽ hủy bỏ toàn bộ và báo lỗi chi tiết.',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _processDefaultDocxImport();
                },
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('Tải file chuẩn hóa: Reading_v01_Tagged.docx'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _processCustomDocxPick();
                },
                icon: const Icon(Icons.folder_open, size: 18),
                label: const Text('Chọn file .docx từ máy tính...'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _processDefaultDocxImport() async {
    _showToast('Đang nạp file Reading_v01_Tagged.docx theo chuẩn All-or-Nothing...');

    try {
      final result = await ApiService.importDefaultExam();
      if (result.success) {
        _showToast('✔ ${result.message} Đề thi mới: #${result.examId}');
        _loadExamData();
      } else {
        _showAllOrNothingErrorDialog(result.message, result.errors);
      }
    } catch (e) {
      _showToast('Lỗi khi nạp file: ${e.toString()}', isSuccess: false);
    }
  }

  void _processCustomDocxPick() async {
    try {
      final picked = await pickDocxFile();
      if (picked == null) {
        return; // Người dùng đóng hộp thoại chọn file
      }

      _showToast('Đang tải lên và thẩm định ${picked.name} (All-or-Nothing)...');
      final result = await ApiService.uploadDocxBytes(picked.bytes, picked.name);
      if (result.success) {
        _showToast('✔ ${result.message} Đề thi mới: #${result.examId}');
        _loadExamData();
      } else {
        _showAllOrNothingErrorDialog(result.message, result.errors);
      }
    } catch (e) {
      _showToast('Lỗi khi tải file: ${e.toString()}', isSuccess: false);
    }
  }

  void _showAllOrNothingErrorDialog(String message, List<String> errors) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.report_problem, color: AppColors.error, size: 24),
              const SizedBox(width: 8),
              Text(
                'Kiểm Duyệt Thất Bại (All-or-Nothing)',
                style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.error),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text('Chi tiết các lỗi tìm thấy:', style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 6),
                Container(
                  constraints: const BoxConstraints(maxHeight: 180),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: errors.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${errors[i]}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.onErrorContainer)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Đã hiểu, quay lại sửa file'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildHeader(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isLoading) const LinearProgressIndicator(minHeight: 3),
                _buildRoleSwitcherBanner(),
                const SizedBox(height: 12),
                _buildContextStrip(),
                const SizedBox(height: 14),
                _buildAiQualityControlCard(),
                const SizedBox(height: 16),
                _buildFilterTabs(),
                const SizedBox(height: 20),
                _buildPart5Section(),
                const SizedBox(height: 24),
                _buildPart6Section(),
                const SizedBox(height: 24),
                _buildPart7Section(),
              ],
            ),
          ),
          _buildFixedBottomActionBar(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
              ],
            ),
            child: const Icon(Icons.menu_book, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Import',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryFixed,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'PRO',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSecondaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.onTertiaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Hệ thống TOEIC Active',
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
        ],
      ),
      actions: [
        IconButton(
          onPressed: _openUploadDocxDialog,
          icon: const Icon(Icons.upload_file, color: AppColors.primary, size: 22),
          tooltip: 'Upload đề thi từ Word',
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: Container(
            width: 34,
            height: 34,
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
        color: AppColors.primaryContainer.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giao diện Admin / Giảng viên kiểm duyệt',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Upload Word All-or-Nothing • Rà soát lỗi • Chỉnh sửa CSDL',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (widget.onSwitchToStudent != null)
            ElevatedButton.icon(
              onPressed: widget.onSwitchToStudent,
              icon: const Icon(Icons.school, size: 15),
              label: const Text('Sang Học viên'),
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

  Widget _buildContextStrip() {
    final title = _currentExam?.title ?? 'TOEIC Reading Actual Test 01';
    final totalQ = _currentExam?.totalQuestions ?? 100;
    final dur = _currentExam?.durationMinutes ?? 75;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assignment, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rà soát đề thi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '#Đề ${_currentExam?.id ?? 1}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSecondaryFixed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$title • $dur phút • $totalQ câu hỏi (Part 5: 30 • Part 6: 16 • Part 7: 54)',
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_allExams.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: DropdownButton<int>(
                    value: _selectedExamId,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                    items: _allExams.map((e) {
                      return DropdownMenuItem<int>(
                        value: e.id,
                        child: Text('Đề #${e.id}: ${e.title}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        _loadExamData(preferredExamId: val);
                      }
                    },
                  ),
                ),
              ElevatedButton.icon(
                onPressed: _openEditExamModal,
                icon: const Icon(Icons.edit, size: 15),
                label: const Text('Chỉnh Sửa Thông Tin Đề'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _openUploadDocxDialog,
                icon: const Icon(Icons.upload_file, size: 15),
                label: const Text('Import Đề Thi (.docx)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              IconButton(
                onPressed: () => _loadExamData(),
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: 'Tải lại dữ liệu đề thi từ CSDL',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.tips_and_updates, color: AppColors.secondary, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hướng dẫn chỉnh sửa nội dung đề thi (Mục 4 - Chuẩn kiểm duyệt):\n'
                    '• Tên đề & Thời gian (75p): Bấm nút [Chỉnh Sửa Thông Tin Đề] ở trên.\n'
                    '• Chi tiết từng câu hỏi: Bấm nút [Chỉnh sửa] (màu cam) tại mỗi câu hỏi bên dưới để sửa câu hỏi, 4 đáp án A/B/C/D, đáp án đúng và lời giải thích/dịch nghĩa.\n'
                    '• Nội dung bài đọc: Bấm nút [Sửa bài đọc] (màu xanh) ở đầu mỗi đoạn văn Part 6 & Part 7.',
                    style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.onSurface, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiQualityControlCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.verified, color: AppColors.tertiary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kiểm định AI Auto-Check',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.onTertiaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Đạt chuẩn 100%',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildQualityMetric('100/100', 'Key đáp án', AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(child: _buildQualityMetric('0 Lỗi', 'Đoạn rỗng', AppColors.secondary)),
              const SizedBox(width: 8),
              Expanded(child: _buildQualityMetric('19 Đoạn', 'Hình ảnh & Bảng', AppColors.onTertiaryContainer)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityMetric(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabButton('Part 5', '101-130', 'part-5'),
          const SizedBox(width: 8),
          _buildTabButton('Part 6', '131-146', 'part-6'),
          const SizedBox(width: 8),
          _buildTabButton('Part 7', '147-200', 'part-7'),
          const SizedBox(width: 8),
          Container(width: 1, height: 26, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _showToast('Bộ lọc nâng cao: Đã tải đủ 100 câu hỏi từ CSDL'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'Bộ lọc',
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
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, String range, String key) {
    final isActive = _activeTab == key;
    return InkWell(
      onTap: () => _scrollToSection(key),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
              : null,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                range,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.primaryFixed : AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPart5Section() {
    ExamPart? p5;
    if (_currentExam != null) {
      for (final p in _currentExam!.parts) {
        if (p.partNumber == 5) p5 = p;
      }
    }

    final questions = p5?.independentQuestions ?? [];

    return Column(
      key: _part5Key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Part 5: Incomplete Sentences',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${questions.length} Câu hỏi',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSecondaryFixed,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (questions.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('Đang tải dữ liệu Part 5 từ CSDL...')),
          )
        else
          ...questions.map((q) => _buildQuestionAdminCard(q)),
      ],
    );
  }

  Widget _buildPart6Section() {
    ExamPart? p6;
    if (_currentExam != null) {
      for (final p in _currentExam!.parts) {
        if (p.partNumber == 6) p6 = p;
      }
    }

    final passages = p6?.passages ?? [];

    return Column(
      key: _part6Key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Part 6: Text Completion',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${passages.length} Bài đọc • 16 Câu hỏi',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSecondaryFixed,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (passages.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('Đang tải dữ liệu Part 6 từ CSDL...')),
          )
        else
          ...passages.map((p) => _buildPassageAdminCard(p, 6)),
      ],
    );
  }

  Widget _buildPart7Section() {
    ExamPart? p7;
    if (_currentExam != null) {
      for (final p in _currentExam!.parts) {
        if (p.partNumber == 7) p7 = p;
      }
    }

    final passages = p7?.passages ?? [];

    return Column(
      key: _part7Key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Part 7: Reading Comprehension',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${passages.length} Bài đọc • 54 Câu hỏi',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSecondaryFixed,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (passages.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Text('Đang tải dữ liệu Part 7 từ CSDL...')),
          )
        else
          ...passages.map((p) => _buildPassageAdminCard(p, 7)),
      ],
    );
  }

  Widget _buildQuestionAdminCard(Question q) {
    final isFlagged = _flaggedQuestions.contains(q.questionNumber);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
        border: isFlagged ? Border.all(color: AppColors.error, width: 1.5) : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Đáp án đúng: ${q.correctAnswer ?? "A"}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _toggleFlag(q.questionNumber),
                    icon: Icon(
                      Icons.flag,
                      size: 18,
                      color: isFlagged ? AppColors.error : AppColors.onSurfaceVariant,
                    ),
                    tooltip: isFlagged ? 'Bỏ gắn cờ' : 'Gắn cờ cần rà soát',
                    style: IconButton.styleFrom(
                      backgroundColor: isFlagged ? AppColors.errorContainer : AppColors.surfaceContainerLow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(34, 34),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    onPressed: () => _openEditQuestionModal(q),
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('Chỉnh sửa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(80, 34),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            q.content,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          ...q.answers.map((ans) {
            final isKey = ans.isCorrect || ans.label == q.correctAnswer;
            if (isKey) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _buildCorrectOptionTile(ans.label, ans.content),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _buildStandardOptionTile(ans.label, ans.content),
              );
            }
          }),
          if (q.explanation != null && q.explanation!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Giải thích: ${q.explanation}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPassageAdminCard(Passage passage, int partNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      partNumber == 6 ? Icons.mark_email_read : Icons.article,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        passage.title.isNotEmpty ? passage.title : 'Đoạn văn bài đọc (Part $partNumber)',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _openEditPassageModal(passage),
                icon: const Icon(Icons.edit_note, size: 16),
                label: const Text('Sửa bài đọc'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(80, 34),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              passage.content,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.onSurface,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.list_alt, size: 16, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text(
                'Danh sách câu hỏi phụ thuộc (${passage.questions.length} câu):',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...passage.questions.map((q) => _buildQuestionAdminCard(q)),
        ],
      ),
    );
  }

  Widget _buildCorrectOptionTile(String label, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.onTertiaryContainer.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.onTertiaryContainer.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.onTertiaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.tertiary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.tertiaryContainer,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                const Icon(Icons.check, size: 14, color: AppColors.onTertiaryContainer),
                const SizedBox(width: 4),
                Text(
                  'Đáp án đúng',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onTertiaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardOptionTile(String label, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedBottomActionBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () => _showToast('Đang quét tự động lỗi chính tả & định dạng font...'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.spellcheck, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'Rà soát lỗi',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showToast('Đề thi #ETS-2024-01 đã được phê duyệt xuất bản!');
                },
                icon: const Icon(Icons.task_alt, size: 20),
                label: Text(
                  'Phê duyệt xuất bản 100%',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() {
            _navIndex = index;
          });
          if (index == 0) {
            _showToast('Chuyển mục: Danh sách đề thi');
          } else if (index == 1) {
            _openUploadDocxDialog();
          } else if (index == 2) {
            _showToast('Chuyển mục: Kết quả & Báo cáo học viên');
          } else if (index == 3) {
            _showToast('Chuyển mục: Tài khoản quản trị');
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Đề thi'),
          BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: 'Import'),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: 'Kết quả'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
