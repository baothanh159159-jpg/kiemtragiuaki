import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/admin_screen.dart';
import 'screens/exam_list_screen.dart';
import 'screens/student_exam_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ToeicExamApp());
}

class ToeicExamApp extends StatelessWidget {
  const ToeicExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống Khảo thí TOEIC Reading Active',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoleWrapperScreen(),
    );
  }
}

class RoleWrapperScreen extends StatefulWidget {
  const RoleWrapperScreen({super.key});

  @override
  State<RoleWrapperScreen> createState() => _RoleWrapperScreenState();
}

class _RoleWrapperScreenState extends State<RoleWrapperScreen> {
  // 0: Admin, 1: Student Exam List, 2: Direct Student Test
  int _currentRoleIndex = 0;

  void _switchRole(int index) {
    setState(() {
      _currentRoleIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;
    switch (_currentRoleIndex) {
      case 0:
        currentWidget = AdminScreen(
          key: const ValueKey('admin_screen'),
          onSwitchToStudent: () => _switchRole(1),
        );
        break;
      case 1:
        currentWidget = ExamListScreen(
          key: const ValueKey('exam_list_screen'),
          onSwitchToAdmin: () => _switchRole(0),
        );
        break;
      default:
        currentWidget = StudentExamScreen(
          key: const ValueKey('student_screen'),
          onSwitchToAdmin: () => _switchRole(0),
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: currentWidget,
    );
  }
}
