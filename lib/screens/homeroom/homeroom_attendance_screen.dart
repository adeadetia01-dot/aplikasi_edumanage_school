import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class HomeroomAttendanceScreen extends StatelessWidget {
  const HomeroomAttendanceScreen({super.key});

  static const _sessions = [
    {'time': '07:15–08:45', 'subject': 'B. Indonesia', 'progress': '36/36', 'done': true},
    {'time': '09:00–10:30', 'subject': 'Matematika',   'progress': '33/34', 'done': true},
    {'time': '11:00–12:30', 'subject': 'Fisika',       'progress': '0/34',  'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Rekap Presensi Kelas', subtitle: 'WALI KELAS', context: context),
      bottomNavigationBar: _HomeroomBottomNav(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MiniLabel('REKAP PRESENSI SESI • XI-MIPA 2'),
                SizedBox(height: 7),
                Text('20 Oktober 2026',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                SizedBox(height: 5),
                Text(
                  'Satu siswa dapat muncul beberapa kali pada hari yang sama bila mengikuti beberapa sesi.',
                  style: TextStyle(fontSize: 11, color: kMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),

          // Stats
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            children: const [
              StatCard(count: '72', label: 'Hadir (sesi)'),
              StatCard(count: '5',  label: 'Sakit (sesi)'),
              StatCard(count: '3',  label: 'Izin (sesi)'),
              StatCard(count: '2',  label: 'Alfa (sesi)'),
            ],
          ),
          const SectionHeader('Sesi Hari Ini'),

          ..._sessions.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: EduCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(s['subject'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kInk)),
                        const SizedBox(height: 2),
                        Text('${s['time']} • Presensi: ${s['progress']}',
                            style: const TextStyle(fontSize: 11, color: kMuted)),
                      ]),
                      StatusChip(
                        s['done'] == true ? 'Diisi' : 'Belum',
                        color: s['done'] == true ? ChipColor.green : ChipColor.amber,
                      ),
                    ],
                  ),
                ),
              )),
          const InfoNotice(
              'Jumlah status di halaman ini adalah jumlah catatan per sesi, bukan kehadiran dalam satuan hari.',
              warn: true),
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
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),      label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined),     label: 'Siswa'),
        BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined), label: 'Presensi'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Nilai'),
      ],
    );
  }
}
