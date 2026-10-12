# TOEIC Reading Examination System (Dart Backend)

Dự án Hệ thống Quản trị & Thi thử TOEIC Reading được xây dựng hoàn toàn bằng ngôn ngữ **Dart** (Dart SDK 3.13+, Shelf, SQLite3, OpenXML parser).

## Cấu trúc thư mục

```
toeic_backend/
├── bin/
│   └── server.dart                   # Entry point khởi chạy HTTP Server
├── lib/
│   ├── models/                       # Domain models (Exam, Part, Passage, Question, Answer, Session...)
│   │   ├── exam.dart
│   │   ├── exam_part.dart
│   │   ├── passage.dart
│   │   ├── question.dart
│   │   ├── answer.dart
│   │   ├── user_exam.dart
│   │   ├── user_answer.dart
│   │   └── validation_error.dart
│   ├── database/
│   │   └── database_helper.dart      # SQLite3 Database với 7 bảng & All-or-Nothing Transaction
│   ├── services/
│   │   ├── docx_parser.dart          # Bộ phân tích file Word .docx & trích xuất tags
│   │   ├── scoring_service.dart      # Bộ quy đổi thang điểm TOEIC ETS (5 - 495)
│   │   └── exam_service.dart         # Nghiệp vụ quản lý đề thi & phiên thi
│   └── controllers/
│       ├── api_controller.dart       # REST API cho Mobile App Frontend
│       └── admin_web_controller.dart # Giao diện Web Admin Dashboard & Test Simulator
├── test/
│   ├── toeic_system_test.dart        # Unit tests kiểm tra toàn bộ logic hệ thống
│   └── server_test.dart              # Integration tests cho các endpoint
└── pubspec.yaml
```

## Hướng dẫn cài đặt & Chạy

1. Cài đặt dependencies:
   ```bash
   dart pub get
   ```

2. Chạy kiểm thử:
   ```bash
   dart test
   ```

3. Khởi chạy Server:
   ```bash
   dart run bin/server.dart
   ```

4. Truy cập giao diện:
   - Web Admin Dashboard: `http://localhost:8080/admin/`
   - REST API Base: `http://localhost:8080/api/`
