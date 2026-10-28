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

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});
  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  // id -> 'H'|'S'|'I'|'A'|null
  final Map<int, String?> _attendance = {1: 'H', 2: 'S', 3: null, 4: 'I', 5: 'H', 6: 'H'};
  String _filter = 'Semua';
  String _search = '';

  Map<String, int> get _totals {
    final t = {'H': 0, 'S': 0, 'I': 0, 'A': 0, 'U': 0};
    for (final v in _attendance.values) {
      t[v ?? 'U'] = (t[v ?? 'U'] ?? 0) + 1;
    }
    return t;
  }

  int get _unfilledCount => _attendance.values.where((v) => v == null).length;
  int get _filledCount   => _attendance.values.where((v) => v != null).length;

  List<Map<String, dynamic>> get _filteredStudents {
    return _kStudents.where((s) {
      final matchSearch = s['name'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          s['nis'].toString().contains(_search);
      if (!matchSearch) return false;
      if (_filter == 'Semua') return true;
      if (_filter == 'Belum') return _attendance[s['id']] == null;
      return _attendance[s['id']] == _filter;
    }).toList();
  }

  void _markAll() {
    setState(() {
      for (final s in _kStudents) {
        _attendance[s['id'] as int] = 'H';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status semua siswa ditandai Hadir (demo)')));
  }

  void _resetAll() {
    setState(() {
      for (final s in _kStudents) {
        _attendance[s['id'] as int] = null;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status direset ke Belum Diabsen (demo)')));
  }

  void _setAttendance(int id, String status) {
    setState(() {
      _attendance[id] = (_attendance[id] == status) ? null : status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = _totals;
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Presensi Siswa', subtitle: 'GURU MAPEL', context: context),
      bottomNavigationBar: _TeacherBottomNav(currentIndex: 1),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary card
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MiniLabel('BAHASA INDONESIA'),
                    StatusChip('20 Okt 2026', color: ChipColor.green),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('XI-MIPA 2 • Jam ke-3 & 4',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: kInk)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Terisi (contoh 6 siswa)',
                        style: TextStyle(fontSize: 11, color: kMuted)),
                    Text('$_filledCount / 6',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kGreen)),
                  ],
                ),
                const SizedBox(height: 6),
                AppProgressBar(_filledCount / 6),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: AppButton('Tandai Semua Hadir', onTap: _markAll)),
                    const SizedBox(width: 7),
                    Expanded(child: AppButton('Reset', style: AppButtonStyle.light, onTap: _resetAll)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          SearchField(onChanged: (v) => setState(() => _search = v)),
          const SizedBox(height: 11),

          // Filter chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['Semua', 'Belum', 'H', 'S', 'I', 'A'].map((f) {
                final isOn = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                        color: isOn ? const Color(0xFF101313) : const Color(0xFFE9EDEE),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w800,
                              color: isOn ? kWhite : kMuted)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 11),

          // Student rows
          if (_filteredStudents.isEmpty)
            const EmptyState(
              title: 'Tidak ada siswa pada filter ini',
              message: 'Ubah filter status atau kata kunci pencarian untuk menampilkan siswa lain.',
            ),
          ..._filteredStudents.map((s) => Padding(
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
                      SizedBox(
                        width: 22,
                        child: Text(
                          s['id'].toString().padLeft(2, '0'),
                          style: const TextStyle(fontSize: 10, color: kMuted),
                        ),
                      ),
                      InitialsAvatar(
                        s['name'].toString().split(' ').take(2).map((w) => w[0]).join(),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['name'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                            Text('NIS ${s['nis']}',
                                style: const TextStyle(fontSize: 10, color: kMuted)),
                          ],
                        ),
                      ),
                      _AttendanceButtons(
                        selected: _attendance[s['id'] as int],
                        onTap: (status) => _setAttendance(s['id'] as int, status),
                      ),
                    ],
                  ),
                ),
              )),
          // Footer summary card
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  children: [
                    StatusChip('H: ${t['H']}', color: ChipColor.green),
                    StatusChip('S: ${t['S']}', color: ChipColor.amber),
                    StatusChip('I: ${t['I']}', color: ChipColor.blue),
                    StatusChip('A: ${t['A']}', color: ChipColor.red),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Belum diabsen: $_unfilledCount dari 6 sampel siswa (kelas penuh 34).',
                  style: const TextStyle(fontSize: 11, color: kMuted),
                ),
                const SizedBox(height: 10),
                AppButton(
                  'Simpan Presensi →', fullWidth: true,
                  onTap: () {
                    final msg = _unfilledCount > 0
                        ? 'Masih ada $_unfilledCount siswa belum diabsen.'
                        : 'Presensi demo tersimpan.';
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceButtons extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onTap;
  const _AttendanceButtons({this.selected, required this.onTap});

  Color _bg(String s) => switch (s) {
        'H' => const Color(0xFF067B55),
        'S' => const Color(0xFFFFAC24),
        'I' => const Color(0xFF5A83F6),
        'A' => const Color(0xFFE45B5B),
        _   => Colors.transparent,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['H', 'S', 'I', 'A'].map((s) {
          final isOn = selected == s;
          return GestureDetector(
            onTap: () => onTap(s),
            child: Container(
              width: 28, height: 29,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: isOn ? _bg(s) : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(s,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800,
                      color: isOn ? kWhite : const Color(0xFF536062))),
            ),
          );
        }).toList(),
      ),
    );
  }
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
