import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

const _kStudents = [
  {'id': 1, 'name': 'Ahmad Fauzan',       'nis': '21084'},
  {'id': 2, 'name': 'Bella Safitri',      'nis': '21085'},
  {'id': 3, 'name': 'Dimas Arya Pratama', 'nis': '21086'},
  {'id': 4, 'name': 'Farhan Aditya',      'nis': '21087'},
  {'id': 5, 'name': 'Gita Maharani',      'nis': '21088'},
  {'id': 6, 'name': 'Annisa Rahmadani',   'nis': '21089'},
];

// Demo scores per student [tugas1, tugas2, uts, uas]
final Map<int, List<int?>> _demoGrades = {
  1: [92, 88,  86, null],
  2: [88, null,null,null],
  3: [70, 88,  null,null],
  4: [null,null,86,null],
  5: [95, 88,  null,null],
  6: [null,null,null,null],
};

class TeacherRawGradesScreen extends StatefulWidget {
  const TeacherRawGradesScreen({super.key});
  @override
  State<TeacherRawGradesScreen> createState() => _TeacherRawGradesScreenState();
}

class _TeacherRawGradesScreenState extends State<TeacherRawGradesScreen> {
  String _search = '';

  List<Map<String,dynamic>> get _filtered => _kStudents
      .where((s) => s['name'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          s['nis'].toString().contains(_search))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Rekap Nilai Mentah', subtitle: 'GURU MAPEL', context: context),
      bottomNavigationBar: _TeacherBottomNav(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MiniLabel('REKAP NILAI MENTAH'),
                SizedBox(height: 6),
                Text('XI-MIPA 2 • Bahasa Indonesia',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                SizedBox(height: 4),
                Text('Daftar tiap penilaian, belum dihitung jadi nilai akhir.',
                    style: TextStyle(fontSize: 11, color: kMuted)),
              ],
            ),
          ),
          const SizedBox(height: 11),
          SearchField(onChanged: (v) => setState(() => _search = v)),
          const SizedBox(height: 11),
          if (_filtered.isEmpty)
            const EmptyState(
              title: 'Siswa tidak ditemukan',
              message: 'Tidak ada siswa yang cocok dengan kata kunci pencarian.',
            ),
          ..._filtered.map((s) {
            final id = s['id'] as int;
            final grades = _demoGrades[id] ?? [null, null, null, null];
            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: EduCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s['name'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kInk)),
                          Text('NIS ${s['nis']}',
                              style: const TextStyle(fontSize: 10, color: kMuted)),
                        ]),
                        const StatusChip('Nilai mentah', color: ChipColor.green),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _GradeCell(label: 'Tugas 1', value: grades[0]),
                        const SizedBox(width: 5),
                        _GradeCell(label: 'Tugas 2', value: grades[1]),
                        const SizedBox(width: 5),
                        _GradeCell(label: 'UTS',     value: grades[2]),
                        const SizedBox(width: 5),
                        _GradeCell(label: 'UAS',     value: grades[3]),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          AppButton('Input Nilai Tugas →', fullWidth: true,
              onTap: () => Navigator.pushNamed(context, '/teacher/scores')),
          const SizedBox(height: 11),
          const InfoNotice(
              'ℹ️ Nilai rata-rata, bobot, predikat, remedial, dan KKM otomatis disiapkan untuk fase selanjutnya.'),
        ],
      ),
    );
  }
}

// ── Teacher Bottom Nav ────────────────────────────────────────────────────────
class _TeacherBottomNav extends StatelessWidget {
  final int currentIndex;
  const _TeacherBottomNav({required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => Navigator.pushNamed(context, const [
        '/teacher/schedule', '/teacher/attendance',
        '/teacher/assessments', '/role-select',
      ][i]),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),           label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined),      label: 'Presensi'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined),     label: 'Tugas'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Akun'),
      ],
    );
  }
}

class _GradeCell extends StatelessWidget {
  final String label;
  final int? value;
  const _GradeCell({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F5),
          borderRadius: BorderRadius.circular(7),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 9, color: kMuted)),
            const SizedBox(height: 6),
            Text(
              value?.toString() ?? '—',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: value == null ? kMuted : kInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
