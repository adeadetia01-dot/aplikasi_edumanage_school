import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_widgets.dart';

class AdminTeachersScreen extends StatefulWidget {
  const AdminTeachersScreen({super.key});
  @override
  State<AdminTeachersScreen> createState() => _AdminTeachersScreenState();
}

class _AdminTeachersScreenState extends State<AdminTeachersScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final allTeachers = AuthService.instance.teachers;
        final filtered = allTeachers.where((t) {
          final query = _search.toLowerCase();
          return t.name.toLowerCase().contains(query) ||
              t.uniqueNumber.toLowerCase().contains(query) ||
              t.subject.toLowerCase().contains(query);
        }).toList();

        final activeCount = allTeachers.where((t) => t.isActive).length;
        final homeroomCount = allTeachers.where((t) => t.isHomeroom).length;

        return Scaffold(
          backgroundColor: kBg,
          appBar: eduAppBar(
            title: 'Kelola Akun Guru',
            subtitle: 'MANAJEMEN PENGGUNA',
            context: context,
          ),
          bottomNavigationBar: _AdminBottomNav(currentIndex: 1),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info Banner Hak Akses Admin
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF7F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCCE8DD)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.verified_user_outlined, size: 20, color: kGreen),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Admin mengelola seluruh akun pengguna. Akun guru dibuatkan oleh admin di sini, lalu guru cukup login menggunakan Nomor Unik & Kata Sandi.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF0C5A3E),
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Statistik Ringkas Guru
              Row(
                children: [
                  Expanded(
                    child: _statMiniCard('Total Guru', '${allTeachers.length}'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statMiniCard('Akun Aktif', '$activeCount'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statMiniCard('Wali Kelas', '$homeroomCount'),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Search Field
              SearchField(
                hint: 'Cari nama, nomor unik, atau mapel...',
                onChanged: (v) => setState(() => _search = v),
              ),
              SectionHeader(
                'Daftar Akun Guru',
                right: '${filtered.length} dari ${allTeachers.length} guru',
              ),
              const SizedBox(height: 6),

              if (filtered.isEmpty)
                const EmptyState(
                  title: 'Guru tidak ditemukan',
                  message: 'Tidak ada guru yang cocok dengan pencarian.',
                ),

              // List of Teacher Cards
              ...filtered.map((teacher) => _buildTeacherCard(context, teacher)),

              const SizedBox(height: 12),
              AppButton(
                '＋ Buat Akun Guru Baru',
                fullWidth: true,
                onTap: () => _showCreateTeacherDialog(context),
              ),
              const SizedBox(height: 24),
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
            style: const TextStyle(fontSize: 10, color: kMuted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: kInk),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context, UserModel teacher) {
    final initials = teacher.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join();

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: teacher.isActive
              ? const Color(0xFFE8EDED)
              : const Color(0xFFFFD5D5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: teacher.isActive
                    ? const Color(0xFFE4ECFF)
                    : const Color(0xFFF1F5F9),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: teacher.isActive
                        ? const Color(0xFF275AD0)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            teacher.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                              color: kInk,
                            ),
                          ),
                        ),
                        StatusChip(
                          teacher.isActive ? 'Aktif' : 'Nonaktif',
                          color: teacher.isActive
                              ? ChipColor.green
                              : ChipColor.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.badge_outlined, size: 13, color: kMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Nomor Unik: ${teacher.uniqueNumber}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Mapel: ${teacher.subject}',
                      style: const TextStyle(fontSize: 11, color: kMuted),
                    ),
                    if (teacher.isHomeroom) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0DC),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Wali Kelas: ${teacher.homeroomClass ?? '-'}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9F5B09),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          // Action Buttons: Lihat Kredensial, Reset Sandi, Ubah Status, Hapus
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Lihat Kredensial (Nomor Unik & Password)
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => _showCredentialsDialog(context, teacher),
                icon: const Icon(Icons.key, size: 14, color: kGreen),
                label: const Text(
                  'Kredensial',
                  style: TextStyle(fontSize: 11, color: kGreen, fontWeight: FontWeight.w600),
                ),
              ),
              // Reset Password
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => _showResetPasswordDialog(context, teacher),
                icon: const Icon(Icons.lock_reset, size: 14, color: Color(0xFF275AD0)),
                label: const Text(
                  'Reset Sandi',
                  style: TextStyle(fontSize: 11, color: Color(0xFF275AD0), fontWeight: FontWeight.w600),
                ),
              ),
              // More Menu (Status / Hapus)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18, color: kMuted),
                padding: EdgeInsets.zero,
                onSelected: (action) {
                  if (action == 'toggle') {
                    AuthService.instance.toggleTeacherStatus(teacher.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          teacher.isActive
                              ? 'Akun guru ${teacher.name} dinonaktifkan.'
                              : 'Akun guru ${teacher.name} diaktifkan kembali.',
                        ),
                      ),
                    );
                  } else if (action == 'delete') {
                    _confirmDeleteTeacher(context, teacher);
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          teacher.isActive ? Icons.block : Icons.check_circle_outline,
                          size: 16,
                          color: teacher.isActive ? Colors.orange : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          teacher.isActive ? 'Nonaktifkan Akun' : 'Aktifkan Akun',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus Akun', style: TextStyle(fontSize: 12, color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Dialog Buat Akun Guru Baru ─────────────────────────────────────────────
  void _showCreateTeacherDialog(BuildContext context) {
    final uniqueNumberCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final subjectCtrl = TextEditingController(text: 'Bahasa Indonesia');
    final passwordCtrl = TextEditingController(text: 'guru123');
    bool isHomeroom = false;
    String selectedClass = 'X-MIPA 1';
    String? dialogError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
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
                        const Text(
                          'Buatkan Akun Guru Baru',
                          style: TextStyle(
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
                    const Text(
                      'Admin mendaftarkan Nomor Unik dan Password agar guru bisa langsung login.',
                      style: TextStyle(fontSize: 12, color: kMuted),
                    ),
                    const SizedBox(height: 16),

                    if (dialogError != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dialogError!,
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFFC53030)),
                        ),
                      ),

                    // Nomor Unik Guru
                    const Text(
                      'NOMOR UNIK GURU (NIP / NUPTK) *',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: uniqueNumberCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: 19930815 atau NUPTK unik',
                        prefixIcon: Icon(Icons.badge_outlined, size: 18),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nama Guru
                    const Text(
                      'NAMA LENGKAP & GELAR *',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Ahmad Fauzi, M.Pd.',
                        prefixIcon: Icon(Icons.person_outline, size: 18),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Mapel
                    const Text(
                      'MATA PELAJARAN *',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: subjectCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Fisika, Matematika, Biologi',
                        prefixIcon: Icon(Icons.book_outlined, size: 18),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password Akun Guru
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'KATA SANDI AKUN GURU *',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                        ),
                        GestureDetector(
                          onTap: () {
                            final autoPass = 'guru${DateTime.now().millisecond}';
                            setModalState(() => passwordCtrl.text = autoPass);
                          },
                          child: const Text(
                            'Acak Sandi',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: kGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: passwordCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Minimal 4 karakter',
                        prefixIcon: Icon(Icons.lock_outline, size: 18),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Wali Kelas Switch
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Tugaskan sebagai Wali Kelas?',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kInk),
                      ),
                      subtitle: const Text(
                        'Memberikan hak akses dashboard wali kelas & kelas binaan',
                        style: TextStyle(fontSize: 11, color: kMuted),
                      ),
                      value: isHomeroom,
                      onChanged: (val) => setModalState(() => isHomeroom = val),
                    ),

                    if (isHomeroom) ...[
                      const Text(
                        'PILIH KELAS BINAAN',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        initialValue: selectedClass,
                        items: const [
                          DropdownMenuItem(value: 'X-MIPA 1', child: Text('X-MIPA 1')),
                          DropdownMenuItem(value: 'X-MIPA 2', child: Text('X-MIPA 2')),
                          DropdownMenuItem(value: 'XI-MIPA 1', child: Text('XI-MIPA 1')),
                          DropdownMenuItem(value: 'XI-MIPA 2', child: Text('XI-MIPA 2')),
                          DropdownMenuItem(value: 'XII-MIPA 1', child: Text('XII-MIPA 1')),
                        ],
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedClass = val);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final err = AuthService.instance.createTeacherAccount(
                            uniqueNumber: uniqueNumberCtrl.text,
                            name: nameCtrl.text,
                            password: passwordCtrl.text,
                            subject: subjectCtrl.text,
                            isHomeroom: isHomeroom,
                            homeroomClass: isHomeroom ? selectedClass : null,
                          );

                          if (err != null) {
                            setModalState(() => dialogError = err);
                          } else {
                            Navigator.pop(ctx);
                            _showCreatedSuccessDialog(
                              context,
                              uniqueNumber: uniqueNumberCtrl.text.trim(),
                              name: nameCtrl.text.trim(),
                              password: passwordCtrl.text.trim(),
                            );
                          }
                        },
                        child: const Text('Buat Akun Guru Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Dialog Sukses Pembuatan Akun ───────────────────────────────────────────
  void _showCreatedSuccessDialog(
    BuildContext context, {
    required String uniqueNumber,
    required String name,
    required String password,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: kGreen, size: 24),
            SizedBox(width: 8),
            Text('Akun Guru Berhasil Dibuat', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Akun untuk $name telah berhasil didaftarkan oleh Admin. Berikan data berikut kepada guru:',
              style: const TextStyle(fontSize: 12, color: kMuted),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NOMOR UNIK GURU (NIP / NUPTK)',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: kMuted)),
                  const SizedBox(height: 2),
                  SelectableText(
                    uniqueNumber,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kInk),
                  ),
                  const SizedBox(height: 10),
                  const Text('KATA SANDI LOGIN',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: kMuted)),
                  const SizedBox(height: 2),
                  SelectableText(
                    password,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF275AD0)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.info_outline, size: 14, color: kGreen),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Guru hanya perlu memasukkan Nomor Unik Guru & Kata Sandi di layar login aplikasi.',
                    style: TextStyle(fontSize: 11, color: kGreen, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Salin Kredensial'),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: 'Akun EduManage School:\nNama: $name\nNomor Unik: $uniqueNumber\nKata Sandi: $password',
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kredensial disalin ke clipboard!')),
              );
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  // ── Dialog Lihat Kredensial Guru ───────────────────────────────────────────
  void _showCredentialsDialog(BuildContext context, UserModel teacher) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kredensial Akun Guru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Guru: ${teacher.name}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NOMOR UNIK GURU',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: kMuted)),
                  SelectableText(
                    teacher.uniqueNumber,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kInk),
                  ),
                  const SizedBox(height: 10),
                  const Text('KATA SANDI SAAT INI',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: kMuted)),
                  SelectableText(
                    teacher.password,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF275AD0)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Salin'),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: 'Nomor Unik: ${teacher.uniqueNumber}\nKata Sandi: ${teacher.password}',
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kredensial akun disalin!')),
              );
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // ── Dialog Reset Password ──────────────────────────────────────────────────
  void _showResetPasswordDialog(BuildContext context, UserModel teacher) {
    final passCtrl = TextEditingController(text: 'guru123');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Kata Sandi Guru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset sandi untuk ${teacher.name} (${teacher.uniqueNumber}):',
                style: const TextStyle(fontSize: 12, color: kMuted)),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi Baru',
                prefixIcon: Icon(Icons.lock_reset, size: 18),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final err = AuthService.instance.resetTeacherPassword(
                id: teacher.id,
                newPassword: passCtrl.text,
              );
              Navigator.pop(ctx);
              if (err != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kata sandi untuk ${teacher.name} berhasil diubah!')),
                );
              }
            },
            child: const Text('Simpan Sandi Baru'),
          ),
        ],
      ),
    );
  }

  // ── Konfirmasi Hapus Guru ───────────────────────────────────────────────────
  void _confirmDeleteTeacher(BuildContext context, UserModel teacher) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Akun Guru?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        content: Text(
          'Apakah Anda yakin ingin menghapus akun guru ${teacher.name} (${teacher.uniqueNumber})? Guru ini tidak akan bisa login lagi.',
          style: const TextStyle(fontSize: 12.5),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC53030)),
            onPressed: () {
              AuthService.instance.deleteTeacher(teacher.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Akun guru ${teacher.name} telah dihapus.')),
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
        '/admin/teachers',
        '/admin/classes',
        '/admin/schedules',
      ][i]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.badge_outlined), label: 'Akun Guru'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Kelas'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
      ],
    );
  }
}
