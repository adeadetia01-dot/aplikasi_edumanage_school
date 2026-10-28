import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class TeacherScheduleScreen extends StatelessWidget {
  const TeacherScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Jadwal Mengajar', subtitle: 'GURU MAPEL', context: context),
      bottomNavigationBar: _TeacherBottomNav(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header info
          EduCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  MiniLabel('TAHUN AJARAN 2026/2027'),
                  SizedBox(height: 5),
                  Text('Selasa, 20 Oktober 2026',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                ]),
                const StatusChip('Semester Ganjil', color: ChipColor.green),
              ],
            ),
          ),
          const SectionHeader('Jadwal Mengajar Hari Ini', right: 'WIB GMT+7'),

          // Sesi 1 – Selesai
          _ScheduleCard(
            borderColor: kGreen,
            time: '07:15 – 08:45',
            statusLabel: 'Selesai', statusColor: ChipColor.green,
            timeColor: kMuted,
            className: 'Kelas X-MIPA 1',
            detail: 'Bahasa Indonesia • 36 siswa',
            actions: [
              _schedBtn('Presensi', AppButtonStyle.light,
                  () => Navigator.pushNamed(context, '/teacher/attendance')),
              const SizedBox(width: 7),
              _schedBtn('Input Nilai', AppButtonStyle.light,
                  () => Navigator.pushNamed(context, '/teacher/assessments')),
            ],
          ),
          const SizedBox(height: 11),

          // Sesi 2 – Berlangsung
          _ScheduleCard(
            borderColor: kBlue,
            time: '09:00 – 10:30',
            timeChipColor: ChipColor.blue,
            statusLabel: 'Berlangsung', statusColor: ChipColor.blue,
            className: 'Kelas XI-MIPA 2',
            detail: 'Bahasa Indonesia • 34 siswa',
            progress: 31 / 34,
            progressLabel: '31 / 34 siswa',
            actions: [
              _schedBtn('Presensi', AppButtonStyle.dark,
                  () => Navigator.pushNamed(context, '/teacher/attendance')),
              const SizedBox(width: 7),
              _schedBtn('Input Nilai', AppButtonStyle.light,
                  () => Navigator.pushNamed(context, '/teacher/assessments')),
            ],
          ),
          const SizedBox(height: 11),

          // Sesi 3 – Belum Mulai
          _ScheduleCard(
            borderColor: const Color(0xFFC5C5C5),
            time: '11:00 – 12:30',
            statusLabel: 'Belum Mulai', statusColor: ChipColor.gray,
            className: 'Kelas XII-MIPA 3',
            detail: 'Bahasa Indonesia Peminatan • 32 siswa',
          ),
          const SizedBox(height: 12),

          const InfoNotice(
              'ℹ️ Tombol Presensi dapat dibuka berdasarkan aturan izin sekolah; '
              'status jadwal tidak memberikan hak edit di kelas lain.'),
        ],
      ),
    );
  }

  Widget _schedBtn(String label, AppButtonStyle style, VoidCallback onTap) =>
      Expanded(child: AppButton(label, style: style, onTap: onTap));
}

class _ScheduleCard extends StatelessWidget {
  final Color borderColor;
  final String time;
  final ChipColor? timeChipColor;
  final String statusLabel;
  final ChipColor statusColor;
  final String className;
  final String detail;
  final double? progress;
  final String? progressLabel;
  final List<Widget>? actions;
  final Color? timeColor;

  const _ScheduleCard({
    required this.borderColor,
    required this.time,
    this.timeChipColor,
    required this.statusLabel,
    required this.statusColor,
    required this.className,
    required this.detail,
    this.progress,
    this.progressLabel,
    this.actions,
    this.timeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EDED)),
        boxShadow: const [BoxShadow(color: Color(0x08263D30), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        // wireframe .schedule { border-left: 4px solid; padding-left: 12px }
        child: Container(
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: borderColor, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusChip(time, color: timeChipColor ?? ChipColor.gray),
                  StatusChip(statusLabel, color: statusColor),
                ],
              ),
              const SizedBox(height: 12),
              Text(className,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kInk)),
              const SizedBox(height: 4),
              Text(detail, style: const TextStyle(fontSize: 11, color: kMuted)),
              if (progress != null) ...[
                const SizedBox(height: 11),
                Row(
                  children: [
                    const Text('Progress presensi ', style: TextStyle(fontSize: 11)),
                    Text(progressLabel!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kGreen)),
                  ],
                ),
                const SizedBox(height: 7),
                AppProgressBar(progress!),
              ],
              if (actions != null) ...[
                const SizedBox(height: 12),
                Row(children: actions!),
              ],
            ],
          ),
        ),
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
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),         label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined),    label: 'Presensi'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined),   label: 'Tugas'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Akun'),
      ],
    );
  }
}
