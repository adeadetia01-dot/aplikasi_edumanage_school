import 'package:flutter/foundation.dart';

class ClassModel {
  final String id;
  String name;
  String gradeLevel; // 'X', 'XI', 'XII'
  String major; // 'MIPA', 'IPS', 'Bahasa', 'Umum'
  int capacity;
  String room;
  String? homeroomTeacher;

  ClassModel({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.major,
    this.capacity = 36,
    this.room = '-',
    this.homeroomTeacher,
  });

  ClassModel copyWith({
    String? name,
    String? gradeLevel,
    String? major,
    int? capacity,
    String? room,
    String? homeroomTeacher,
  }) {
    return ClassModel(
      id: id,
      name: name ?? this.name,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      major: major ?? this.major,
      capacity: capacity ?? this.capacity,
      room: room ?? this.room,
      homeroomTeacher: homeroomTeacher ?? this.homeroomTeacher,
    );
  }
}

class StudentModel {
  final String id;
  String nis;
  String? nisn;
  String name;
  String gender; // 'L' atau 'P'
  String className;
  String status; // 'Aktif', 'Pindah', 'Lulus', 'Nonaktif'
  String? phone;
  String? parentName;
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.nis,
    this.nisn,
    required this.name,
    required this.gender,
    required this.className,
    this.status = 'Aktif',
    this.phone,
    this.parentName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  StudentModel copyWith({
    String? nis,
    String? nisn,
    String? name,
    String? gender,
    String? className,
    String? status,
    String? phone,
    String? parentName,
  }) {
    return StudentModel(
      id: id,
      nis: nis ?? this.nis,
      nisn: nisn ?? this.nisn,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      className: className ?? this.className,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      parentName: parentName ?? this.parentName,
      createdAt: createdAt,
    );
  }
}

class AcademicService extends ChangeNotifier {
  static final AcademicService instance = AcademicService._internal();

  AcademicService._internal() {
    _seedInitialData();
  }

  final List<ClassModel> _classes = [];
  final List<StudentModel> _students = [];

  List<ClassModel> get classes => List.unmodifiable(_classes);
  List<StudentModel> get students => List.unmodifiable(_students);

  int get totalClasses => _classes.length;
  int get totalStudents => _students.length;

  int studentCountForClass(String className) {
    return _students.where((s) => s.className == className).length;
  }

  void _seedInitialData() {
    // 1. Data Kelas Awal
    _classes.addAll([
      ClassModel(
        id: 'CLS-001',
        name: 'X-MIPA 1',
        gradeLevel: 'X',
        major: 'MIPA',
        capacity: 36,
        room: 'Ruang 101',
        homeroomTeacher: 'Budi Santoso, S.Pd.',
      ),
      ClassModel(
        id: 'CLS-002',
        name: 'X-MIPA 2',
        gradeLevel: 'X',
        major: 'MIPA',
        capacity: 36,
        room: 'Ruang 102',
        homeroomTeacher: 'Siti Rahma, S.Pd.',
      ),
      ClassModel(
        id: 'CLS-003',
        name: 'XI-MIPA 1',
        gradeLevel: 'XI',
        major: 'MIPA',
        capacity: 36,
        room: 'Ruang 201',
        homeroomTeacher: 'Andi Prakoso, S.Pd.',
      ),
      ClassModel(
        id: 'CLS-004',
        name: 'XI-MIPA 2',
        gradeLevel: 'XI',
        major: 'MIPA',
        capacity: 34,
        room: 'Ruang 202',
        homeroomTeacher: 'Dewi Lestari, S.Pd.',
      ),
      ClassModel(
        id: 'CLS-005',
        name: 'XII-MIPA 1',
        gradeLevel: 'XII',
        major: 'MIPA',
        capacity: 36,
        room: 'Ruang 301',
        homeroomTeacher: 'Budi Santoso, S.Pd.',
      ),
      ClassModel(
        id: 'CLS-006',
        name: 'XII-MIPA 2',
        gradeLevel: 'XII',
        major: 'MIPA',
        capacity: 36,
        room: 'Ruang 302',
      ),
    ]);

    // 2. Data Siswa Awal
    _students.addAll([
      StudentModel(
        id: 'STD-001',
        nis: '21084',
        nisn: '0071234561',
        name: 'Ahmad Fauzan',
        gender: 'L',
        className: 'XI-MIPA 2',
        status: 'Aktif',
        phone: '081234567801',
        parentName: 'H. Fauzan',
      ),
      StudentModel(
        id: 'STD-002',
        nis: '21085',
        nisn: '0071234562',
        name: 'Bella Safitri',
        gender: 'P',
        className: 'XI-MIPA 2',
        status: 'Aktif',
        phone: '081234567802',
        parentName: 'Safitri',
      ),
      StudentModel(
        id: 'STD-003',
        nis: '21086',
        nisn: '0071234563',
        name: 'Dimas Arya Pratama',
        gender: 'L',
        className: 'XI-MIPA 2',
        status: 'Aktif',
        phone: '081234567803',
        parentName: 'Pratama',
      ),
      StudentModel(
        id: 'STD-004',
        nis: '21087',
        nisn: '0071234564',
        name: 'Farhan Aditya',
        gender: 'L',
        className: 'XI-MIPA 2',
        status: 'Aktif',
        phone: '081234567804',
        parentName: 'Aditya',
      ),
      StudentModel(
        id: 'STD-005',
        nis: '21088',
        nisn: '0071234565',
        name: 'Gita Maharani',
        gender: 'P',
        className: 'XI-MIPA 2',
        status: 'Aktif',
        phone: '081234567805',
        parentName: 'Maharani',
      ),
      StudentModel(
        id: 'STD-006',
        nis: '21089',
        nisn: '0071234566',
        name: 'Annisa Rahmadani',
        gender: 'P',
        className: 'XI-MIPA 2',
        status: 'Aktif',
        phone: '081234567806',
        parentName: 'Rahmadani',
      ),
      StudentModel(
        id: 'STD-007',
        nis: '22001',
        nisn: '0081234501',
        name: 'Bagus Setiawan',
        gender: 'L',
        className: 'X-MIPA 1',
        status: 'Aktif',
        phone: '081234567807',
        parentName: 'Setiawan',
      ),
      StudentModel(
        id: 'STD-008',
        nis: '22002',
        nisn: '0081234502',
        name: 'Citra Kirana',
        gender: 'P',
        className: 'X-MIPA 1',
        status: 'Aktif',
        phone: '081234567808',
        parentName: 'Kirana',
      ),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CRUD KELAS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Tambah Kelas Baru (Create)
  String? addClass({
    required String name,
    required String gradeLevel,
    required String major,
    int capacity = 36,
    String room = '-',
    String? homeroomTeacher,
  }) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return 'Nama kelas wajib diisi.';

    final exists = _classes.any(
      (c) => c.name.toLowerCase() == cleanName.toLowerCase(),
    );
    if (exists) return 'Kelas "$cleanName" sudah ada.';

    final newClass = ClassModel(
      id: 'CLS-${(_classes.length + 1).toString().padLeft(3, '0')}',
      name: cleanName,
      gradeLevel: gradeLevel.trim(),
      major: major.trim(),
      capacity: capacity,
      room: room.trim(),
      homeroomTeacher: homeroomTeacher?.trim(),
    );

    _classes.add(newClass);
    notifyListeners();
    return null;
  }

  /// Perbarui Data Kelas (Update)
  String? updateClass({
    required String id,
    required String name,
    required String gradeLevel,
    required String major,
    required int capacity,
    required String room,
    String? homeroomTeacher,
  }) {
    final idx = _classes.indexWhere((c) => c.id == id);
    if (idx == -1) return 'Kelas tidak ditemukan.';

    final cleanName = name.trim();
    if (cleanName.isEmpty) return 'Nama kelas tidak boleh kosong.';

    final duplicate = _classes.any(
      (c) => c.id != id && c.name.toLowerCase() == cleanName.toLowerCase(),
    );
    if (duplicate) return 'Nama kelas "$cleanName" sudah digunakan kelas lain.';

    final oldName = _classes[idx].name;

    _classes[idx].name = cleanName;
    _classes[idx].gradeLevel = gradeLevel.trim();
    _classes[idx].major = major.trim();
    _classes[idx].capacity = capacity;
    _classes[idx].room = room.trim();
    _classes[idx].homeroomTeacher = homeroomTeacher?.trim();

    // Jika nama kelas berubah, update siswa yang terdaftar di kelas tersebut
    if (oldName != cleanName) {
      for (var s in _students) {
        if (s.className == oldName) {
          s.className = cleanName;
        }
      }
    }

    notifyListeners();
    return null;
  }

  /// Hapus Kelas (Delete)
  String? deleteClass(String id) {
    final idx = _classes.indexWhere((c) => c.id == id);
    if (idx == -1) return 'Kelas tidak ditemukan.';

    final className = _classes[idx].name;
    final studentCount = studentCountForClass(className);

    if (studentCount > 0) {
      return 'Kelas "$className" tidak dapat dihapus karena masih memiliki $studentCount siswa terdaftar. Pindahkan siswa terlebih dahulu.';
    }

    _classes.removeAt(idx);
    notifyListeners();
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CRUD SISWA
  // ═══════════════════════════════════════════════════════════════════════════

  /// Tambah Siswa Baru (Create)
  String? addStudent({
    required String nis,
    String? nisn,
    required String name,
    required String gender,
    required String className,
    String status = 'Aktif',
    String? phone,
    String? parentName,
  }) {
    final cleanNis = nis.trim();
    final cleanName = name.trim();

    if (cleanNis.isEmpty) return 'NIS siswa wajib diisi.';
    if (cleanName.isEmpty) return 'Nama lengkap siswa wajib diisi.';

    final exists = _students.any(
      (s) => s.nis.toLowerCase() == cleanNis.toLowerCase(),
    );
    if (exists) return 'NIS "$cleanNis" sudah digunakan oleh siswa lain.';

    final newStudent = StudentModel(
      id: 'STD-${(_students.length + 1).toString().padLeft(3, '0')}',
      nis: cleanNis,
      nisn: nisn?.trim().isEmpty ?? true ? null : nisn!.trim(),
      name: cleanName,
      gender: gender.trim(),
      className: className.trim(),
      status: status.trim(),
      phone: phone?.trim(),
      parentName: parentName?.trim(),
    );

    _students.add(newStudent);
    notifyListeners();
    return null;
  }

  /// Perbarui Data Siswa (Update)
  String? updateStudent({
    required String id,
    required String nis,
    String? nisn,
    required String name,
    required String gender,
    required String className,
    required String status,
    String? phone,
    String? parentName,
  }) {
    final idx = _students.indexWhere((s) => s.id == id);
    if (idx == -1) return 'Data siswa tidak ditemukan.';

    final cleanNis = nis.trim();
    final cleanName = name.trim();

    if (cleanNis.isEmpty) return 'NIS tidak boleh kosong.';
    if (cleanName.isEmpty) return 'Nama siswa tidak boleh kosong.';

    final duplicate = _students.any(
      (s) => s.id != id && s.nis.toLowerCase() == cleanNis.toLowerCase(),
    );
    if (duplicate) return 'NIS "$cleanNis" sudah terpakai.';

    _students[idx].nis = cleanNis;
    _students[idx].nisn = nisn?.trim().isEmpty ?? true ? null : nisn!.trim();
    _students[idx].name = cleanName;
    _students[idx].gender = gender.trim();
    _students[idx].className = className.trim();
    _students[idx].status = status.trim();
    _students[idx].phone = phone?.trim();
    _students[idx].parentName = parentName?.trim();

    notifyListeners();
    return null;
  }

  /// Hapus Data Siswa (Delete)
  String? deleteStudent(String id) {
    final idx = _students.indexWhere((s) => s.id == id);
    if (idx == -1) return 'Data siswa tidak ditemukan.';

    _students.removeAt(idx);
    notifyListeners();
    return null;
  }
}
