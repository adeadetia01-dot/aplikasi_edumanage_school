import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

// Shared demo data – exported so teacher_scores & raw_grades can reuse
final List<Map<String, dynamic>> demoAssessments = [
  {'name': 'Tugas 1: Ringkasan Bab 1',          'cat': 'TUGAS', 'date': '12 Okt', 'filled': 31},
  {'name': 'Tugas 2: Proposal Karya Ilmiah',    'cat': 'TUGAS', 'date': '20 Okt', 'filled': 4},
  {'name': 'UH 1: Teks Eksplanasi',             'cat': 'UH',    'date': '24 Okt', 'filled': 30},
  {'name': 'UTS Semester Ganjil',               'cat': 'UTS',   'date': '28 Okt', 'filled': 34},
  {'name': 'UAS Semester Ganjil',               'cat': 'UAS',   'date': '15 Des', 'filled': 0},
];

class TeacherAssessmentsScreen extends StatefulWidget {
  const TeacherAssessmentsScreen({super.key});
  @override
  State<TeacherAssessmentsScreen> createState() => _TeacherAssessmentsScreenState();
}

class _TeacherAssessmentsScreenState extends State<TeacherAssessmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Kelola Penugasan', subtitle: 'GURU MAPEL', context: context),
      bottomNavigationBar: _TeacherBottomNav(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MiniLabel('KELAS • MATA PELAJARAN'),
                SizedBox(height: 7),
                Text('XI-MIPA 2 • Bahasa Indonesia',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                SizedBox(height: 3),
                Text('Semester Ganjil 2026/2027',
                    style: TextStyle(fontSize: 11, color: kMuted)),
              ],
            ),
          ),
          SectionHeader('Daftar Penugasan', right: '${demoAssessments.length} item'),
          ...demoAssessments.asMap().entries.map((e) {
            final a = e.value;
            final idx = e.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/teacher/scores',
                    arguments: {'assessmentIndex': idx}),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8EEEE)),
                  ),
                  child: Row(
                    children: [
                      InitialsAvatar(
                        _catInitial(a['cat']),
                        bg: _catColor(a['cat']),
                        fg: kWhite,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a['name'],
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text('${a['cat']} • ${a['date']} • ${a['filled']}/34 terisi',
                                style: const TextStyle(fontSize: 10, color: kMuted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF8C9697), size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
          AppButton('＋ Tambah Penugasan', fullWidth: true,
              onTap: () => Navigator.pushNamed(context, '/teacher/new-assessment')),
          const SizedBox(height: 11),
          AppButton('Lihat Rekap Nilai Mentah', fullWidth: true, style: AppButtonStyle.outline,
              onTap: () => Navigator.pushNamed(context, '/teacher/raw-grades')),
        ],
      ),
    );
  }

  String _catInitial(String cat) => switch (cat) {
        'TUGAS' => 'T', 'UH' => 'U', 'UTS' => 'S', _ => 'A',
      };

  Color _catColor(String cat) => switch (cat) {
        'TUGAS' => kGreen, 'UH' => kBlue, 'UTS' => kAmber, _ => kRed,
      };
}

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
