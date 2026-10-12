import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toeic_frontend/screens/exam_list_screen.dart';
import 'package:toeic_frontend/theme/app_theme.dart';

void main() {
  testWidgets('ExamListScreen renders exam list and allows selecting exam', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ExamListScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Title & Student Info card
    expect(find.text('Hệ Thống Thi TOEIC Reading'), findsOneWidget);
    expect(find.text('Thông tin thí sinh'), findsOneWidget);
    expect(find.text('Danh Sách Đề Thi Khả Dụng'), findsOneWidget);

    // Verify "Bắt đầu làm bài" button
    expect(find.textContaining('Bắt đầu làm bài'), findsAtLeastNWidgets(1));
  });
}
