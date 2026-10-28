import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/academic_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_widgets.dart';

class AdminClassesScreen extends StatefulWidget {
  const AdminClassesScreen({super.key});

  @override
  State<AdminClassesScreen> createState() => _AdminClassesScreenState();
}

class _AdminClassesScreenState extends State<AdminClassesScreen> {
  String _filterGrade = 'Semua';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AcademicService.instance,
      builder: (context, _) {
        final allClasses = AcademicService.instance.classes;
        final filtered = allClasses.where((c) {
          if (_filterGrade == 'Semua') return true;
          return c.gradeLevel == _filterGrade;
        }).toList();

        final totalEnrolled = AcademicService.instance.students.length;
        final totalCapacity = allClasses.fold<int>(
          0,
          (sum, c) => sum + c.capacity,
        );

        return Scaffold(
          backgroundColor: kBg,
          appBar: eduAppBar(
            title: 'Kelola Data Kelas',
            subtitle: 'ADMINISTRATOR',
            context: context,
          ),
          bottomNavigationBar: const _AdminBottomNav(currentIndex: 2),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Semester Aktif
              EduCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MiniLabel('SEMESTER AKTIF'),
                        SizedBox(height: 3),
                        Text(
                          'Tahun Ajaran 2026/2027',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: kInk,
                          ),
                        ),
                      ],
                    ),
                    StatusChip('Semester Ganjil', color: ChipColor.green),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Ringkasan Statistik Kelas
              Row(
                children: [
                  Expanded(
                    child: _statMiniCard('Total Kelas', '${allClasses.length}'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statMiniCard(
                        'Siswa Terdaftar', '$totalEnrolled'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statMiniCard('Kapasitas', '$totalCapacity'),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Filter Tingkat Kelas
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('Semua'),
                    _filterChip('X'),
                    _filterChip('XI'),
                    _filterChip('XII'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              SectionHeader(
                'Daftar Rombongan Belajar',
                right: '${filtered.length} dari ${allClasses.length} kelas',
              ),
              const SizedBox(height: 6),

              if (filtered.isEmpty)
                const EmptyState(
                  title: 'Kelas tidak ditemukan',
                  message: 'Belum ada kelas untuk tingkat yang dipilih.',
                ),

              // Daftar Kartu Kelas
              ...filtered.map((cls) => _buildClassCard(context, cls)),

              const SizedBox(height: 12),
              AppButton(
                '＋ Tambah Kelas Baru',
                fullWidth: true,
                onTap: () => _showClassForm(context),
              ),
              const SizedBox(height: 12),
              const InfoNotice(
                'Penetapan wali kelas dan alokasi ruang kelas dikelola langsung oleh Administrator.',
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _statMiniCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8EDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 10, color: kMuted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: kInk),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _filterGrade == label;
    final display = label == 'Semua' ? 'Semua Tingkat' : 'Tingkat $label';
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(display),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) setState(() => _filterGrade = label);
        },
        selectedColor: kInk,
        backgroundColor: kWhite,
        labelStyle: TextStyle(
          fontSize: 11,
          color: isSelected ? kWhite : kInk,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassModel cls) {
    final studentCount =
        AcademicService.instance.studentCountForClass(cls.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                alignment: Alignment.center,
                child: Text(
                  cls.gradeLevel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cls.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: kInk,
                            ),
                          ),
                        ),
                        StatusChip(
                          '$studentCount/${cls.capacity} Siswa',
                          color: studentCount >= cls.capacity
                              ? ChipColor.amber
                              : ChipColor.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Jurusan ${cls.major} • ${cls.room}',
                      style: const TextStyle(fontSize: 11.5, color: kMuted),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            size: 13, color: kMuted),
                        const SizedBox(width: 4),
                        Text(
                          cls.homeroomTeacher != null &&
                                  cls.homeroomTeacher!.isNotEmpty
                              ? 'Wali: ${cls.homeroomTeacher}'
                              : 'Wali Kelas: Belum Ditetapkan',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: cls.homeroomTeacher != null
                                ? const Color(0xFF0C5A3E)
                                : kMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 6),

          // Action buttons: Lihat Siswa, Edit Kelas, Hapus
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, '/admin/students'),
                icon: const Icon(Icons.group_outlined,
                    size: 14, color: Color(0xFF275AD0)),
                label: const Text(
                  'Lihat Siswa',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF275AD0),
                      fontWeight: FontWeight.w600),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => _showClassForm(context, classModel: cls),
                icon: const Icon(Icons.edit_outlined,
                    size: 14, color: kGreen),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 11,
                      color: kGreen,
                      fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 17, color: Color(0xFFC53030)),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                onPressed: () => _confirmDeleteClass(context, cls),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet Tambah / Edit Kelas ───────────────────────────────────────
  void _showClassForm(BuildContext context, {ClassModel? classModel}) {
    final isEdit = classModel != null;
    final nameCtrl = TextEditingController(text: classModel?.name ?? '');
    final capacityCtrl = TextEditingController(
      text: (classModel?.capacity ?? 36).toString(),
    );
    final roomCtrl =
        TextEditingController(text: classModel?.room ?? 'Ruang 101');

    String gradeLevel = classModel?.gradeLevel ?? 'X';
    String major = classModel?.major ?? 'MIPA';

    final teachers = AuthService.instance.teachers;
    String? selectedTeacher = classModel?.homeroomTeacher ??
        (teachers.isNotEmpty ? teachers.first.name : null);

    String? formError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Edit Data Kelas' : 'Tambah Kelas Baru',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kInk,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (formError != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        formError!,
                        style: const TextStyle(
                            fontSize: 11.5, color: Color(0xFFC53030)),
                      ),
                    ),

                  // Nama Kelas
                  const Text(
                    'NAMA KELAS *',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: X-MIPA 3 / XI-IPS 1',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tingkat & Jurusan
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TINGKAT KELAS',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: gradeLevel,
                              items: const [
                                DropdownMenuItem(value: 'X', child: Text('X')),
                                DropdownMenuItem(
                                    value: 'XI', child: Text('XI')),
                                DropdownMenuItem(
                                    value: 'XII', child: Text('XII')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => gradeLevel = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'JURUSAN / PEMINATAN',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: major,
                              items: const [
                                DropdownMenuItem(
                                    value: 'MIPA', child: Text('MIPA')),
                                DropdownMenuItem(
                                    value: 'IPS', child: Text('IPS')),
                                DropdownMenuItem(
                                    value: 'Bahasa', child: Text('Bahasa')),
                                DropdownMenuItem(
                                    value: 'Umum', child: Text('Umum')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => major = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Kapasitas & Ruangan
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'KAPASITAS MAKSIMAL',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: capacityCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '36',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RUANG KELAS',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: roomCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Ruang 103',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Wali Kelas
                  const Text(
                    'WALI KELAS',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String?>(
                    initialValue: selectedTeacher,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Belum Ditugaskan'),
                      ),
                      ...teachers.map(
                        (t) => DropdownMenuItem<String?>(
                          value: t.name,
                          child: Text(t.name),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setModalState(() => selectedTeacher = val);
                    },
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final capacity =
                            int.tryParse(capacityCtrl.text.trim()) ?? 36;

                        if (isEdit) {
                          final err = AcademicService.instance.updateClass(
                            id: classModel.id,
                            name: nameCtrl.text,
                            gradeLevel: gradeLevel,
                            major: major,
                            capacity: capacity,
                            room: roomCtrl.text,
                            homeroomTeacher: selectedTeacher,
                          );

                          if (err != null) {
                            setModalState(() => formError = err);
                          } else {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Kelas ${nameCtrl.text.trim()} berhasil diperbarui.'),
                              ),
                            );
                          }
                        } else {
                          final err = AcademicService.instance.addClass(
                            name: nameCtrl.text,
                            gradeLevel: gradeLevel,
                            major: major,
                            capacity: capacity,
                            room: roomCtrl.text,
                            homeroomTeacher: selectedTeacher,
                          );

                          if (err != null) {
                            setModalState(() => formError = err);
                          } else {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Kelas ${nameCtrl.text.trim()} berhasil ditambahkan.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                          isEdit ? 'Simpan Perubahan Kelas' : 'Tambah Kelas Baru'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Konfirmasi Hapus Kelas ──────────────────────────────────────────────────
  void _confirmDeleteClass(BuildContext context, ClassModel cls) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Hapus Data Kelas?',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus kelas ${cls.name}? Kelas hanya bisa dihapus jika tidak ada siswa yang terdaftar di dalamnya.',
          style: const TextStyle(fontSize: 12.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC53030),
            ),
            onPressed: () {
              final err = AcademicService.instance.deleteClass(cls.id);
              Navigator.pop(ctx);
              if (err != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Kelas ${cls.name} berhasil dihapus.'),
                  ),
                );
              }
            },
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }
}

class _AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  const _AdminBottomNav({required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => Navigator.pushNamed(context, const [
        '/admin/dashboard',
        '/admin/teachers',
        '/admin/classes',
        '/admin/schedules',
      ][i]),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined), label: 'Akun Guru'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Kelas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
      ],
    );
  }
}
