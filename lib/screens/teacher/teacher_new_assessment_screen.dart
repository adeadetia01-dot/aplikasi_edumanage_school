import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widgets/app_widgets.dart';

class TeacherNewAssessmentScreen extends StatefulWidget {
  const TeacherNewAssessmentScreen({super.key});
  @override
  State<TeacherNewAssessmentScreen> createState() => _TeacherNewAssessmentScreenState();
}

class _TeacherNewAssessmentScreenState extends State<TeacherNewAssessmentScreen> {
  final _titleCtrl = TextEditingController(text: 'Tugas 3: Analisis Struktur Teks');
  final _maxScoreCtrl = TextEditingController(text: '100');
  final _descCtrl = TextEditingController(text: 'Analisislah struktur teks berdasarkan materi minggu ini.');
  String _category = 'TUGAS';

  @override
  void dispose() {
    _titleCtrl.dispose(); _maxScoreCtrl.dispose(); _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Isi judul penugasan terlebih dahulu')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penugasan berhasil ditambahkan pada demo')));
    Navigator.pop(context);
  }

  Widget _field(String label, Widget child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                  letterSpacing: 0.3, color: kMuted)),
          const SizedBox(height: 6),
          child,
          const SizedBox(height: 14),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(title: 'Tambah Penugasan', subtitle: 'GURU MAPEL', context: context),
      bottomNavigationBar: _TeacherBottomNav(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            EduCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  MiniLabel('XI-MIPA 2 • BAHASA INDONESIA'),
                  SizedBox(height: 7),
                  Text('Buat Penilaian Baru',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kInk)),
                ],
              ),
            ),
            const SizedBox(height: 11),
            EduCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field('JUDUL PENUGASAN *',
                      TextField(controller: _titleCtrl, decoration: const InputDecoration())),
                  _field('KATEGORI PENILAIAN',
                      DropdownButtonFormField<String>(
                        value: _category,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'TUGAS', child: Text('Tugas')),
                          DropdownMenuItem(value: 'UH',    child: Text('Ulangan Harian (UH)')),
                          DropdownMenuItem(value: 'UTS',   child: Text('UTS')),
                          DropdownMenuItem(value: 'UAS',   child: Text('UAS')),
                        ],
                        onChanged: (v) => setState(() => _category = v!),
                      )),
                  _field('TANGGAL',
                      TextField(
                        readOnly: true,
                        decoration: const InputDecoration(hintText: '2026-10-20'),
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime(2026, 10, 20),
                            firstDate: DateTime(2026), lastDate: DateTime(2027),
                          );
                        },
                      )),
                  _field('BATAS PENGUMPULAN (OPSIONAL)',
                      TextField(
                        readOnly: true,
                        decoration: const InputDecoration(hintText: '2026-10-26'),
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime(2026, 10, 26),
                            firstDate: DateTime(2026), lastDate: DateTime(2027),
                          );
                        },
                      )),
                  _field('SKOR MAKSIMUM',
                      TextField(
                        controller: _maxScoreCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(),
                      )),
                  _field('DESKRIPSI (OPSIONAL)',
                      TextField(controller: _descCtrl, maxLines: 3, decoration: const InputDecoration())),
                  const InfoNotice(
                      'Guru menginput nilai secara manual. Siswa belum memiliki menu untuk mengunggah tugas.'),
                  const SizedBox(height: 12),
                  AppButton('Simpan Penugasan', fullWidth: true, onTap: _save),
                  const SizedBox(height: 8),
                  AppButton('Batal', fullWidth: true, style: AppButtonStyle.light,
                      onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
          ],
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
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined),           label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined),      label: 'Presensi'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined),     label: 'Tugas'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Akun'),
      ],
    );
  }
}
