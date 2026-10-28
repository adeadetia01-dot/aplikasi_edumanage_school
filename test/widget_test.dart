import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edutrack_school/main.dart';
import 'package:edutrack_school/screens/admin/admin_students_screen.dart';
import 'package:edutrack_school/screens/admin/admin_classes_screen.dart';
import 'package:edutrack_school/screens/teacher/teacher_attendance_screen.dart';
import 'package:edutrack_school/services/academic_service.dart';
import 'package:edutrack_school/services/auth_service.dart';

void main() {
  testWidgets('login screen renders and teacher logs in with unique number to role select',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EduTrackApp());
    await tester.pump();

    // Login screen
    expect(find.text('EduManage School'), findsOneWidget);
    expect(find.text('Login Guru'), findsOneWidget);
    expect(find.text('Login Admin'), findsOneWidget);
    expect(find.text('NOMOR UNIK GURU (NIP / NUPTK)'), findsOneWidget);
    expect(find.text('Masuk sebagai Guru →'), findsOneWidget);
    expect(find.text('Sekolah Baru? Daftarkan Sekolah di EduManage →'), findsOneWidget);

    // Login guru default Budi (19810101, homeroom teacher) → navigates to role-select
    await tester.tap(find.text('Masuk sebagai Guru →'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih peran untuk melanjutkan'), findsOneWidget);
    expect(find.text('Guru Mata Pelajaran'), findsOneWidget);
    expect(find.text('Wali Kelas X-MIPA 1'), findsOneWidget);
  });

  testWidgets('new school registration flow works and registers school with admin account',
      (WidgetTester tester) async {
    final regError = AuthService.instance.registerSchool(
      schoolName: 'SMA Negeri 1 Harapan Bangsa',
      npsn: '20199887',
      level: 'SMA / SMK / MA',
      city: 'Bandung',
      address: 'Jl. Merdeka No. 45',
      schoolEmail: 'info@sman1harapan.sch.id',
      schoolPhone: '022-7201234',
      adminName: 'Drs. H. Mulyono',
      adminUsername: 'admin_harapan',
      adminPassword: 'password123',
    );

    expect(regError, isNull);
    expect(AuthService.instance.schools.any((s) => s.npsn == '20199887'), isTrue);

    // Login using the newly created admin account
    final loginErr = AuthService.instance.loginAdmin(
      username: 'admin_harapan',
      password: 'password123',
    );
    expect(loginErr, isNull);
    expect(AuthService.instance.currentUser?.name, 'Drs. H. Mulyono');
    expect(AuthService.instance.currentSchool?.name, 'SMA Negeri 1 Harapan Bangsa');
  });

  testWidgets('admin can create teacher account and teacher can login with unique number',
      (WidgetTester tester) async {
    // Admin creates teacher account
    final err = AuthService.instance.createTeacherAccount(
      uniqueNumber: '19951234',
      name: 'Rina Kusuma, S.Pd.',
      password: 'rinapassword',
      subject: 'Kimia',
      isHomeroom: false,
    );
    expect(err, isNull);

    // Guru attempts to login with the created unique number and password
    final loginErr = AuthService.instance.loginGuru(
      uniqueNumber: '19951234',
      password: 'rinapassword',
    );
    expect(loginErr, isNull);
    expect(AuthService.instance.currentUser?.name, 'Rina Kusuma, S.Pd.');
    expect(AuthService.instance.currentUser?.uniqueNumber, '19951234');
    expect(AuthService.instance.currentUser?.subject, 'Kimia');

    // Guru cannot login with wrong password
    final wrongPassErr = AuthService.instance.loginGuru(
      uniqueNumber: '19951234',
      password: 'wrongpass',
    );
    expect(wrongPassErr, isNotNull);
  });

  testWidgets('student CRUD operations work properly', (WidgetTester tester) async {
    // 1. Create Student
    final addErr = AcademicService.instance.addStudent(
      nis: '29901',
      nisn: '0091234567',
      name: 'Daffa Rizky Pratama',
      gender: 'L',
      className: 'X-MIPA 1',
      status: 'Aktif',
      phone: '081299990001',
      parentName: 'Rizky',
    );
    expect(addErr, isNull);

    final createdStudent = AcademicService.instance.students.firstWhere((s) => s.nis == '29901');
    expect(createdStudent.name, 'Daffa Rizky Pratama');
    expect(createdStudent.className, 'X-MIPA 1');

    // 2. Read / Verify duplicate NIS prevention
    final dupErr = AcademicService.instance.addStudent(
      nis: '29901',
      name: 'Siswa Duplikat',
      gender: 'L',
      className: 'X-MIPA 1',
    );
    expect(dupErr, isNotNull);

    // 3. Update Student
    final updateErr = AcademicService.instance.updateStudent(
      id: createdStudent.id,
      nis: '29901',
      name: 'Daffa Rizky Updated',
      gender: 'L',
      className: 'X-MIPA 2',
      status: 'Aktif',
      phone: '081299990002',
      parentName: 'Rizky Pratama',
    );
    expect(updateErr, isNull);
    final updatedStudent = AcademicService.instance.students.firstWhere((s) => s.id == createdStudent.id);
    expect(updatedStudent.name, 'Daffa Rizky Updated');
    expect(updatedStudent.className, 'X-MIPA 2');

    // 4. Delete Student
    final delErr = AcademicService.instance.deleteStudent(createdStudent.id);
    expect(delErr, isNull);
    expect(AcademicService.instance.students.any((s) => s.id == createdStudent.id), isFalse);
  });

  testWidgets('class CRUD operations work properly', (WidgetTester tester) async {
    // 1. Create Class
    final addClassErr = AcademicService.instance.addClass(
      name: 'X-IPS 1',
      gradeLevel: 'X',
      major: 'IPS',
      capacity: 32,
      room: 'Ruang 104',
      homeroomTeacher: 'Siti Rahma, S.Pd.',
    );
    expect(addClassErr, isNull);

    final createdClass = AcademicService.instance.classes.firstWhere((c) => c.name == 'X-IPS 1');
    expect(createdClass.major, 'IPS');
    expect(createdClass.capacity, 32);

    // 2. Read / Duplicate class prevention
    final dupErr = AcademicService.instance.addClass(
      name: 'X-IPS 1',
      gradeLevel: 'X',
      major: 'IPS',
    );
    expect(dupErr, isNotNull);

    // 3. Update Class
    final updateErr = AcademicService.instance.updateClass(
      id: createdClass.id,
      name: 'X-IPS 1 Unggulan',
      gradeLevel: 'X',
      major: 'IPS',
      capacity: 30,
      room: 'Ruang 105',
      homeroomTeacher: 'Siti Rahma, S.Pd.',
    );
    expect(updateErr, isNull);
    final updatedClass = AcademicService.instance.classes.firstWhere((c) => c.id == createdClass.id);
    expect(updatedClass.name, 'X-IPS 1 Unggulan');
    expect(updatedClass.capacity, 30);

    // 4. Delete Class without students succeeds
    final delErr = AcademicService.instance.deleteClass(createdClass.id);
    expect(delErr, isNull);
    expect(AcademicService.instance.classes.any((c) => c.id == createdClass.id), isFalse);
  });

  // Design state "Empty" (docs/EduTrack_School_Wireframe_Panduan.md)
  testWidgets('admin students shows empty state on no search result',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminStudentsScreen()));

    await tester.enterText(find.byType(TextField).first, 'zzzzz');
    await tester.pump();

    expect(find.text('Siswa tidak ditemukan'), findsOneWidget);
    expect(find.text('Ahmad Fauzan'), findsNothing);
  });

  testWidgets('admin classes screen renders and lists classes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminClassesScreen()));
    await tester.pump();

    expect(find.text('Kelola Data Kelas'), findsOneWidget);
    expect(find.text('Daftar Rombongan Belajar'), findsOneWidget);
    expect(find.text('X-MIPA 1'), findsOneWidget);
    expect(find.text('SEMESTER AKTIF'), findsOneWidget);
  });

  testWidgets('teacher attendance shows empty state on no search result',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TeacherAttendanceScreen()));

    await tester.enterText(find.byType(TextField).first, 'zzzzz');
    await tester.pump();

    expect(find.text('Tidak ada siswa pada filter ini'), findsOneWidget);
    expect(find.text('Ahmad Fauzan'), findsNothing);
  });
}
