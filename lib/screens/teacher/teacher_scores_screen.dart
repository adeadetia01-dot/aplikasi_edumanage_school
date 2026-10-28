import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';
import 'teacher_assessments_screen.dart' show demoAssessments;

const _kStudents = [
  {'id': 1, 'name': 'Ahmad Fauzan',       'nis': '21084'},
  {'id': 2, 'name': 'Bella Safitri',      'nis': '21085'},
  {'id': 3, 'name': 'Dimas Arya Pratama', 'nis': '21086'},
  {'id': 4, 'name': 'Farhan Aditya',      'nis': '21087'},
  {'id': 5, 'name': 'Gita Maharani',      'nis': '21088'},
  {'id': 6, 'name': 'Annisa Rahmadani',   'nis': '21089'},
];

class TeacherScoresScreen extends StatefulWidget {
  const TeacherScoresScreen({super.key});
  @override
  State<TeacherScoresScreen> createState() => _TeacherScoresScreenState();
}

class _TeacherScoresScreenState extends State<TeacherScoresScreen> {
  final Map<int, int?> _scores = {1: 92, 2: 88, 3: 70, 4: null, 5: 95, 6: null};
  String _search = '';
  int _assessmentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['assessmentIndex'] is int) {
      _assessmentIndex = args['assessmentIndex'] as int;
    }
  }

  int get _filledCount => _scores.values.where((v) => v != null).length;

  List<Map<String, dynamic>> get _filtered => _kStudents
      .where((s) => s['name'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          s['nis'].toString().contains(_search))
      .toList();

  @override
  Widget build(BuildContext context) {
    final assessment = demoAssessments[_assessmentIndex.clamp(0, demoAssessments.length - 1)];
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Input Nilai Siswa', subtitle: 'GURU MAPEL', context: context),
      bottomNavigationBar: _TeacherBottomNav(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MiniLabel('KELAS XI-MIPA 2 • BAHASA INDONESIA'),
                const SizedBox(height: 6),
                Text(assessment['name'],
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusChip(assessment['cat'], color: ChipColor.green),
                    Text('$_filledCount / 34 siswa terisi (contoh 6 siswa)',
                        style: const TextStyle(fontSize: 10, color: kMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          SearchField(onChanged: (v) => setState(() => _search = v)),
          const SectionHeader('Input Nilai Siswa', right: 'Skor 0–100'),
          if (_filtered.isEmpty)
            const EmptyState(
              title: 'Siswa tidak ditemukan',
              message: 'Tidak ada siswa yang cocok dengan kata kunci pencarian.',
            ),
          ..._filtered.map((s) {
            final id = s['id'] as int;
            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8EEEE)),
                ),
                child: Row(
                  children: [
                    InitialsAvatar(id.toString().padLeft(2, '0')),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          Text('NIS ${s['nis']}',
                              style: const TextStyle(fontSize: 10, color: kMuted)),
                        ],
                      ),
                    ),
                    ScoreInput(
                      value: _scores[id],
                      onChanged: (v) => setState(() => _scores[id] = v),
                    ),
                  ],
                ),
              ),
            );
          }),
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InfoNotice('Nilai yang kosong tidak disimpan sebagai 0. Batas 0–100 wajib divalidasi di backend.'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AppButton('Simpan Draf', style: AppButtonStyle.light,
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Draf nilai demo disimpan dalam memori')))),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: AppButton('Simpan Nilai',
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Implementasi memakai API upsert student_scores')))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          AppButton('Lihat Rekap Nilai Mentah →', fullWidth: true, style: AppButtonStyle.outline,
              onTap: () => Navigator.pushNamed(context, '/teacher/raw-grades')),
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
