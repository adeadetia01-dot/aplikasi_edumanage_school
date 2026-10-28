import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class AdminHomeroomScreen extends StatelessWidget {
  const AdminHomeroomScreen({super.key});

  static const _assignments = [
    {'class': 'X-MIPA 1',   'teacher': 'Budi Santoso'},
    {'class': 'X-MIPA 2',   'teacher': 'Belum ditetapkan'},
    {'class': 'XI-MIPA 1',  'teacher': 'Siti Rahma'},
    {'class': 'XI-MIPA 2',  'teacher': 'Dewi Lestari'},
    {'class': 'XII-MIPA 1', 'teacher': 'Andi Prakoso'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Kelola Wali Kelas', subtitle: 'ADMIN', context: context),
      bottomNavigationBar: _AdminBottomNav(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader('Semester Ganjil', right: '2026/2027'),
          ..._assignments.map((a) {
            final isEmpty = a['teacher']!.startsWith('Belum');
            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: EduCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(a['class']!,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kInk)),
                      const SizedBox(height: 2),
                      Text('Wali: ${a['teacher']}',
                          style: const TextStyle(fontSize: 11, color: kMuted)),
                    ]),
                    StatusChip(
                      isEmpty ? 'Belum Ada' : 'Aktif',
                      color: isEmpty ? ChipColor.amber : ChipColor.green,
                    ),
                  ],
                ),
              ),
            );
          }),
          AppButton('＋ Tetapkan Wali Kelas', fullWidth: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Backend menegakkan satu wali kelas per kelas per semester'),
            ))),
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
        '/admin/dashboard', '/admin/students',
        '/admin/classes',   '/admin/schedules',
      ][i]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),  label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Siswa'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view),      label: 'Kelas'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Jadwal'),
      ],
    );
  }
}
