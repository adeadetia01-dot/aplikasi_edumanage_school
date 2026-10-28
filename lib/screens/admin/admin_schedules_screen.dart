import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class AdminSchedulesScreen extends StatefulWidget {
  const AdminSchedulesScreen({super.key});
  @override
  State<AdminSchedulesScreen> createState() => _AdminSchedulesScreenState();
}

class _AdminSchedulesScreenState extends State<AdminSchedulesScreen> {
  String _selectedClass = 'XI-MIPA 2';
  String _selectedDay   = 'Senin';

  static const _schedules = [
    {'time': '07:15–08:45', 'subject': 'B. Indonesia',   'teacher': 'Budi Santoso'},
    {'time': '09:00–10:30', 'subject': 'Matematika',      'teacher': 'Siti Rahma'},
    {'time': '11:00–12:30', 'subject': 'Fisika',          'teacher': 'Andi Prakoso'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Atur Jadwal Mengajar', subtitle: 'ADMIN', context: context),
      bottomNavigationBar: _AdminBottomNav(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter card
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MiniLabel('JADWAL MINGGUAN'),
                const SizedBox(height: 7),
                const Text('Atur Jam Pelajaran',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedClass,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                        items: ['XI-MIPA 2','X-MIPA 1','X-MIPA 2']
                            .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedClass = v!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDay,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                        items: ['Senin','Selasa','Rabu','Kamis','Jumat']
                            .map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedDay = v!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SectionHeader('Jadwal Terdaftar'),
          ..._schedules.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: EduCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusChip(s['time']!),
                          const StatusChip('Aktif', color: ChipColor.green),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(s['subject']!,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                      const SizedBox(height: 2),
                      Text('${s['teacher']} • XI-MIPA 2',
                          style: const TextStyle(fontSize: 11, color: kMuted)),
                    ],
                  ),
                ),
              )),
          const SectionHeader('Tambah Jadwal'),
          EduCard(
            child: Column(
              children: [
                // Guru
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('GURU PENGAMPU',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted, letterSpacing: 0.3)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: 'Budi Santoso',
                      decoration: const InputDecoration(),
                      items: ['Budi Santoso','Siti Rahma']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('MAPEL',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted, letterSpacing: 0.3)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: 'Bahasa Indonesia',
                      decoration: const InputDecoration(),
                      items: ['Bahasa Indonesia','Matematika']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('MULAI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
                          const SizedBox(height: 6),
                          const TextField(decoration: InputDecoration(hintText: '13:00')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SELESAI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
                          const SizedBox(height: 6),
                          const TextField(decoration: InputDecoration(hintText: '14:30')),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppButton('＋ Simpan Jadwal', fullWidth: true,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Validasi jadwal dan simpan ke MySQL akan dijalankan melalui API backend'),
                  ))),
              ],
            ),
          ),
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
