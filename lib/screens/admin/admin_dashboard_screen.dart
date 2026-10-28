import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/academic_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([AuthService.instance, AcademicService.instance]),
      builder: (context, _) {
        final teacherCount = AuthService.instance.teachers.length;
        final studentCount = AcademicService.instance.totalStudents;
        final classCount = AcademicService.instance.totalClasses;

        final school = AuthService.instance.currentSchool;
        final schoolName = school?.name ?? 'EduManage School';
        final schoolNpsn = school?.npsn ?? '20104567';
        final schoolCity = school?.city ?? 'Indonesia';
        final academicYear = school?.academicYear ?? '2026/2027 • Ganjil';

        return Scaffold(
          backgroundColor: kBg,
          appBar: eduAppBar(title: 'Dashboard Admin', subtitle: 'ADMIN', context: context),
          bottomNavigationBar: const _AdminBottomNav(currentIndex: 0),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              EduCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0B274C),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schoolName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                        color: kInk,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'NPSN: $schoolNpsn • $schoolCity',
                                      style: const TextStyle(fontSize: 11, color: kMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const StatusChip('Aktif', color: ChipColor.green),
                      ],
                    ),
                    const SizedBox(height: 9),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MiniLabel('TAHUN AJARAN'),
                        Text(
                          academicYear,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                            color: kInk,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SectionHeader('Ringkasan Sekolah'),
              GridView.count(
                crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.8,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/admin/teachers'),
                    child: StatCard(count: '$teacherCount', label: 'Guru & Akun (Kelola)'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/admin/students'),
                    child: StatCard(count: '$studentCount', label: 'Siswa (Kelola)'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/admin/classes'),
                    child: StatCard(count: '$classCount', label: 'Kelas (Kelola)'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/admin/subjects'),
                    child: const StatCard(count: '9', label: 'Mapel'),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              EduCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader('Presensi Hari Ini', right: 'Per sesi'),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                          Text('82%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: kGreen)),
                          Text('Sesi telah dipresensi', style: TextStyle(fontSize: 11, color: kMuted)),
                        ]),
                        const StatusChip('18/22 sesi', color: ChipColor.green),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const AppProgressBar(0.82),
                  ],
                ),
              ),
              const SectionHeader('Kelola Pengguna & Akademik'),
              ListItemRow(
                avatar: 'G', title: 'Kelola Akun Guru',
                subtitle: 'Admin membuatkan akun guru & reset password',
                onTap: () => Navigator.pushNamed(context, '/admin/teachers'),
              ),
              const SizedBox(height: 11),
              ListItemRow(
                avatar: 'S', title: 'Kelola Data Siswa',
                subtitle: 'Tambah, edit, dan alokasi kelas $studentCount siswa',
                onTap: () => Navigator.pushNamed(context, '/admin/students'),
              ),
              const SizedBox(height: 11),
              ListItemRow(
                avatar: 'K', title: 'Kelola Data Kelas',
                subtitle: 'Atur rombel, kapasitas, dan wali kelas ($classCount kelas)',
                onTap: () => Navigator.pushNamed(context, '/admin/classes'),
              ),
              const SizedBox(height: 11),
              ListItemRow(
                avatar: 'J', title: 'Jadwal Mengajar',
                subtitle: 'Atur jadwal kelas & guru',
                onTap: () => Navigator.pushNamed(context, '/admin/schedules'),
              ),
              const SizedBox(height: 11),
              ListItemRow(
                avatar: 'W', title: 'Wali Kelas',
                subtitle: 'Tentukan wali kelas per kelas',
                onTap: () => Navigator.pushNamed(context, '/admin/homeroom'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Admin Bottom Nav ──────────────────────────────────────────────────────────
class _AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  const _AdminBottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        const routes = [
          '/admin/dashboard', '/admin/teachers',
          '/admin/classes',   '/admin/schedules',
        ];
        Navigator.pushNamed(context, routes[i]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),  label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.badge_outlined), label: 'Akun Guru'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view),      label: 'Kelas'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
      ],
    );
  }
}
