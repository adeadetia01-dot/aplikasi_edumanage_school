import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_widgets.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final isTeacher = user?.isTeacher ?? true;
    final isHomeroom = user?.isHomeroom ?? false;
    final userName = user?.name ?? 'Guru EduManage';
    final userUniqueNumber = user?.uniqueNumber ?? '-';
    final userSubject = user?.subject ?? '-';

    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(
        title: 'Pilih Peran Aktif',
        subtitle: 'AUTENTIKASI',
        context: context,
        showBack: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EduCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFD9F4E6),
                  child: Text(
                    userName.split(' ').take(2).map((w) => w.isNotEmpty ? w[0] : '').join(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: kGreen,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MiniLabel('AKUN GURU AKTIF'),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: kInk,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Nomor Unik: $userUniqueNumber • Mapel: $userSubject',
                        style: const TextStyle(fontSize: 12, color: kMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SectionHeader('Pilih peran untuk melanjutkan'),
          const SizedBox(height: 6),

          if (isTeacher) ...[
            ListItemRow(
              avatar: 'G',
              avatarBg: const Color(0xFFE4ECFF),
              title: 'Guru Mata Pelajaran',
              subtitle: 'Jadwal, presensi, penugasan, dan input nilai',
              onTap: () => Navigator.pushReplacementNamed(context, '/teacher/schedule'),
            ),
            const SizedBox(height: 11),
            if (isHomeroom)
              ListItemRow(
                avatar: 'W',
                avatarBg: const Color(0xFFFFF0DC),
                title: 'Wali Kelas ${user?.homeroomClass ?? ''}',
                subtitle: 'Monitoring presensi & rekap nilai kelas binaan',
                onTap: () => Navigator.pushReplacementNamed(context, '/homeroom/dashboard'),
              ),
            if (!isHomeroom)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.lock_outline, size: 16, color: kMuted),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Peran Wali Kelas belum diberikan oleh Admin Sekolah pada akun Anda.',
                        style: TextStyle(fontSize: 11, color: kMuted),
                      ),
                    ),
                  ],
                ),
              ),
          ],

          if (user?.isAdmin ?? false) ...[
            ListItemRow(
              avatar: 'A',
              avatarBg: const Color(0xFFD9F4E6),
              title: 'Admin Sekolah',
              subtitle: 'Kelola data guru, siswa, kelas & jadwal',
              onTap: () => Navigator.pushReplacementNamed(context, '/admin/dashboard'),
            ),
          ],

          const SizedBox(height: 20),
          // Tombol Keluar / Ganti Akun
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC53030),
              side: const BorderSide(color: Color(0xFFFEB2B2)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              AuthService.instance.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Keluar / Ganti Akun'),
          ),
          const SizedBox(height: 14),
          const InfoNotice(
            'Pengaturan hak akses, penetapan wali kelas, dan akun guru sepenuhnya dikelola oleh Admin Sekolah.',
          ),
        ],
      ),
    );
  }
}
