import 'package:flutter/foundation.dart';

enum UserRole {
  admin,
  teacher,
}

class SchoolModel {
  final String id;
  final String name;
  final String npsn;
  final String level;
  final String city;
  final String address;
  final String phone;
  final String email;
  final String adminUserId;
  final String academicYear;
  final DateTime createdAt;

  SchoolModel({
    required this.id,
    required this.name,
    required this.npsn,
    required this.level,
    required this.city,
    required this.address,
    required this.phone,
    required this.email,
    required this.adminUserId,
    this.academicYear = '2026/2027 • Ganjil',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class UserModel {
  final String id;
  final String uniqueNumber; // Nomor Unik Guru (NIP/NUPTK) atau ID Admin
  String name;
  String password;
  final UserRole role;
  String subject;
  bool isHomeroom;
  String? homeroomClass;
  bool isActive;
  final String? schoolId;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.uniqueNumber,
    required this.name,
    required this.password,
    required this.role,
    this.subject = '-',
    this.isHomeroom = false,
    this.homeroomClass,
    this.isActive = true,
    this.schoolId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isAdmin => role == UserRole.admin;
  bool get isTeacher => role == UserRole.teacher;

  UserModel copyWith({
    String? name,
    String? password,
    String? subject,
    bool? isHomeroom,
    String? homeroomClass,
    bool? isActive,
    String? schoolId,
  }) {
    return UserModel(
      id: id,
      uniqueNumber: uniqueNumber,
      name: name ?? this.name,
      password: password ?? this.password,
      role: role,
      subject: subject ?? this.subject,
      isHomeroom: isHomeroom ?? this.isHomeroom,
      homeroomClass: homeroomClass ?? this.homeroomClass,
      isActive: isActive ?? this.isActive,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt,
    );
  }
}

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();

  AuthService._internal() {
    _seedInitialData();
  }

  final List<SchoolModel> _schools = [];
  final List<UserModel> _users = [];
  UserModel? _currentUser;
  SchoolModel? _activeSchool;

  List<SchoolModel> get schools => List.unmodifiable(_schools);
  List<UserModel> get users => List.unmodifiable(_users);
  List<UserModel> get teachers {
    if (_activeSchool != null) {
      return _users
          .where((u) => u.role == UserRole.teacher && (u.schoolId == null || u.schoolId == _activeSchool!.id))
          .toList();
    }
    return _users.where((u) => u.role == UserRole.teacher).toList();
  }

  UserModel? get currentUser => _currentUser;
  SchoolModel? get currentSchool => _activeSchool;
  bool get isAuthenticated => _currentUser != null;

  void _seedInitialData() {
    // 1. Data Sekolah Awal
    final defaultSchool = SchoolModel(
      id: 'SCH-001',
      name: 'SMA EduManage Nusantara',
      npsn: '20104567',
      level: 'SMA / SMK',
      city: 'Jakarta Selatan',
      address: 'Jl. Merdeka Belajar No. 10',
      phone: '021-5551234',
      email: 'kontak@edumanage.sch.id',
      adminUserId: 'ADM-001',
      academicYear: '2026/2027 • Ganjil',
    );
    _schools.add(defaultSchool);
    _activeSchool = defaultSchool;

    // 2. Akun Admin Utama
    _users.add(UserModel(
      id: 'ADM-001',
      uniqueNumber: 'admin',
      name: 'Administrator Sekolah',
      password: 'admin123',
      role: UserRole.admin,
      subject: 'Manajemen Sistem',
      isActive: true,
      schoolId: 'SCH-001',
    ));

    // 3. Akun Guru-Guru Awal (Dibuatkan oleh Admin)
    _users.addAll([
      UserModel(
        id: 'GUR-001',
        uniqueNumber: '19810101',
        name: 'Budi Santoso, S.Pd.',
        password: 'password123',
        role: UserRole.teacher,
        subject: 'Bahasa Indonesia',
        isHomeroom: true,
        homeroomClass: 'X-MIPA 1',
        isActive: true,
        schoolId: 'SCH-001',
      ),
      UserModel(
        id: 'GUR-002',
        uniqueNumber: '19850214',
        name: 'Siti Rahma, S.Pd.',
        password: 'password123',
        role: UserRole.teacher,
        subject: 'Matematika',
        isHomeroom: false,
        isActive: true,
        schoolId: 'SCH-001',
      ),
      UserModel(
        id: 'GUR-003',
        uniqueNumber: '19900325',
        name: 'Andi Prakoso, S.Pd.',
        password: 'password123',
        role: UserRole.teacher,
        subject: 'Bahasa Inggris',
        isHomeroom: false,
        isActive: true,
        schoolId: 'SCH-001',
      ),
      UserModel(
        id: 'GUR-004',
        uniqueNumber: '19920418',
        name: 'Dewi Lestari, S.Pd.',
        password: 'password123',
        role: UserRole.teacher,
        subject: 'Biologi',
        isHomeroom: false,
        isActive: true,
        schoolId: 'SCH-001',
      ),
    ]);
  }

  /// Pendaftaran Sekolah Baru:
  /// Membuat instansi sekolah dan akun Administrator utama untuk sekolah tersebut.
  String? registerSchool({
    required String schoolName,
    required String npsn,
    required String level,
    required String city,
    required String address,
    required String schoolEmail,
    required String schoolPhone,
    required String adminName,
    required String adminUsername,
    required String adminPassword,
    String academicYear = '2026/2027 • Ganjil',
  }) {
    final cleanName = schoolName.trim();
    final cleanNpsn = npsn.trim();
    final cleanCity = city.trim();
    final cleanAddress = address.trim();
    final cleanEmail = schoolEmail.trim();
    final cleanPhone = schoolPhone.trim();
    final cleanAdminName = adminName.trim();
    final cleanAdminUser = adminUsername.trim();
    final cleanAdminPass = adminPassword.trim();

    if (cleanName.isEmpty) return 'Nama sekolah wajib diisi.';
    if (cleanNpsn.isEmpty) return 'NPSN sekolah wajib diisi.';
    if (cleanNpsn.length < 8) return 'NPSN minimal 8 karakter digit.';
    if (cleanCity.isEmpty) return 'Kota/Kabupaten sekolah wajib diisi.';
    if (cleanAddress.isEmpty) return 'Alamat sekolah wajib diisi.';
    if (cleanEmail.isEmpty) return 'Email sekolah wajib diisi.';
    if (cleanAdminName.isEmpty) return 'Nama admin penanggung jawab wajib diisi.';
    if (cleanAdminUser.isEmpty) return 'Username admin wajib diisi.';
    if (cleanAdminPass.length < 6) return 'Kata sandi admin minimal 6 karakter.';

    // Cek duplikasi NPSN
    if (_schools.any((s) => s.npsn.toLowerCase() == cleanNpsn.toLowerCase())) {
      return 'NPSN "$cleanNpsn" sudah terdaftar di sistem EduManage.';
    }

    // Cek duplikasi username admin
    if (_users.any((u) => u.uniqueNumber.toLowerCase() == cleanAdminUser.toLowerCase())) {
      return 'Username admin "$cleanAdminUser" sudah digunakan. Silakan pilih username lain.';
    }

    final newSchoolId = 'SCH-${(_schools.length + 1).toString().padLeft(3, '0')}';
    final newAdminId = 'ADM-${(_users.length + 1).toString().padLeft(3, '0')}';

    // Buat akun admin utama untuk sekolah baru ini
    final newAdmin = UserModel(
      id: newAdminId,
      uniqueNumber: cleanAdminUser,
      name: cleanAdminName,
      password: cleanAdminPass,
      role: UserRole.admin,
      subject: 'Administrator Sekolah',
      isActive: true,
      schoolId: newSchoolId,
      createdAt: DateTime.now(),
    );

    // Buat data sekolah baru
    final newSchool = SchoolModel(
      id: newSchoolId,
      name: cleanName,
      npsn: cleanNpsn,
      level: level,
      city: cleanCity,
      address: cleanAddress,
      phone: cleanPhone,
      email: cleanEmail,
      adminUserId: newAdminId,
      academicYear: academicYear,
      createdAt: DateTime.now(),
    );

    _schools.add(newSchool);
    _users.add(newAdmin);

    // Set sebagai sekolah aktif
    _activeSchool = newSchool;

    notifyListeners();
    return null; // Berhasil
  }

  /// Autentikasi untuk Guru:
  /// Guru hanya login dengan Nomor Unik Guru dan Kata Sandi.
  /// Tidak ada pendaftaran mandiri untuk guru.
  String? loginGuru({
    required String uniqueNumber,
    required String password,
  }) {
    final cleanNumber = uniqueNumber.trim();
    final cleanPass = password.trim();

    if (cleanNumber.isEmpty) {
      return 'Nomor Unik Guru wajib diisi.';
    }
    if (cleanPass.isEmpty) {
      return 'Kata sandi wajib diisi.';
    }

    final teacher = _users.cast<UserModel?>().firstWhere(
          (u) =>
              u != null &&
              u.role == UserRole.teacher &&
              u.uniqueNumber.toLowerCase() == cleanNumber.toLowerCase(),
          orElse: () => null,
        );

    if (teacher == null) {
      return 'Nomor Unik Guru tidak terdaftar.\nAkun guru dibuatkan oleh Admin Sekolah. Silakan hubungi Admin Sekolah.';
    }

    if (!teacher.isActive) {
      return 'Akun guru ini sedang dinonaktifkan oleh Admin.\nHubungi Admin Sekolah untuk mengaktifkan kembali.';
    }

    if (teacher.password != cleanPass) {
      return 'Kata sandi salah. Silakan coba lagi atau minta reset sandi ke Admin.';
    }

    _currentUser = teacher;
    // Set sekolah aktif sesuai user jika ada
    if (teacher.schoolId != null) {
      _activeSchool = _schools.cast<SchoolModel?>().firstWhere(
            (s) => s != null && s.id == teacher.schoolId,
            orElse: () => _activeSchool,
          );
    }
    notifyListeners();
    return null;
  }

  /// Autentikasi untuk Admin Sekolah:
  String? loginAdmin({
    required String username,
    required String password,
  }) {
    final cleanUser = username.trim();
    final cleanPass = password.trim();

    if (cleanUser.isEmpty) {
      return 'Username / ID Admin wajib diisi.';
    }
    if (cleanPass.isEmpty) {
      return 'Kata sandi admin wajib diisi.';
    }

    final admin = _users.cast<UserModel?>().firstWhere(
          (u) =>
              u != null &&
              u.role == UserRole.admin &&
              (u.uniqueNumber.toLowerCase() == cleanUser.toLowerCase() ||
                  u.id.toLowerCase() == cleanUser.toLowerCase()),
          orElse: () => null,
        );

    if (admin == null || admin.password != cleanPass) {
      return 'ID Admin atau Kata Sandi salah.';
    }

    _currentUser = admin;
    if (admin.schoolId != null) {
      _activeSchool = _schools.cast<SchoolModel?>().firstWhere(
            (s) => s != null && s.id == admin.schoolId,
            orElse: () => _activeSchool,
          );
    }
    notifyListeners();
    return null;
  }

  /// Login langsung sebagai user yang sudah ada (misal setelah registrasi sukses)
  void loginDirect(UserModel user) {
    _currentUser = user;
    if (user.schoolId != null) {
      _activeSchool = _schools.cast<SchoolModel?>().firstWhere(
            (s) => s != null && s.id == user.schoolId,
            orElse: () => _activeSchool,
          );
    }
    notifyListeners();
  }

  /// Admin membuatkan akun guru baru:
  String? createTeacherAccount({
    required String uniqueNumber,
    required String name,
    required String password,
    required String subject,
    bool isHomeroom = false,
    String? homeroomClass,
  }) {
    final cleanNumber = uniqueNumber.trim();
    final cleanName = name.trim();
    final cleanPass = password.trim();
    final cleanSubject = subject.trim();

    if (cleanNumber.isEmpty) return 'Nomor Unik Guru wajib diisi.';
    if (cleanName.isEmpty) return 'Nama lengkap guru wajib diisi.';
    if (cleanPass.isEmpty) return 'Kata sandi wajib diisi.';
    if (cleanPass.length < 4) return 'Kata sandi minimal 4 karakter.';
    if (cleanSubject.isEmpty) return 'Mata pelajaran wajib dipilih atau diisi.';

    final exists = _users.any(
      (u) => u.uniqueNumber.toLowerCase() == cleanNumber.toLowerCase(),
    );
    if (exists) {
      return 'Nomor Unik Guru "$cleanNumber" sudah terdaftar. Gunakan nomor unik yang berbeda.';
    }

    final newTeacher = UserModel(
      id: 'GUR-${(_users.length + 1).toString().padLeft(3, '0')}',
      uniqueNumber: cleanNumber,
      name: cleanName,
      password: cleanPass,
      role: UserRole.teacher,
      subject: cleanSubject,
      isHomeroom: isHomeroom,
      homeroomClass: isHomeroom ? homeroomClass : null,
      isActive: true,
      schoolId: _activeSchool?.id,
      createdAt: DateTime.now(),
    );

    _users.add(newTeacher);
    notifyListeners();
    return null;
  }

  /// Admin memperbarui data guru:
  String? updateTeacher({
    required String id,
    required String name,
    required String subject,
    required bool isHomeroom,
    String? homeroomClass,
  }) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx == -1) return 'Data guru tidak ditemukan.';

    _users[idx].name = name.trim();
    _users[idx].subject = subject.trim();
    _users[idx].isHomeroom = isHomeroom;
    _users[idx].homeroomClass = isHomeroom ? homeroomClass : null;

    notifyListeners();
    return null;
  }

  /// Admin mereset password akun guru:
  String? resetTeacherPassword({
    required String id,
    required String newPassword,
  }) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx == -1) return 'Data guru tidak ditemukan.';

    if (newPassword.trim().length < 4) {
      return 'Kata sandi minimal 4 karakter.';
    }

    _users[idx].password = newPassword.trim();
    notifyListeners();
    return null;
  }

  /// Admin mengaktifkan/menonaktifkan akun guru:
  void toggleTeacherStatus(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx].isActive = !_users[idx].isActive;
      notifyListeners();
    }
  }

  /// Admin menghapus akun guru:
  void deleteTeacher(String id) {
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  /// Keluar / Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
