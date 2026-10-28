import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class AdminSubjectsScreen extends StatelessWidget {
  const AdminSubjectsScreen({super.key});

  static const _subjects = [
    'Bahasa Indonesia', 'Matematika', 'Fisika',
    'Kimia', 'Biologi', 'Bahasa Inggris', 'Sejarah',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Mata Pelajaran', subtitle: 'ADMIN', context: context),
      bottomNavigationBar: _AdminBottomNav(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader('Mata Pelajaran Aktif', right: '9 mapel'),
          ..._subjects.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: ListItemRow(
                  avatar: '▤',
                  title: e.value,
                  subtitle: 'MAPEL-${(e.key + 1).toString().padLeft(3, '0')}',
                  onTap: () => Navigator.pushNamed(context, '/admin/schedules'),
                ),
              )),
          AppButton('＋ Tambah Mapel', fullWidth: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Master mata pelajaran: kode unik, nama, status'),
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
