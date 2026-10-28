import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

const _kStudents = [
  {'name': 'Ahmad',   'nis': '21084'},
  {'name': 'Bella',   'nis': '21085'},
  {'name': 'Dimas',   'nis': '21086'},
  {'name': 'Farhan',  'nis': '21087'},
];

class HomeroomGradesScreen extends StatelessWidget {
  const HomeroomGradesScreen({super.key});

  static const _subjects = [
    {'name': 'Bahasa Indonesia', 'filled': 31, 'total': 34},
    {'name': 'Matematika',       'filled': 34, 'total': 34},
    {'name': 'Fisika',           'filled': 26, 'total': 34},
    {'name': 'Kimia',            'filled': 18, 'total': 34},
  ];

  // Demo score table [tugas, uts, uas] per student index
  static const _scores = [
    [92, 85, null],
    [88, null, null],
    [70, 85, null],
    [null, null, null],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Rekap Nilai Lintas Mapel', subtitle: 'WALI KELAS', context: context),
      bottomNavigationBar: _HomeroomBottomNav(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MiniLabel('MONITORING NILAI MENTAH'),
                SizedBox(height: 7),
                Text('XI-MIPA 2 • Ganjil',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                SizedBox(height: 5),
                Text('Read-only untuk mapel yang bukan diampu wali kelas.',
                    style: TextStyle(fontSize: 11, color: kMuted)),
              ],
            ),
          ),
          const SectionHeader('Progres Input per Mapel'),
          ..._subjects.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: EduCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(s['name'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kInk)),
                          Text('${s['filled']} / ${s['total']}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kGreen)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppProgressBar((s['filled'] as int) / (s['total'] as int)),
                    ],
                  ),
                ),
              )),
          const SectionHeader('Contoh Data Nilai Mentah'),
          EduCard(
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                // Header
                TableRow(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: kLine)),
                  ),
                  children: ['Siswa', 'Tugas', 'UTS', 'UAS'].map((h) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                        child: Text(h, style: const TextStyle(fontSize: 10, color: kMuted)),
                      )).toList(),
                ),
                // Data rows
                ..._kStudents.asMap().entries.map((e) {
                  final scores = _scores[e.key];
                  return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: kLine)),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                        child: Text(e.value['name']!,
                            style: const TextStyle(fontSize: 11, color: kInk)),
                      ),
                      ...scores.map((v) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                            child: Text(v?.toString() ?? '—',
                                style: TextStyle(fontSize: 11,
                                    color: v != null ? kInk : kMuted)),
                          )),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 11),
          const InfoNotice(
              'Belum ada nilai akhir, predikat, atau KKM yang dihitung dalam MVP.'),
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
