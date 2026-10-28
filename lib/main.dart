// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/role_select_screen.dart';
import 'screens/auth/school_registration_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_students_screen.dart';
import 'screens/admin/admin_teachers_screen.dart';
import 'screens/admin/admin_classes_screen.dart';
import 'screens/admin/admin_subjects_screen.dart';
import 'screens/admin/admin_schedules_screen.dart';
import 'screens/admin/admin_homeroom_screen.dart';
import 'screens/teacher/teacher_schedule_screen.dart';
import 'screens/teacher/teacher_attendance_screen.dart';
import 'screens/teacher/teacher_assessments_screen.dart';
import 'screens/teacher/teacher_new_assessment_screen.dart';
import 'screens/teacher/teacher_scores_screen.dart';
import 'screens/teacher/teacher_raw_grades_screen.dart';
import 'screens/homeroom/homeroom_dashboard_screen.dart';
import 'screens/homeroom/homeroom_students_screen.dart';
import 'screens/homeroom/homeroom_attendance_screen.dart';
import 'screens/homeroom/homeroom_grades_screen.dart';
import 'screens/homeroom/homeroom_notes_screen.dart';

void main() {
  runApp(const EduManageApp());
}

class EduManageApp extends StatelessWidget {
  const EduManageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduManage School',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      initialRoute: '/login',
      routes: {
        '/login':                    (_) => const LoginScreen(),
        '/register-school':          (_) => const SchoolRegistrationScreen(),
        '/role-select':              (_) => const RoleSelectScreen(),
        '/admin/dashboard':          (_) => const AdminDashboardScreen(),
        '/admin/students':           (_) => const AdminStudentsScreen(),
        '/admin/teachers':           (_) => const AdminTeachersScreen(),
        '/admin/classes':            (_) => const AdminClassesScreen(),
        '/admin/subjects':           (_) => const AdminSubjectsScreen(),
        '/admin/schedules':          (_) => const AdminSchedulesScreen(),
        '/admin/homeroom':           (_) => const AdminHomeroomScreen(),
        '/teacher/schedule':         (_) => const TeacherScheduleScreen(),
        '/teacher/attendance':       (_) => const TeacherAttendanceScreen(),
        '/teacher/assessments':      (_) => const TeacherAssessmentsScreen(),
        '/teacher/new-assessment':   (_) => const TeacherNewAssessmentScreen(),
        '/teacher/scores':           (_) => const TeacherScoresScreen(),
        '/teacher/raw-grades':       (_) => const TeacherRawGradesScreen(),
        '/homeroom/dashboard':       (_) => const HomeroomDashboardScreen(),
        '/homeroom/students':        (_) => const HomeroomStudentsScreen(),
        '/homeroom/attendance':      (_) => const HomeroomAttendanceScreen(),
        '/homeroom/grades':          (_) => const HomeroomGradesScreen(),
        '/homeroom/notes':           (_) => const HomeroomNotesScreen(),
      },
    );
  }
}

typedef EduTrackApp = EduManageApp;
