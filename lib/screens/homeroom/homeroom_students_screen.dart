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

class HomeroomStudentsScreen extends StatefulWidget {
  const HomeroomStudentsScreen({super.key});
  @override
  State<HomeroomStudentsScreen> createState() => _HomeroomStudentsScreenState();
}

class _HomeroomStudentsScreenState extends State<HomeroomStudentsScreen> {
  String _search = '';

  List<Map<String,dynamic>> get _filtered => _kStudents
      .where((s) => s['name'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          s['nis'].toString().contains(_search))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Daftar Siswa Binaan', subtitle: 'WALI KELAS', context: context),
      bottomNavigationBar: _HomeroomBottomNav(currentIndex: 1),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MiniLabel('KELAS XI-MIPA 2'),
                SizedBox(height: 7),
                Text('Daftar Siswa Binaan • 34 Siswa',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
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
          ..._filtered.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: ListItemRow(
                  avatar: s['id'].toString().padLeft(2, '0'),
                  title: s['name'].toString(),
                  subtitle: 'NIS ${s['nis']}',
                  onTap: () => Navigator.pushNamed(context, '/homeroom/notes'),
                ),
              )),
          const InfoNotice(
              'Klik siswa untuk membuat catatan. Rekap nilai dan presensi tetap dapat dibuka dari dashboard wali kelas.'),
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
