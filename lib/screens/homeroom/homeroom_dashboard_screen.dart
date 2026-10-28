import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class HomeroomDashboardScreen extends StatelessWidget {
  const HomeroomDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Dashboard Wali Kelas', subtitle: 'WALI KELAS', context: context),
      bottomNavigationBar: _HomeroomBottomNav(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Kelas info card
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MiniLabel('KELAS BINAAN'),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('XI-MIPA 2',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kInk)),
                    StatusChip('2026/2027 • Ganjil', color: ChipColor.green),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Wali kelas: Dewi Lestari, S.Pd.',
                    style: TextStyle(fontSize: 11, color: kMuted)),
              ],
            ),
          ),
          const SizedBox(height: 11),

          // Stats grid
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            children: const [
              StatCard(count: '34', label: 'Siswa'),
              StatCard(count: '22', label: 'Sesi Minggu Ini'),
              StatCard(count: '18', label: 'Sesi Diisi'),
              StatCard(count: '4',  label: 'Belum Dipresensi'),
            ],
          ),
          const SizedBox(height: 11),

          // Progress card
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader('Kelengkapan Presensi Sesi'),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('18 dari 22 sesi selesai',
                        style: TextStyle(fontSize: 11, color: kMuted)),
                    Text('82%',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kGreen)),
                  ],
                ),
                const SizedBox(height: 8),
                const AppProgressBar(0.82),
              ],
            ),
          ),
          const SectionHeader('Monitoring Kelas'),
          ListItemRow(
            avatar: 'DS', title: 'Daftar Siswa',
            subtitle: 'Lihat 34 siswa terdaftar',
            onTap: () => Navigator.pushNamed(context, '/homeroom/students'),
          ),
          const SizedBox(height: 11),
          ListItemRow(
            avatar: 'RP', title: 'Rekap Presensi',
            subtitle: 'Pantau H/S/I/A per sesi',
            onTap: () => Navigator.pushNamed(context, '/homeroom/attendance'),
          ),
          const SizedBox(height: 11),
          ListItemRow(
            avatar: 'RN', title: 'Rekap Nilai Mentah',
            subtitle: 'Pantau kelengkapan input mapel',
            onTap: () => Navigator.pushNamed(context, '/homeroom/grades'),
          ),
          const SizedBox(height: 11),
          ListItemRow(
            avatar: 'CP', title: 'Catatan Pembinaan',
            subtitle: 'Catat perkembangan siswa',
            onTap: () => Navigator.pushNamed(context, '/homeroom/notes'),
          ),
        ],
      ),
    );
  }
}

class _HomeroomBottomNav extends StatelessWidget {
  final int currentIndex;
  const _HomeroomBottomNav({required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => Navigator.pushNamed(context, const [
        '/homeroom/dashboard', '/homeroom/students',
        '/homeroom/attendance', '/homeroom/grades',
      ][i]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),           label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined),          label: 'Siswa'),
        BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined),      label: 'Presensi'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined),      label: 'Nilai'),
      ],
    );
  }
}
