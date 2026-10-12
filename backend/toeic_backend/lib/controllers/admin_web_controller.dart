import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AdminWebController {
  Router get router {
    final router = Router();
    router.get('/', _handleIndex);
    router.get('/admin', _handleIndex);
    router.get('/admin/', _handleIndex);
    router.get('/admin/stitch', _handleAdminStitch);
    router.get('/student/stitch', _handleStudentStitch);
    return router;
  }

  Response _handleIndex(Request request) {
    return Response.ok(
      _buildHtmlPage(),
      headers: {'content-type': 'text/html; charset=utf-8'},
    );
  }

  Response _handleAdminStitch(Request request) {
    final file = File('web/admin_role.html');
    if (file.existsSync()) {
      return Response.ok(file.readAsStringSync(), headers: {'content-type': 'text/html; charset=utf-8'});
    }
    return Response.notFound('Admin Stitch HTML not found');
  }

  Response _handleStudentStitch(Request request) {
    final file = File('web/student_role.html');
    if (file.existsSync()) {
      return Response.ok(file.readAsStringSync(), headers: {'content-type': 'text/html; charset=utf-8'});
    }
    return Response.notFound('Student Stitch HTML not found');
  }

  String _buildHtmlPage() {
    return '''<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hệ Thống Thi Thử TOEIC Reading & Quản Trị Đề Thi</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary: #4f46e5;
      --primary-hover: #4338ca;
      --primary-light: #eef2ff;
      --success: #10b981;
      --success-light: #ecfdf5;
      --danger: #ef4444;
      --danger-light: #fef2f2;
      --warning: #f59e0b;
      --warning-light: #fffbeb;
      --gray-50: #f8fafc;
      --gray-100: #f1f5f9;
      --gray-200: #e2e8f0;
      --gray-300: #cbd5e1;
      --gray-600: #475569;
      --gray-700: #334155;
      --gray-800: #1e293b;
      --gray-900: #0f172a;
      --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
      --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
      --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
      --radius: 12px;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
      background-color: var(--gray-50);
      color: var(--gray-800);
      line-height: 1.5;
    }

    /* Header & Navigation */
    header {
      background: white;
      border-bottom: 1px solid var(--gray-200);
      position: sticky;
      top: 0;
      z-index: 40;
    }
    .nav-container {
      max-width: 1300px;
      margin: 0 auto;
      padding: 0 24px;
      height: 68px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .logo-badge {
      display: flex;
      align-items: center;
      gap: 12px;
      font-size: 1.25rem;
      font-weight: 800;
      color: var(--gray-900);
    }
    .logo-icon {
      width: 40px;
      height: 40px;
      background: linear-gradient(135deg, var(--primary), #818cf8);
      color: white;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 800;
      font-size: 1.2rem;
    }
    .nav-tabs {
      display: flex;
      gap: 8px;
      background: var(--gray-100);
      padding: 4px;
      border-radius: 10px;
    }
    .nav-btn {
      padding: 8px 18px;
      border-radius: 8px;
      border: none;
      background: transparent;
      font-family: inherit;
      font-size: 0.9rem;
      font-weight: 600;
      color: var(--gray-600);
      cursor: pointer;
      transition: all 0.2s;
    }
    .nav-btn.active {
      background: white;
      color: var(--primary);
      box-shadow: var(--shadow-sm);
    }

    /* Container */
    main {
      max-width: 1300px;
      margin: 28px auto;
      padding: 0 24px;
    }

    /* Sections */
    .view-section { display: none; }
    .view-section.active { display: block; animation: fadeIn 0.25s ease-in-out; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(4px); } to { opacity: 1; transform: translateY(0); } }

    /* Card styling */
    .card {
      background: white;
      border-radius: var(--radius);
      border: 1px solid var(--gray-200);
      box-shadow: var(--shadow-sm);
      padding: 24px;
      margin-bottom: 24px;
    }
    .card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 18px;
      padding-bottom: 14px;
      border-bottom: 1px solid var(--gray-100);
    }
    .card-title {
      font-size: 1.15rem;
      font-weight: 700;
      color: var(--gray-900);
      display: flex;
      align-items: center;
      gap: 10px;
    }

    /* Upload Zone */
    .upload-box {
      border: 2px dashed var(--gray-300);
      border-radius: var(--radius);
      padding: 48px 24px;
      text-align: center;
      background: var(--gray-50);
      cursor: pointer;
      transition: all 0.2s;
    }
    .upload-box:hover, .upload-box.dragover {
      border-color: var(--primary);
      background: var(--primary-light);
    }
    .upload-icon {
      font-size: 42px;
      margin-bottom: 12px;
      color: var(--primary);
    }

    /* Button styles */
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 10px 20px;
      border-radius: 8px;
      font-family: inherit;
      font-weight: 600;
      font-size: 0.92rem;
      border: none;
      cursor: pointer;
      transition: all 0.15s;
    }
    .btn-primary { background: var(--primary); color: white; }
    .btn-primary:hover { background: var(--primary-hover); }
    .btn-success { background: var(--success); color: white; }
    .btn-danger { background: var(--danger); color: white; }
    .btn-outline { background: white; border: 1px solid var(--gray-300); color: var(--gray-700); }
    .btn-outline:hover { background: var(--gray-100); }

    /* Alert Banner */
    .alert {
      padding: 16px 20px;
      border-radius: 10px;
      margin-bottom: 20px;
      display: flex;
      align-items: flex-start;
      gap: 12px;
    }
    .alert-error {
      background: var(--danger-light);
      border: 1px solid #fca5a5;
      color: #991b1b;
    }
    .alert-success {
      background: var(--success-light);
      border: 1px solid #6ee7b7;
      color: #065f46;
    }
    .error-list {
      margin-top: 8px;
      font-family: 'JetBrains Mono', monospace;
      font-size: 0.85rem;
      max-height: 200px;
      overflow-y: auto;
      padding-left: 20px;
    }

    /* Exam Details & Parts Tabs */
    .part-nav {
      display: flex;
      gap: 10px;
      margin-bottom: 20px;
      border-bottom: 2px solid var(--gray-200);
      padding-bottom: 8px;
    }
    .part-nav-btn {
      padding: 8px 18px;
      border-radius: 8px;
      font-weight: 700;
      font-size: 0.95rem;
      border: none;
      background: transparent;
      color: var(--gray-600);
      cursor: pointer;
    }
    .part-nav-btn.active {
      background: var(--primary-light);
      color: var(--primary);
    }

    /* Question Box */
    .question-card {
      border: 1px solid var(--gray-200);
      border-radius: 10px;
      padding: 18px;
      margin-bottom: 16px;
      background: white;
    }
    .question-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
    }
    .q-number-badge {
      background: var(--gray-900);
      color: white;
      font-weight: 700;
      padding: 4px 10px;
      border-radius: 6px;
      font-size: 0.85rem;
    }
    .passage-box {
      background: #fdfdfd;
      border-left: 4px solid var(--primary);
      padding: 16px 20px;
      margin-bottom: 18px;
      border-radius: 4px;
      white-space: pre-wrap;
      font-size: 0.93rem;
      line-height: 1.6;
      border-top: 1px solid var(--gray-200);
      border-right: 1px solid var(--gray-200);
      border-bottom: 1px solid var(--gray-200);
    }

    .options-grid {
      display: grid;
      grid-template-columns: 1fr;
      gap: 8px;
      margin-top: 10px;
    }
    .option-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 10px 14px;
      border: 1px solid var(--gray-200);
      border-radius: 8px;
      background: var(--gray-50);
      cursor: pointer;
      transition: all 0.15s;
    }
    .option-item.correct {
      border-color: var(--success);
      background: var(--success-light);
      font-weight: 600;
      color: #065f46;
    }
    .option-item.selected {
      border-color: var(--primary);
      background: var(--primary-light);
      font-weight: 600;
      color: var(--primary);
    }
    .opt-label {
      width: 28px;
      height: 28px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      background: white;
      border: 1px solid var(--gray-300);
      font-weight: 700;
      font-size: 0.85rem;
      flex-shrink: 0;
    }
    .option-item.correct .opt-label {
      background: var(--success);
      color: white;
      border-color: var(--success);
    }
    .option-item.selected .opt-label {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }
    .explanation-box {
      margin-top: 10px;
      padding: 10px 14px;
      background: #f8fafc;
      border-radius: 6px;
      font-size: 0.85rem;
      color: var(--gray-600);
      border-left: 3px solid #64748b;
    }

    /* Modal for Editing */
    .modal-backdrop {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(15, 23, 42, 0.6);
      z-index: 50;
      align-items: center;
      justify-content: center;
    }
    .modal-backdrop.open { display: flex; }
    .modal {
      background: white;
      border-radius: var(--radius);
      width: 95%;
      max-width: 600px;
      padding: 24px;
      max-height: 90vh;
      overflow-y: auto;
    }

    /* Simulator Controls */
    .simulator-topbar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      background: var(--gray-900);
      color: white;
      padding: 14px 24px;
      border-radius: var(--radius);
      margin-bottom: 20px;
    }
    .timer-display {
      font-family: 'JetBrains Mono', monospace;
      font-size: 1.4rem;
      font-weight: 700;
      color: #38bdf8;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .palette-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(42px, 1fr));
      gap: 6px;
      max-height: 280px;
      overflow-y: auto;
      padding: 12px;
      border: 1px solid var(--gray-200);
      border-radius: 8px;
      background: white;
    }
    .palette-btn {
      height: 40px;
      border-radius: 6px;
      border: 1px solid var(--gray-300);
      background: var(--gray-100);
      font-weight: 700;
      font-size: 0.85rem;
      cursor: pointer;
      transition: all 0.15s;
    }
    .palette-btn.done {
      background: var(--primary);
      color: white;
      border-color: var(--primary);
    }
    .palette-btn.active {
      border: 2px solid #f59e0b;
      box-shadow: 0 0 0 2px rgba(245, 158, 11, 0.3);
    }

    /* Score Summary */
    .score-summary-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 16px;
      margin-bottom: 24px;
    }
    .stat-card {
      background: white;
      border: 1px solid var(--gray-200);
      border-radius: 10px;
      padding: 18px;
      text-align: center;
    }
    .stat-val {
      font-size: 2rem;
      font-weight: 800;
      margin-top: 4px;
    }
  </style>
</head>
<body>

<header>
  <div class="nav-container">
    <div class="logo-badge">
      <div class="logo-icon">T</div>
      <div>
        <span>TOEIC Reading System</span>
        <div style="font-size: 0.72rem; color: var(--gray-600); font-weight: 500;">Backend &amp; Quản trị đề thi (Dart Shelf Server)</div>
      </div>
    </div>
    <div class="nav-tabs">
      <button class="nav-btn active" onclick="switchTab('tab-upload')">Upload File Word</button>
      <button class="nav-btn" onclick="switchTab('tab-preview')">Xem Trước Đề Thi</button>
      <button class="nav-btn" onclick="switchTab('tab-practice')">Mô Phỏng Làm Bài</button>
    </div>
  </div>
</header>

<main>
  <!-- TAB 1: UPLOAD FILE WORD -->
  <section id="tab-upload" class="view-section active">
    <div class="card">
      <div class="card-header">
        <div class="card-title">Upload File Word Đề Thi TOEIC (.docx)</div>
        <span style="font-size: 0.85rem; color: var(--gray-600); font-weight: 600;">Cơ chế kiểm duyệt: All-or-Nothing</span>
      </div>

      <div id="uploadAlertArea"></div>

      <div class="upload-box" id="dropArea" onclick="document.getElementById('fileInput').click()">
        <div class="upload-icon">&#128196;</div>
        <h3 style="font-size: 1.1rem; margin-bottom: 6px;">Kéo &amp; thả file .docx vào đây hoặc bấm để chọn</h3>
        <p style="color: var(--gray-600); font-size: 0.88rem;">Hệ thống sẽ kiểm tra nghiêm ngặt thẻ tags, đủ 100 câu, 4 đáp án và đáp án đúng trước khi lưu.</p>
        <input type="file" id="fileInput" accept=".docx" style="display: none;" onchange="handleFileSelect(this.files)">
      </div>

      <div style="margin-top: 20px; display: flex; gap: 12px; justify-content: flex-end;">
        <button class="btn btn-outline" onclick="loadDefaultExam()">Tải file mẫu sẵn có (Reading_v01_Tagged.docx)</button>
      </div>
    </div>

    <!-- Danh sách đề thi đã có -->
    <div class="card">
      <div class="card-header">
        <div class="card-title">Danh Sách Đề Thi Trong Hệ Thống (SQLite)</div>
        <button class="btn btn-outline" style="padding: 6px 12px; font-size: 0.85rem;" onclick="loadExamsList()">Làm mới</button>
      </div>
      <div id="examsListContainer">
        <p style="color: var(--gray-600);">Đang tải danh sách đề thi...</p>
      </div>
    </div>
  </section>

  <!-- TAB 2: XEM TRƯỚC ĐỀ THI & CHỈNH SỬA -->
  <section id="tab-preview" class="view-section">
    <div class="card">
      <div class="card-header">
        <div>
          <div class="card-title" id="previewExamTitle">Xem Trước Đề Thi TOEIC Reading</div>
          <div style="font-size: 0.85rem; color: var(--gray-600);" id="previewExamSub">Chọn đề thi để xem chi tiết 100 câu hỏi</div>
        </div>
        <div style="display: flex; gap: 10px;">
          <select id="examSelectBox" class="btn btn-outline" onchange="loadExamDetails(this.value)">
            <option value="">-- Chọn đề thi --</option>
          </select>
        </div>
      </div>

      <div class="part-nav">
        <button class="part-nav-btn active" id="partBtn5" onclick="switchPartView(5)">Part 5: Incomplete Sentences (101-130)</button>
        <button class="part-nav-btn" id="partBtn6" onclick="switchPartView(6)">Part 6: Text Completion (131-146)</button>
        <button class="part-nav-btn" id="partBtn7" onclick="switchPartView(7)">Part 7: Reading Comprehension (147-200)</button>
      </div>

      <div id="previewQuestionsArea">
        <p style="color: var(--gray-600);">Vui lòng chọn đề thi để xem nội dung.</p>
      </div>
    </div>
  </section>

  <!-- TAB 3: MÔ PHỎNG LÀM BÀI & CHẤM ĐIỂM -->
  <section id="tab-practice" class="view-section">
    <!-- Trước khi vào thi -->
    <div id="prePracticeCard" class="card">
      <div class="card-header">
        <div class="card-title">Bắt Đầu Lượt Thi Thử TOEIC Reading</div>
      </div>
      <div style="max-width: 500px;">
        <div style="margin-bottom: 16px;">
          <label style="display: block; font-weight: 600; margin-bottom: 6px;">Họ và tên thí sinh:</label>
          <input type="text" id="studentNameInput" value="Lê Vũ Bảo Thanh" style="width: 100%; padding: 10px 14px; border: 1px solid var(--gray-300); border-radius: 8px; font-family: inherit;">
        </div>
        <div style="margin-bottom: 20px;">
          <label style="display: block; font-weight: 600; margin-bottom: 6px;">Đề thi:</label>
          <select id="practiceExamSelect" style="width: 100%; padding: 10px 14px; border: 1px solid var(--gray-300); border-radius: 8px; font-family: inherit;">
            <option value="">-- Đang tải đề thi --</option>
          </select>
        </div>
        <button class="btn btn-primary" onclick="startPracticeSession()">Bắt Đầu Làm Bài (75 Phút)</button>
      </div>
    </div>

    <!-- Giao diện làm bài -->
    <div id="activePracticeCard" style="display: none;">
      <div class="simulator-topbar">
        <div>
          <div style="font-size: 0.85rem; color: #94a3b8;">Thí sinh: <span id="simStudentName" style="color: white; font-weight: 700;"></span></div>
          <div style="font-weight: 700; font-size: 1.1rem;" id="simExamTitle">TOEIC Reading Actual Test</div>
        </div>
        <div class="timer-display">
          <span>&#9201;</span>
          <span id="simTimer">75:00</span>
        </div>
        <button class="btn btn-danger" onclick="confirmSubmitTest()">Nộp Bài Thi</button>
      </div>

      <div style="display: grid; grid-template-columns: 1fr 340px; gap: 24px; align-items: start;">
        <!-- Vùng câu hỏi hiện tại -->
        <div class="card" id="simQuestionArea">
          <p>Đang tải câu hỏi...</p>
        </div>

        <!-- Bảng Palette 100 câu -->
        <div class="card">
          <div class="card-header" style="margin-bottom: 10px; padding-bottom: 10px;">
            <div style="font-weight: 700; font-size: 0.95rem;">Danh Sách Câu Hỏi (100)</div>
            <span id="answeredStatsBadge" style="font-size: 0.8rem; background: var(--gray-100); padding: 4px 8px; border-radius: 6px; font-weight: 700;">0/100 đã làm</span>
          </div>
          <div class="palette-grid" id="simPaletteGrid"></div>
        </div>
      </div>
    </div>

    <!-- Màn hình kết quả thi -->
    <div id="resultPracticeCard" class="card" style="display: none;">
      <div class="card-header">
        <div class="card-title">Kết Quả Bài Thi TOEIC Reading</div>
        <button class="btn btn-outline" onclick="resetPractice()">Làm Đề Khác</button>
      </div>

      <div class="score-summary-grid">
        <div class="stat-card" style="border-top: 4px solid var(--primary);">
          <div style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">Điểm TOEIC (ETS 5-495)</div>
          <div class="stat-val" style="color: var(--primary);" id="resToeicScore">450</div>
        </div>
        <div class="stat-card" style="border-top: 4px solid var(--success);">
          <div style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">Số câu Đúng</div>
          <div class="stat-val" style="color: var(--success);" id="resCorrectCount">90</div>
        </div>
        <div class="stat-card" style="border-top: 4px solid var(--danger);">
          <div style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">Số câu Sai</div>
          <div class="stat-val" style="color: var(--danger);" id="resWrongCount">8</div>
        </div>
        <div class="stat-card" style="border-top: 4px solid var(--warning);">
          <div style="color: var(--gray-600); font-weight: 600; font-size: 0.9rem;">Số câu Bỏ Qua</div>
          <div class="stat-val" style="color: var(--warning);" id="resSkippedCount">2</div>
        </div>
      </div>

      <h3 style="font-size: 1.1rem; margin-bottom: 14px;">Bảng Chi Tiết Kết Quả Từng Câu</h3>
      <div id="resultDetailsList"></div>
    </div>
  </section>
</main>

<!-- MODAL CHỈNH SỬA CÂU HỎI -->
<div class="modal-backdrop" id="editModal">
  <div class="modal">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
      <h3 style="font-size: 1.2rem; font-weight: 800;" id="editModalTitle">Chỉnh Sửa Câu Hỏi</h3>
      <button onclick="closeEditModal()" style="border: none; background: transparent; font-size: 1.5rem; cursor: pointer;">&times;</button>
    </div>
    <input type="hidden" id="editQuestionId">
    <div style="margin-bottom: 14px;">
      <label style="display: block; font-weight: 600; margin-bottom: 6px;">Nội dung câu hỏi:</label>
      <textarea id="editQuestionContent" rows="3" style="width: 100%; padding: 10px; border: 1px solid var(--gray-300); border-radius: 8px; font-family: inherit;"></textarea>
    </div>
    <div style="margin-bottom: 14px;">
      <label style="display: block; font-weight: 600; margin-bottom: 6px;">Giải thích đáp án:</label>
      <textarea id="editQuestionExplanation" rows="2" style="width: 100%; padding: 10px; border: 1px solid var(--gray-300); border-radius: 8px; font-family: inherit;"></textarea>
    </div>
    <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;">
      <button class="btn btn-outline" onclick="closeEditModal()">Hủy</button>
      <button class="btn btn-primary" onclick="saveQuestionEdit()">Lưu Thay Đổi</button>
    </div>
  </div>
</div>

<script>
  let currentLoadedExam = null;
  let currentPreviewPart = 5;
  let activeSessionId = null;
  let activeExamData = null;
  let activeSessionQuestions = [];
  let currentQuestionIndex = 0;
  let userSelectedAnswers = {}; // qNum -> 'A'
  let timerInterval = null;
  let remainingSeconds = 4500;

  // --- NAVIGATION ---
  function switchTab(tabId) {
    document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.view-section').forEach(s => s.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');

    if (tabId === 'tab-upload') document.querySelectorAll('.nav-btn')[0].classList.add('active');
    if (tabId === 'tab-preview') {
      document.querySelectorAll('.nav-btn')[1].classList.add('active');
      if (!currentLoadedExam) loadExamsList();
    }
    if (tabId === 'tab-practice') {
      document.querySelectorAll('.nav-btn')[2].classList.add('active');
      populatePracticeExamsDropdown();
    }
  }

  // --- API CALLS ---
  async function loadExamsList() {
    try {
      const res = await fetch('/api/exams');
      const data = await res.json();
      const container = document.getElementById('examsListContainer');
      const selectBox = document.getElementById('examSelectBox');
      const practiceSelect = document.getElementById('practiceExamSelect');

      if (!data.exams || data.exams.length === 0) {
        container.innerHTML = '<p style="color: var(--gray-600);">Chưa có đề thi nào trong CSDL. Hãy tải file Word lên.</p>';
        selectBox.innerHTML = '<option value="">-- Chưa có đề thi --</option>';
        practiceSelect.innerHTML = '<option value="">-- Chưa có đề thi --</option>';
        return;
      }

      selectBox.innerHTML = '<option value="">-- Chọn đề thi --</option>';
      practiceSelect.innerHTML = '';

      let html = '<div style="display: grid; gap: 12px;">';
      data.exams.forEach(ex => {
        selectBox.innerHTML += `<option value="\${ex.id}">#\${ex.id} - \${ex.title}</option>`;
        practiceSelect.innerHTML += `<option value="\${ex.id}">#\${ex.id} - \${ex.title} (100 câu, 75 phút)</option>`;

        html += `
          <div style="display: flex; align-items: center; justify-content: space-between; padding: 14px 18px; border: 1px solid var(--gray-200); border-radius: 8px; background: white;">
            <div>
              <div style="font-weight: 700; color: var(--gray-900);">#\${ex.id} - \${ex.title}</div>
              <div style="font-size: 0.82rem; color: var(--gray-600);">Thời gian: \${ex.durationMinutes} phút | Tổng số câu: \${ex.totalQuestions} | Ngày tạo: \${new Date(ex.createdAt).toLocaleString()}</div>
            </div>
            <div style="display: flex; gap: 8px;">
              <button class="btn btn-outline" style="padding: 6px 12px; font-size: 0.85rem;" onclick="viewExam(\${ex.id})">Xem trước</button>
              <button class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85rem;" onclick="practiceExam(\${ex.id})">Làm thử</button>
            </div>
          </div>
        `;
      });
      html += '</div>';
      container.innerHTML = html;

      // Auto-load first exam
      if (!currentLoadedExam && data.exams.length > 0) {
        selectBox.value = data.exams[0].id;
        loadExamDetails(data.exams[0].id);
      }
    } catch (e) {
      console.error(e);
    }
  }

  function viewExam(id) {
    switchTab('tab-preview');
    document.getElementById('examSelectBox').value = id;
    loadExamDetails(id);
  }

  function practiceExam(id) {
    switchTab('tab-practice');
    document.getElementById('practiceExamSelect').value = id;
  }

  async function loadExamDetails(id) {
    if (!id) return;
    try {
      const res = await fetch(`/api/exams/\${id}`);
      const data = await res.json();
      if (data.success) {
        currentLoadedExam = data.exam;
        document.getElementById('previewExamTitle').innerText = `#\${data.exam.id} - \${data.exam.title}`;
        document.getElementById('previewExamSub').innerText = `Tổng số câu: \${data.exam.totalQuestions} câu | Thời gian: \${data.exam.durationMinutes} phút`;
        renderPreviewPart(currentPreviewPart);
      }
    } catch (e) {
      console.error(e);
    }
  }

  function switchPartView(partNum) {
    currentPreviewPart = partNum;
    [5, 6, 7].forEach(p => {
      document.getElementById('partBtn' + p).classList.toggle('active', p === partNum);
    });
    renderPreviewPart(partNum);
  }

  function renderPreviewPart(partNum) {
    if (!currentLoadedExam) return;
    const part = currentLoadedExam.parts.find(p => p.partNumber === partNum);
    const container = document.getElementById('previewQuestionsArea');
    if (!part) {
      container.innerHTML = `<p style="color: var(--gray-600);">Không có dữ liệu cho Part \${partNum}.</p>`;
      return;
    }

    let html = '';
    if (part.instructions) {
      html += `<div style="margin-bottom: 16px; font-style: italic; color: var(--gray-600); font-size: 0.9rem;">\${part.instructions}</div>`;
    }

    if (partNum === 5) {
      // Independent questions
      part.independentQuestions.forEach(q => {
        html += renderSingleQuestionHtml(q);
      });
    } else {
      // Passages
      part.passages.forEach((pass, pIdx) => {
        html += `
          <div style="margin-bottom: 28px; border: 1px solid var(--gray-300); border-radius: 10px; padding: 18px; background: #fafafa;">
            <div style="font-weight: 700; margin-bottom: 8px; color: var(--primary);">Đoạn văn #\${pIdx + 1}</div>
            <div class="passage-box">\${pass.content}</div>
            <div style="margin-top: 14px;">
              \${pass.questions.map(q => renderSingleQuestionHtml(q)).join('')}
            </div>
          </div>
        `;
      });
    }
    container.innerHTML = html;
  }

  function renderSingleQuestionHtml(q) {
    return `
      <div class="question-card" id="qcard-\${q.id}">
        <div class="question-header">
          <div style="display: flex; align-items: center; gap: 10px;">
            <span class="q-number-badge">Câu \${q.questionNumber}</span>
            <span style="font-weight: 600; font-size: 0.95rem;">\${q.content}</span>
          </div>
          <button class="btn btn-outline" style="padding: 4px 10px; font-size: 0.8rem;" onclick='openEditModal(\${JSON.stringify(q)})'>Sửa câu hỏi</button>
        </div>
        <div class="options-grid">
          \${q.answers.map(ans => `
            <div class="option-item \${ans.isCorrect ? 'correct' : ''}">
              <div class="opt-label">\${ans.label}</div>
              <div>\${ans.content} \${ans.isCorrect ? '<span style="color: var(--success); font-weight: 700; margin-left: 8px;">(Đáp án đúng)</span>' : ''}</div>
            </div>
          `).join('')}
        </div>
        \${q.explanation ? `<div class="explanation-box"><strong>Giải thích:</strong> \${q.explanation}</div>` : ''}
      </div>
    `;
  }

  // --- UPLOAD HANDLERS ---
  async function handleFileSelect(files) {
    if (!files || files.length === 0) return;
    const file = files[0];
    const formData = new FormData();
    formData.append('file', file);

    const alertArea = document.getElementById('uploadAlertArea');
    alertArea.innerHTML = '<div class="alert alert-success">Đang đọc và phân tích file Word...</div>';

    try {
      const res = await fetch('/api/exams/upload', {
        method: 'POST',
        body: formData
      });
      const data = await res.json();

      if (data.success) {
        alertArea.innerHTML = `
          <div class="alert alert-success">
            <div>
              <strong>&#10004; Thành công:</strong> \${data.message}
              <div style="margin-top: 4px;">Đề thi mới: <strong>#\${data.examId}</strong>. Bạn có thể chuyển sang tab Xem trước đề thi.</div>
            </div>
          </div>
        `;
        loadExamsList();
      } else {
        let errList = '';
        if (data.errors && data.errors.length > 0) {
          errList = '<ul class="error-list">' + data.errors.map(e => `<li>\${e.message}</li>`).join('') + '</ul>';
        }
        alertArea.innerHTML = `
          <div class="alert alert-error">
            <div>
              <strong>&#9888; Cơ chế All-or-Nothing (Hủy toàn bộ giao dịch):</strong>
              <div>\${data.message}</div>
              \${errList}
            </div>
          </div>
        `;
      }
    } catch (e) {
      alertArea.innerHTML = `<div class="alert alert-error">Lỗi kết nối máy chủ: \${e.message}</div>`;
    }
  }

  // Load default exam pre-bundled
  async function loadDefaultExam() {
    alert('Đề thi chuẩn hóa Reading_v01_Tagged.docx đã được nạp sẵn vào CSDL SQLite của hệ thống.');
    loadExamsList();
  }

  // --- EDIT MODAL ---
  function openEditModal(q) {
    document.getElementById('editQuestionId').value = q.id;
    document.getElementById('editModalTitle').innerText = `Chỉnh Sửa Câu \${q.questionNumber}`;
    document.getElementById('editQuestionContent').value = q.content;
    document.getElementById('editQuestionExplanation').value = q.explanation || '';
    document.getElementById('editModal').classList.add('open');
  }

  function closeEditModal() {
    document.getElementById('editModal').classList.remove('open');
  }

  async function saveQuestionEdit() {
    const qId = document.getElementById('editQuestionId').value;
    const content = document.getElementById('editQuestionContent').value;
    const explanation = document.getElementById('editQuestionExplanation').value;

    try {
      const res = await fetch(`/api/questions/\${qId}`, {
        method: 'PUT',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ content, explanation })
      });
      const data = await res.json();
      if (data.success) {
        closeEditModal();
        loadExamDetails(currentLoadedExam.id);
      } else {
        alert(data.error);
      }
    } catch (e) {
      alert(e.message);
    }
  }

  // --- SIMULATOR / PRACTICE ---
  function populatePracticeExamsDropdown() {
    loadExamsList();
  }

  async function startPracticeSession() {
    const examId = document.getElementById('practiceExamSelect').value;
    const studentName = document.getElementById('studentNameInput').value.trim() || 'Thí sinh';
    if (!examId) return alert('Vui lòng chọn đề thi');

    try {
      // 1. Get full exam questions
      const exRes = await fetch(`/api/exams/\${examId}`);
      const exData = await exRes.json();
      activeExamData = exData.exam;

      // Collect all 100 questions flat
      activeSessionQuestions = [];
      activeExamData.parts.forEach(p => {
        p.independentQuestions.forEach(q => {
          activeSessionQuestions.push({ ...q, passage: null });
        });
        p.passages.forEach(pass => {
          pass.questions.forEach(q => {
            activeSessionQuestions.push({ ...q, passage: pass });
          });
        });
      });
      activeSessionQuestions.sort((a, b) => a.questionNumber - b.questionNumber);

      // 2. Start session on server
      const sessRes = await fetch('/api/sessions/start', {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ examId: parseInt(examId), userName: studentName })
      });
      const sessData = await sessRes.json();
      activeSessionId = sessData.session.id;

      // Setup UI
      document.getElementById('prePracticeCard').style.display = 'none';
      document.getElementById('resultPracticeCard').style.display = 'none';
      document.getElementById('activePracticeCard').style.display = 'block';

      document.getElementById('simStudentName').innerText = studentName;
      document.getElementById('simExamTitle').innerText = activeExamData.title;

      userSelectedAnswers = {};
      currentQuestionIndex = 0;
      remainingSeconds = 4500; // 75 mins

      buildPalette();
      renderCurrentQuestion(0);
      startTimer();
    } catch (e) {
      alert('Lỗi bắt đầu thi: ' + e.message);
    }
  }

  function startTimer() {
    if (timerInterval) clearInterval(timerInterval);
    timerInterval = setInterval(() => {
      remainingSeconds--;
      if (remainingSeconds <= 0) {
        clearInterval(timerInterval);
        alert('Hết giờ làm bài (75 phút)! Hệ thống sẽ tự động nộp bài.');
        submitTest(true);
        return;
      }
      const mins = Math.floor(remainingSeconds / 60);
      const secs = remainingSeconds % 60;
      document.getElementById('simTimer').innerText = 
        `\${mins.toString().padStart(2, '0')}:\${secs.toString().padStart(2, '0')}`;
    }, 1000);
  }

  function buildPalette() {
    const grid = document.getElementById('simPaletteGrid');
    let html = '';
    activeSessionQuestions.forEach((q, idx) => {
      const isDone = userSelectedAnswers[q.questionNumber] ? 'done' : '';
      const isActive = idx === currentQuestionIndex ? 'active' : '';
      html += `<button class="palette-btn \${isDone} \${isActive}" id="palBtn-\${idx}" onclick="jumpToQuestion(\${idx})">\${q.questionNumber}</button>`;
    });
    grid.innerHTML = html;
    updatePaletteStats();
  }

  function updatePaletteStats() {
    const answeredCount = Object.keys(userSelectedAnswers).length;
    document.getElementById('answeredStatsBadge').innerText = `\${answeredCount}/100 đã làm`;
  }

  function jumpToQuestion(idx) {
    currentQuestionIndex = idx;
    document.querySelectorAll('.palette-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('palBtn-' + idx)?.classList.add('active');
    renderCurrentQuestion(idx);
  }

  function renderCurrentQuestion(idx) {
    const q = activeSessionQuestions[idx];
    const container = document.getElementById('simQuestionArea');
    const selected = userSelectedAnswers[q.questionNumber];

    let passageHtml = '';
    if (q.passage) {
      passageHtml = `
        <div style="font-weight: 700; color: var(--primary); margin-bottom: 6px;">Đoạn văn đọc hiểu</div>
        <div class="passage-box" style="max-height: 240px; overflow-y: auto;">\${q.passage.content}</div>
      `;
    }

    container.innerHTML = `
      \${passageHtml}
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
        <span class="q-number-badge" style="font-size: 1rem; padding: 6px 14px;">Câu \${q.questionNumber} / 200</span>
        \${selected ? `<button class="btn btn-outline" style="padding: 4px 10px; font-size: 0.8rem;" onclick="clearAnswer(\${q.id}, \${q.questionNumber})">Hủy chọn</button>` : ''}
      </div>
      <div style="font-size: 1.05rem; font-weight: 600; margin-bottom: 16px;">\${q.content}</div>
      <div class="options-grid">
        \${q.answers.map(ans => {
          const isChosen = selected === ans.label;
          return `
            <div class="option-item \${isChosen ? 'selected' : ''}" onclick="selectAnswer(\${q.id}, \${q.questionNumber}, '\${ans.label}')">
              <div class="opt-label">\${ans.label}</div>
              <div>\${ans.content}</div>
            </div>
          `;
        }).join('')}
      </div>
      <div style="display: flex; justify-content: space-between; margin-top: 24px;">
        <button class="btn btn-outline" \${idx === 0 ? 'disabled' : ''} onclick="jumpToQuestion(\${idx - 1})">&larr; Câu trước</button>
        <button class="btn btn-primary" \${idx === activeSessionQuestions.length - 1 ? 'disabled' : ''} onclick="jumpToQuestion(\${idx + 1})">Câu tiếp theo &rarr;</button>
      </div>
    `;
  }

  async function selectAnswer(qId, qNum, label) {
    userSelectedAnswers[qNum] = label;
    // Mark palette button
    document.getElementById('palBtn-' + currentQuestionIndex)?.classList.add('done');
    updatePaletteStats();
    renderCurrentQuestion(currentQuestionIndex);

    // Sync with backend
    try {
      await fetch(`/api/sessions/\${activeSessionId}/answer`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ questionId: qId, selectedAnswer: label })
      });
    } catch (e) {
      console.error(e);
    }
  }

  async function clearAnswer(qId, qNum) {
    delete userSelectedAnswers[qNum];
    document.getElementById('palBtn-' + currentQuestionIndex)?.classList.remove('done');
    updatePaletteStats();
    renderCurrentQuestion(currentQuestionIndex);

    try {
      await fetch(`/api/sessions/\${activeSessionId}/answer`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ questionId: qId, selectedAnswer: null })
      });
    } catch (e) {
      console.error(e);
    }
  }

  function confirmSubmitTest() {
    const answeredCount = Object.keys(userSelectedAnswers).length;
    const unanswered = 100 - answeredCount;

    if (unanswered > 0) {
      const confirmMsg = `Bạn còn \${unanswered} câu chưa trả lời! Bạn có chắc chắn muốn nộp bài ngay bây giờ không?`;
      if (confirm(confirmMsg)) {
        submitTest(true);
      }
    } else {
      if (confirm('Bạn đã hoàn thành đủ 100 câu! Bạn có chắc chắn muốn nộp bài không?')) {
        submitTest(true);
      }
    }
  }

  async function submitTest(forceSubmit) {
    clearInterval(timerInterval);
    try {
      const res = await fetch(`/api/sessions/\${activeSessionId}/submit`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ forceSubmit: forceSubmit })
      });
      const data = await res.json();
      if (data.success) {
        showResults(data.result);
      } else {
        alert(data.message);
      }
    } catch (e) {
      alert(e.message);
    }
  }

  function showResults(result) {
    document.getElementById('activePracticeCard').style.display = 'none';
    document.getElementById('resultPracticeCard').style.display = 'block';

    document.getElementById('resToeicScore').innerText = result.toeicScore;
    document.getElementById('resCorrectCount').innerText = result.correctCount;
    document.getElementById('resWrongCount').innerText = result.wrongCount;
    document.getElementById('resSkippedCount').innerText = result.skippedCount;

    let html = '';
    result.details.forEach(d => {
      const statusColor = d.isCorrect ? 'var(--success)' : (d.isSkipped ? 'var(--warning)' : 'var(--danger)');
      const statusText = d.isCorrect ? 'ĐÚNG' : (d.isSkipped ? 'BỎ QUA' : 'SAI');
      html += `
        <div style="display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; border: 1px solid var(--gray-200); border-radius: 8px; margin-bottom: 8px; background: white;">
          <div style="display: flex; align-items: center; gap: 14px;">
            <span class="q-number-badge">Câu \${d.questionNumber}</span>
            <span>Đáp án đã chọn: <strong>\${d.selectedAnswer || '(Bỏ qua)'}</strong></span>
            <span>Đáp án đúng: <strong style="color: var(--success);">\${d.correctAnswer}</strong></span>
          </div>
          <div style="font-weight: 800; color: \${statusColor};">\${statusText}</div>
        </div>
      `;
    });
    document.getElementById('resultDetailsList').innerHTML = html;
  }

  function resetPractice() {
    document.getElementById('resultPracticeCard').style.display = 'none';
    document.getElementById('prePracticeCard').style.display = 'block';
  }

  // Init
  loadExamsList();
</script>
</body>
</html>
''';
  }
}
