import 'package:flutter_test/flutter_test.dart';
import 'package:toeic_frontend/main.dart';

void main() {
  testWidgets('ToeicExamApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ToeicExamApp());

    // Verify key UI elements render properly
    expect(find.text('Rà soát đề thi'), findsOneWidget);
    expect(find.text('Kiểm định AI Auto-Check'), findsOneWidget);
  });
}
