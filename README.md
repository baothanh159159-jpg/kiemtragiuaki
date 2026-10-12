# Hệ Thống Khảo Thí & Luyện Thi TOEIC Reading Trực Tuyến

> **Bài thi giữa kỳ môn Phát triển Ứng dụng**  
> **Sinh viên:** Lê Vũ Bảo Thanh  
> **MSSV:** 2380614762  
> **Công nghệ:** Dart Backend (Shelf REST API, SQLite3), Flutter Web Frontend  

---

## 🚀 Giới thiệu dự án

Hệ thống mô phỏng bài thi **TOEIC Reading ETS chuẩn hóa** với 100 câu hỏi (từ Câu 101 đến Câu 200), thời gian làm bài **75 phút**, gồm 3 phần thi:
- **Part 5: Incomplete Sentences** (30 câu)
- **Part 6: Text Completion** (16 câu chia đều 4 bài đọc)
- **Part 7: Reading Comprehension** (54 câu chia đều 15 bài đọc đơn & kép)

Hệ thống tích hợp đầy đủ hai phân hệ người dùng:
1. **Phân hệ Giảng viên / Quản trị viên (Admin):**
   - Import đề thi từ file Word (.docx) chuẩn hóa với cơ chế kiểm duyệt **All-or-Nothing**.
   - Rà soát, kiểm định lỗi câu hỏi, xem trước đề thi.
   - Chỉnh sửa trực tiếp tên đề, thời gian thi, câu hỏi, 4 đáp án A/B/C/D, đáp án đúng (Key) và lời giải thích/dịch nghĩa vào CSDL.
   - Sửa bài đọc (Passages) ở Part 6 & 7.
2. **Phân hệ Thí sinh / Học viên (Student):**
   - Danh sách đề thi khả dụng trong CSDL.
   - Phòng thi trực tuyến với đồng hồ đếm ngược 75 phút, đồng bộ từng giây.
   - Bảng Palette 100 câu hỏi: hiển thị trạng thái đã làm, chưa làm, gắn cờ xem lại.
   - Chấm điểm tự động chuẩn hóa thang điểm TOEIC ETS (5 - 495 điểm).
   - Báo cáo chi tiết điểm số, số câu đúng/sai/bỏ qua, xem lại đáp án và lời giải chi tiết.

---

## 🛠 Cấu trúc thư mục

```text
kt/
├── backend/
│   └── toeic_backend/          # Dart Shelf REST API Server
│       ├── bin/server.dart     # Entry point backend
│       ├── lib/
│       │   ├── controllers/    # API endpoints (GET, POST, PUT)
│       │   ├── database/       # SQLite helper & schema 7 bảng
│       │   ├── parsers/        # Word (.docx) All-or-Nothing parser
│       │   └── services/       # Exam logic, ETS score calculation
│       ├── sql/schema.sql      # Định nghĩa CSDL 7 bảng chuẩn
│       └── toeic_reading.db    # File SQLite CSDL
├── frontend/                   # Flutter Web Application
│   ├── lib/
│   │   ├── models/             # Data models (Exam, Question, Answer, Submission)
│   │   ├── screens/            # AdminScreen, ExamListScreen, StudentExamScreen
│   │   ├── services/           # ApiService (REST API client)
│   │   └── theme/              # AppTheme & color palette
│   └── test/                   # Widget tests
├── Reading_v01_Tagged.docx     # File Word đề thi TOEIC chuẩn hóa tags
├── Đề thi giữa kỳ.docx         # Đề bài yêu cầu giữa kỳ
└── HUONG_DAN_VA_BAO_CAO_GIUA_KY.md # Báo cáo chi tiết 10/10 điểm
```

---

## 💻 Hướng dẫn chạy ứng dụng

### 1. Khởi động Backend (Dart Server)
```bash
cd backend/toeic_backend
dart pub get
dart run bin/server.dart
```
> Server sẽ lắng nghe tại `http://localhost:8080`.

### 2. Khởi động Frontend (Flutter Web)
```bash
cd frontend
flutter pub get
flutter run -d chrome --web-port 3000
```
> Trình duyệt Chrome sẽ tự động mở `http://localhost:3000`.

---

## 🧪 Chạy Kiểm thử Tự động (Tests)
```bash
cd frontend
flutter test
```
