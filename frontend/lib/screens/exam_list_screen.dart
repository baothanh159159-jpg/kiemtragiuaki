import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/exam_models.dart';
import '../services/api_service.dart';
import 'student_exam_screen.dart';

class ExamListScreen extends StatefulWidget {
  final VoidCallback? onSwitchToAdmin;

  const ExamListScreen({super.key, this.onSwitchToAdmin});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  List<Exam> _exams = [];
  bool _isLoading = true;
  final TextEditingController _nameController = TextEditingController(text: 'Lê Vũ Bảo Thanh');

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  void _loadExams() async {
    setState(() => _isLoading = true);
    final list = await ApiService.fetchExams();
    if (mounted) {
      setState(() {
        _exams = list;
        _isLoading = false;
      });
    }
  }

  void _startExam(Exam exam) {
    final studentName = _nameController.text.trim().isEmpty ? 'Thí sinh' : _nameController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentExamScreen(
          selectedExamId: exam.id,
          studentName: studentName,
          onSwitchToAdmin: widget.onSwitchToAdmin,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface.withValues(alpha: 0.95),
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hệ Thống Thi TOEIC Reading',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Dành cho học viên khảo thí trực tuyến',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (widget.onSwitchToAdmin != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                onPressed: widget.onSwitchToAdmin,
                icon: const Icon(Icons.admin_panel_settings, size: 14),
                label: const Text('Sang Admin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _loadExams(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Student Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: AppColors.secondary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Thông tin thí sinh',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Họ và tên thí sinh',
                              labelStyle: GoogleFonts.inter(fontSize: 12),
                              prefixIcon: const Icon(Icons.badge, size: 20),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: AppColors.surfaceContainerLow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Danh Sách Đề Thi Khả Dụng',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '${_exams.length} đề thi',
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
                    // List of Exams
                    if (_exams.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        child: Text(
                          'Chưa có đề thi nào trong CSDL. Vui lòng chuyển sang Admin để tải file Word lên.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
                        ),
                      )
                    else
                      ..._exams.map((exam) => _buildExamCard(exam)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildExamCard(Exam exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
              Expanded(
                child: Text(
                  exam.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '#Đề thi 0${exam.id}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onTertiaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Đề thi chuẩn hóa ETS TOEIC Reading 100 câu: Part 5 (30 câu) • Part 6 (16 câu) • Part 7 (54 câu)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBadge(Icons.timer, '${exam.durationMinutes} phút', AppColors.surfaceContainer, AppColors.secondary),
              const SizedBox(width: 8),
              _buildBadge(Icons.quiz, '${exam.totalQuestions} câu hỏi', AppColors.surfaceContainer, AppColors.primary),
              const SizedBox(width: 8),
              _buildBadge(Icons.auto_stories, 'Reading Section', AppColors.surfaceContainerHigh, AppColors.onSurface),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _startExam(exam),
            icon: const Icon(Icons.play_circle_fill, size: 20),
            label: Text(
              'Bắt đầu làm bài (${exam.durationMinutes} phút)',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
          if (widget.onSwitchToAdmin != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: widget.onSwitchToAdmin,
              icon: const Icon(Icons.edit_note, size: 18),
              label: Text(
                'Giảng viên: Rà soát & Chỉnh sửa đề thi',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side: const BorderSide(color: AppColors.secondary),
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
