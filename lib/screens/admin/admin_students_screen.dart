import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/academic_service.dart';
import '../../widgets/app_widgets.dart';

class AdminStudentsScreen extends StatefulWidget {
  const AdminStudentsScreen({super.key});
  @override
  State<AdminStudentsScreen> createState() => _AdminStudentsScreenState();
}

class _AdminStudentsScreenState extends State<AdminStudentsScreen> {
  String _search = '';
  String _filterClass = 'Semua';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AcademicService.instance,
      builder: (context, _) {
        final allStudents = AcademicService.instance.students;
        final allClasses = AcademicService.instance.classes;

        final filtered = allStudents.where((s) {
          final query = _search.toLowerCase();
          final matchesQuery = s.name.toLowerCase().contains(query) ||
              s.nis.contains(query) ||
              (s.nisn != null && s.nisn!.contains(query)) ||
              s.className.toLowerCase().contains(query);

          final matchesClass =
              _filterClass == 'Semua' || s.className == _filterClass;

          return matchesQuery && matchesClass;
        }).toList();

        final maleCount = allStudents.where((s) => s.gender == 'L').length;
        final femaleCount = allStudents.where((s) => s.gender == 'P').length;

        return Scaffold(
          backgroundColor: kBg,
          appBar: eduAppBar(
            title: 'Kelola Data Siswa',
            subtitle: 'ADMINISTRATOR',
            context: context,
          ),
          bottomNavigationBar: const _AdminBottomNav(currentIndex: 1),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Ringkasan Statistik Siswa
              Row(
                children: [
                  Expanded(
                    child: _statMiniCard('Total Siswa', '${allStudents.length}'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statMiniCard('Laki-laki', '$maleCount'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statMiniCard('Perempuan', '$femaleCount'),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search Field
              SearchField(
                hint: 'Cari nama siswa atau NIS...',
                onChanged: (v) => setState(() => _search = v),
              ),
              const SizedBox(height: 10),

              // Filter Kelas
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('Semua'),
                    ...allClasses.map((c) => _filterChip(c.name)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              SectionHeader(
                'Data Siswa Terdaftar',
                right: '${filtered.length} dari ${allStudents.length} siswa',
              ),
              const SizedBox(height: 6),

              if (filtered.isEmpty)
                const EmptyState(
                  title: 'Siswa tidak ditemukan',
                  message: 'Tidak ada siswa yang cocok dengan kata kunci pencarian.',
                ),

              // Daftar Kartu Siswa
              ...filtered.map((student) => _buildStudentCard(context, student)),

              const SizedBox(height: 12),
              AppButton(
                '＋ Tambah Siswa Baru',
                fullWidth: true,
                onTap: () => _showStudentForm(context),
              ),
              const SizedBox(height: 12),
              const InfoNotice(
                'Data siswa tersinkronisasi otomatis dengan kelas binaan dan presensi mengajar guru.',
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
    final isSelected = _filterClass == label;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) setState(() => _filterClass = label);
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

  Widget _buildStudentCard(BuildContext context, StudentModel student) {
    final initials = student.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join();

    final isMale = student.gender == 'L';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EDED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                isMale ? const Color(0xFFE0F2FE) : const Color(0xFFFCE7F3),
            child: Text(
              initials,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: isMale
                    ? const Color(0xFF0369A1)
                    : const Color(0xFFBE185D),
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
                        student.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: kInk,
                        ),
                      ),
                    ),
                    StatusChip(
                      student.status,
                      color: student.status == 'Aktif'
                          ? ChipColor.green
                          : ChipColor.gray,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'NIS ${student.nis} • Kelas ${student.className}',
                  style: const TextStyle(fontSize: 11.5, color: kMuted),
                ),
                if (student.nisn != null && student.nisn!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'NISN: ${student.nisn}',
                    style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: kMuted),
            padding: EdgeInsets.zero,
            onSelected: (action) {
              if (action == 'detail') {
                _showStudentDetail(context, student);
              } else if (action == 'edit') {
                _showStudentForm(context, student: student);
              } else if (action == 'delete') {
                _confirmDeleteStudent(context, student);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'detail',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Color(0xFF0284C7)),
                    SizedBox(width: 8),
                    Text('Detail Siswa', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 16, color: kGreen),
                    SizedBox(width: 8),
                    Text('Edit Data', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus', style: TextStyle(fontSize: 12, color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Dialog Detail Siswa ────────────────────────────────────────────────────
  void _showStudentDetail(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          student.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('NIS', student.nis),
            _detailRow('NISN', student.nisn ?? '-'),
            _detailRow('Jenis Kelamin',
                student.gender == 'L' ? 'Laki-laki' : 'Perempuan'),
            _detailRow('Kelas', student.className),
            _detailRow('Status', student.status),
            _detailRow('Nama Orang Tua', student.parentName ?? '-'),
            _detailRow('No. Telepon', student.phone ?? '-'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showStudentForm(context, student: student);
            },
            child: const Text('Edit Siswa'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11.5, color: kMuted),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 11.5, color: kMuted)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kInk,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet Tambah / Edit Siswa ───────────────────────────────────────
  void _showStudentForm(BuildContext context, {StudentModel? student}) {
    final isEdit = student != null;
    final nisCtrl = TextEditingController(text: student?.nis ?? '');
    final nisnCtrl = TextEditingController(text: student?.nisn ?? '');
    final nameCtrl = TextEditingController(text: student?.name ?? '');
    final phoneCtrl = TextEditingController(text: student?.phone ?? '');
    final parentCtrl = TextEditingController(text: student?.parentName ?? '');

    String gender = student?.gender ?? 'L';
    String status = student?.status ?? 'Aktif';

    final classes = AcademicService.instance.classes;
    String selectedClass = student?.className ??
        (classes.isNotEmpty ? classes.first.name : 'X-MIPA 1');

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
                        isEdit ? 'Edit Data Siswa' : 'Tambah Siswa Baru',
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

                  // NIS & NISN
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NIS *',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: nisCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Contoh: 21090',
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
                              'NISN (OPSIONAL)',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: nisnCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '10 digit',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama Lengkap
                  const Text(
                    'NAMA LENGKAP SISWA *',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Nama lengkap siswa sesuai akta/ijazah',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Jenis Kelamin & Kelas
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'JENIS KELAMIN',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: gender,
                              items: const [
                                DropdownMenuItem(
                                    value: 'L', child: Text('Laki-laki')),
                                DropdownMenuItem(
                                    value: 'P', child: Text('Perempuan')),
                              ],
                              onChanged: (val) {
                                if (val != null) setModalState(() => gender = val);
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
                              'KELAS *',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: classes.any((c) => c.name == selectedClass)
                                  ? selectedClass
                                  : (classes.isNotEmpty ? classes.first.name : null),
                              items: classes
                                  .map((c) => DropdownMenuItem(
                                        value: c.name,
                                        child: Text(c.name),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => selectedClass = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama Orang Tua & Status
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NAMA ORANG TUA / WALI',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: parentCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Orang tua siswa',
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
                              'STATUS SISWA',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: kMuted),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: status,
                              items: const [
                                DropdownMenuItem(
                                    value: 'Aktif', child: Text('Aktif')),
                                DropdownMenuItem(
                                    value: 'Pindah', child: Text('Pindah')),
                                DropdownMenuItem(
                                    value: 'Lulus', child: Text('Lulus')),
                                DropdownMenuItem(
                                    value: 'Nonaktif', child: Text('Nonaktif')),
                              ],
                              onChanged: (val) {
                                if (val != null) setModalState(() => status = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // No. Telepon
                  const Text(
                    'NO. TELEPON / WHATSAPP',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: 081234567890',
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isEdit) {
                          final err = AcademicService.instance.updateStudent(
                            id: student.id,
                            nis: nisCtrl.text,
                            nisn: nisnCtrl.text,
                            name: nameCtrl.text,
                            gender: gender,
                            className: selectedClass,
                            status: status,
                            phone: phoneCtrl.text,
                            parentName: parentCtrl.text,
                          );

                          if (err != null) {
                            setModalState(() => formError = err);
                          } else {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Data siswa ${nameCtrl.text.trim()} berhasil diperbarui.'),
                              ),
                            );
                          }
                        } else {
                          final err = AcademicService.instance.addStudent(
                            nis: nisCtrl.text,
                            nisn: nisnCtrl.text,
                            name: nameCtrl.text,
                            gender: gender,
                            className: selectedClass,
                            status: status,
                            phone: phoneCtrl.text,
                            parentName: parentCtrl.text,
                          );

                          if (err != null) {
                            setModalState(() => formError = err);
                          } else {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Siswa ${nameCtrl.text.trim()} berhasil ditambahkan ke kelas $selectedClass.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                          isEdit ? 'Simpan Perubahan Siswa' : 'Tambah Siswa Baru'),
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

  // ── Konfirmasi Hapus Siswa ──────────────────────────────────────────────────
  void _confirmDeleteStudent(BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Hapus Data Siswa?',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data siswa ${student.name} (NIS: ${student.nis}) dari kelas ${student.className}?',
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
              AcademicService.instance.deleteStudent(student.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Siswa ${student.name} berhasil dihapus.'),
                ),
              );
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
        '/admin/students',
        '/admin/classes',
        '/admin/schedules',
      ][i]),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined), label: 'Siswa'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Kelas'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
      ],
    );
  }
}
