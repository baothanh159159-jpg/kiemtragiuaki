import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toeic_frontend/screens/student_exam_screen.dart';
import 'package:toeic_frontend/theme/app_theme.dart';

void main() {
  testWidgets('StudentExamScreen renders countdown, questions, and palette', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const StudentExamScreen(),
      ),
    );

    // Initial frame
    await tester.pump();

    // Verify header title & timer
    expect(find.text('Active Reading Test'), findsOneWidget);
    expect(find.text('TOEIC Reading ETS 01'), findsOneWidget);

    // Verify Part 5 and Question 101
    expect(find.text('Câu 101'), findsOneWidget);
    expect(find.text('before'), findsOneWidget);

    // Tap "Bảng câu" button to open palette modal bottom sheet
    final paletteBtn = find.text('Bảng câu');
    expect(paletteBtn, findsOneWidget);
    await tester.tap(paletteBtn);
    await tester.pumpAndSettle();

    // Verify palette sheet is displayed
    expect(find.text('Bảng câu hỏi TOEIC Reading'), findsOneWidget);
    expect(find.text('Đóng bảng'), findsOneWidget);

    // Close palette
    await tester.tap(find.text('Đóng bảng'));
    await tester.pumpAndSettle();

    // Tap "Nộp bài (Còn 32 câu)"
    final submitBtn = find.byIcon(Icons.assignment_turned_in);
    expect(submitBtn, findsOneWidget);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Verify Submit modal dialog
    expect(find.text('Bạn chắc chắn muốn nộp bài?'), findsOneWidget);
    expect(find.text('Tiếp tục làm bài'), findsOneWidget);

    // Dismiss dialog
    await tester.tap(find.text('Tiếp tục làm bài'));
    await tester.pumpAndSettle();
  });
}
