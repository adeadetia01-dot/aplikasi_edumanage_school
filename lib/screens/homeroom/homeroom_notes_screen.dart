import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class HomeroomNotesScreen extends StatefulWidget {
  const HomeroomNotesScreen({super.key});
  @override
  State<HomeroomNotesScreen> createState() => _HomeroomNotesScreenState();
}

class _HomeroomNotesScreenState extends State<HomeroomNotesScreen> {
  final _noteCtrl = TextEditingController();
  final List<String> _notes = [
    '20 Okt 2026 — Perlu pendampingan pada tugas menulis.',
  ];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _addNote() {
    final text = _noteCtrl.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Catatan belum diisi')));
      return;
    }
    setState(() {
      _notes.insert(0, '20 Okt 2026 — $text');
      _noteCtrl.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan tersimpan pada demo')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Catatan Pembinaan', subtitle: 'WALI KELAS', context: context),
      bottomNavigationBar: _HomeroomBottomNav(currentIndex: 1),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Student header
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                MiniLabel('CATATAN WALI KELAS'),
                SizedBox(height: 7),
                Text('Dimas Arya Pratama',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                SizedBox(height: 3),
                Text('XI-MIPA 2 • NIS 21086',
                    style: TextStyle(fontSize: 11, color: kMuted)),
              ],
            ),
          ),
          SectionHeader('Riwayat Catatan', right: '${_notes.length} catatan'),

          // Notes list – wireframe renders every note as a plain card
          ..._notes.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: EduCard(
                  child: Text(n, style: const TextStyle(fontSize: 11, color: kInk, height: 1.6)),
                ),
              )),

          const SectionHeader('Tambah Catatan Baru'),
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CATATAN PEMBINAAN',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                        letterSpacing: 0.3, color: kMuted)),
                const SizedBox(height: 6),
                TextField(
                  controller: _noteCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan catatan perkembangan siswa ...',
                  ),
                ),
                const SizedBox(height: 11),
                const InfoNotice(
                    'Catatan pembinaan terpisah dari data presensi dan nilai. Hak akses berdasarkan kelas binaan.'),
                const SizedBox(height: 11),
                AppButton('＋ Simpan Catatan', fullWidth: true, onTap: _addNote),
              ],
            ),
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
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),      label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined),     label: 'Siswa'),
        BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined), label: 'Presensi'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Nilai'),
      ],
    );
  }
}
