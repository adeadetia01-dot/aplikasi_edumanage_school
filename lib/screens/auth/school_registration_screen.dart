import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_widgets.dart';

class SchoolRegistrationScreen extends StatefulWidget {
  const SchoolRegistrationScreen({super.key});

  @override
  State<SchoolRegistrationScreen> createState() =>
      _SchoolRegistrationScreenState();
}

class _SchoolRegistrationScreenState extends State<SchoolRegistrationScreen> {
  // Step: 0 = Info Sekolah, 1 = Akun Admin, 2 = Konfirmasi
  int _currentStep = 0;

  // Controllers Bagian 1: Sekolah
  final _schoolNameCtrl = TextEditingController();
  final _npsnCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _schoolEmailCtrl = TextEditingController();
  final _schoolPhoneCtrl = TextEditingController();
  String _selectedLevel = 'SMA / SMK / MA';

  // Controllers Bagian 2: Admin Utama
  final _adminNameCtrl = TextEditingController();
  final _adminUserCtrl = TextEditingController();
  final _adminPassCtrl = TextEditingController();
  final _adminConfirmPassCtrl = TextEditingController();
  final _adminPhoneCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  // Bagian 3: Ketentuan
  bool _agreedToTerms = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _schoolNameCtrl.dispose();
    _npsnCtrl.dispose();
    _cityCtrl.dispose();
    _addressCtrl.dispose();
    _schoolEmailCtrl.dispose();
    _schoolPhoneCtrl.dispose();
    _adminNameCtrl.dispose();
    _adminUserCtrl.dispose();
    _adminPassCtrl.dispose();
    _adminConfirmPassCtrl.dispose();
    _adminPhoneCtrl.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() => _errorMessage = null);

    // Validasi Bagian 1
    if (_schoolNameCtrl.text.trim().isEmpty) {
      setState(() {
        _currentStep = 0;
        _errorMessage = 'Nama sekolah wajib diisi.';
      });
      return;
    }
    if (_npsnCtrl.text.trim().length < 8) {
      setState(() {
        _currentStep = 0;
        _errorMessage = 'NPSN sekolah wajib berupa 8 digit angka.';
      });
      return;
    }
    if (_cityCtrl.text.trim().isEmpty) {
      setState(() {
        _currentStep = 0;
        _errorMessage = 'Kota / Kabupaten sekolah wajib diisi.';
      });
      return;
    }
    if (_addressCtrl.text.trim().isEmpty) {
      setState(() {
        _currentStep = 0;
        _errorMessage = 'Alamat sekolah wajib diisi.';
      });
      return;
    }
    if (_schoolEmailCtrl.text.trim().isEmpty ||
        !_schoolEmailCtrl.text.contains('@')) {
      setState(() {
        _currentStep = 0;
        _errorMessage = 'Email resmi sekolah valid wajib diisi.';
      });
      return;
    }

    // Validasi Bagian 2
    if (_adminNameCtrl.text.trim().isEmpty) {
      setState(() {
        _currentStep = 1;
        _errorMessage = 'Nama Administrator / Penanggung Jawab wajib diisi.';
      });
      return;
    }
    if (_adminUserCtrl.text.trim().isEmpty) {
      setState(() {
        _currentStep = 1;
        _errorMessage = 'Username login admin wajib diisi.';
      });
      return;
    }
    if (_adminPassCtrl.text.length < 6) {
      setState(() {
        _currentStep = 1;
        _errorMessage = 'Kata sandi admin minimal 6 karakter.';
      });
      return;
    }
    if (_adminPassCtrl.text != _adminConfirmPassCtrl.text) {
      setState(() {
        _currentStep = 1;
        _errorMessage = 'Konfirmasi kata sandi tidak cocok.';
      });
      return;
    }

    // Validasi Syarat
    if (!_agreedToTerms) {
      setState(() {
        _errorMessage =
            'Harap centang persetujuan pernyataan perwakilan sekolah.';
      });
      return;
    }

    setState(() => _isLoading = true);

    final error = AuthService.instance.registerSchool(
      schoolName: _schoolNameCtrl.text,
      npsn: _npsnCtrl.text,
      level: _selectedLevel,
      city: _cityCtrl.text,
      address: _addressCtrl.text,
      schoolEmail: _schoolEmailCtrl.text,
      schoolPhone: _schoolPhoneCtrl.text,
      adminName: _adminNameCtrl.text,
      adminUsername: _adminUserCtrl.text,
      adminPassword: _adminPassCtrl.text,
      academicYear: '2026/2027 • Semester Ganjil',
    );

    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      _showRegistrationSuccessDialog();
    }
  }

  void _showRegistrationSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: kGreen, size: 26),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Sekolah Berhasil Terdaftar!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat! ${_schoolNameCtrl.text.trim()} telah resmi terdaftar di EduManage School.',
                style: const TextStyle(fontSize: 12.5, color: kInk),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NAMA SEKOLAH',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    Text(_schoolNameCtrl.text.trim(),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kInk)),
                    const SizedBox(height: 8),
                    const Text('NPSN SEKOLAH',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    Text(_npsnCtrl.text.trim(),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kInk)),
                    const SizedBox(height: 8),
                    const Text('USERNAME ADMIN',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    Text(_adminUserCtrl.text.trim(),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF275AD0))),
                    const SizedBox(height: 8),
                    const Text('KATA SANDI ADMIN',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    Text(_adminPassCtrl.text,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF275AD0))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, size: 14, color: kGreen),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Sebagai Admin Utama, Anda sekarang dapat mulai menambahkan akun guru, kelas, dan jadwal mengajar.',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0C5A3E),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Ke Halaman Login'),
          ),
          ElevatedButton(
            onPressed: () {
              // Otomatis login sebagai admin baru
              AuthService.instance.loginAdmin(
                username: _adminUserCtrl.text.trim(),
                password: _adminPassCtrl.text,
              );
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, '/admin/dashboard');
            },
            child: const Text('Buka Dashboard Admin →'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: eduAppBar(
        title: 'Registrasi Sekolah Baru',
        subtitle: 'PENDAFTARAN MITRA',
        context: context,
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9F4E6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBCE7D2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B274C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Daftarkan Sekolah Anda',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF064E3B),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Kelola presensi, penugasan, nilai & jadwal mengajar dalam satu sistem terintegrasi.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF047857),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Step Tabs
              Row(
                children: [
                  _buildStepTab(0, '1. Profil Sekolah'),
                  const SizedBox(width: 8),
                  _buildStepTab(1, '2. Akun Admin'),
                ],
              ),
              const SizedBox(height: 16),

              // Error Banner
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF5C2C0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 18, color: Color(0xFFC53030)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9B2C2C),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

              // Form Sesuai Step
              if (_currentStep == 0) ...[
                _buildSchoolInfoSection(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_schoolNameCtrl.text.trim().isEmpty ||
                          _npsnCtrl.text.trim().isEmpty) {
                        setState(() => _errorMessage =
                            'Nama Sekolah dan NPSN wajib diisi sebelum lanjut.');
                        return;
                      }
                      setState(() {
                        _errorMessage = null;
                        _currentStep = 1;
                      });
                    },
                    child: const Text('Lanjut: Buat Akun Admin Sekolah →'),
                  ),
                ),
              ] else ...[
                _buildAdminAccountSection(),
                const SizedBox(height: 16),
                _buildTermsSection(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() => _currentStep = 0),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      child: const Text('← Kembali'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndSubmit,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Daftarkan Sekolah Sekarang'),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepTab(int step, String title) {
    final isActive = _currentStep == step;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentStep = step),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? kInk : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive ? kWhite : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  // ── Bagian 1: Data Sekolah ────────────────────────────────────────────────
  Widget _buildSchoolInfoSection() {
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DATA IDENTITAS SEKOLAH',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, color: kGreen),
          ),
          const SizedBox(height: 12),

          const Text('NAMA LENGKAP SEKOLAH *',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
          const SizedBox(height: 4),
          TextField(
            controller: _schoolNameCtrl,
            decoration: const InputDecoration(
              hintText: 'Contoh: SMA Negeri 1 Harapan Bangsa',
              prefixIcon: Icon(Icons.school_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NPSN (8 DIGIT) *',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _npsnCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      decoration: const InputDecoration(
                        hintText: '20104567',
                        prefixIcon: Icon(Icons.pin_outlined, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('JENJANG SEKOLAH',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedLevel,
                      items: const [
                        DropdownMenuItem(
                            value: 'SMA / SMK / MA',
                            child: Text('SMA / SMK',
                                style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(
                            value: 'SMP / MTs',
                            child: Text('SMP / MTs',
                                style: TextStyle(fontSize: 13))),
                        DropdownMenuItem(
                            value: 'SD / MI',
                            child:
                                Text('SD / MI', style: TextStyle(fontSize: 13))),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedLevel = val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text('KOTA / KABUPATEN *',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
          const SizedBox(height: 4),
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              hintText: 'Contoh: Bandung / Jakarta Selatan',
              prefixIcon: Icon(Icons.location_city_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 12),

          const Text('ALAMAT LENGKAP SEKOLAH *',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
          const SizedBox(height: 4),
          TextField(
            controller: _addressCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Jl. Pendidikan No. 45, RT 02 / RW 05',
              prefixIcon: Icon(Icons.place_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('EMAIL RESMI SEKOLAH *',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _schoolEmailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'sekolah@sch.id',
                        prefixIcon: Icon(Icons.mail_outline, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TELEPON SEKOLAH',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _schoolPhoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '021-7890123',
                        prefixIcon: Icon(Icons.phone_outlined, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bagian 2: Akun Administrator Sekolah ──────────────────────────────────
  Widget _buildAdminAccountSection() {
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AKUN ADMINISTRATOR UTAMA SEKOLAH',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, color: kGreen),
          ),
          const SizedBox(height: 6),
          const Text(
            'Admin ini yang akan mengatur data akademik, membuatkan akun guru, dan mengelola kelas.',
            style: TextStyle(fontSize: 11.5, color: kMuted),
          ),
          const SizedBox(height: 14),

          const Text('NAMA LENGKAP ADMIN / PENANGGUNG JAWAB *',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
          const SizedBox(height: 4),
          TextField(
            controller: _adminNameCtrl,
            decoration: const InputDecoration(
              hintText: 'Contoh: Drs. H. Mulyono',
              prefixIcon: Icon(Icons.person_outline, size: 18),
            ),
          ),
          const SizedBox(height: 12),

          const Text('USERNAME LOGIN ADMIN *',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
          const SizedBox(height: 4),
          TextField(
            controller: _adminUserCtrl,
            decoration: const InputDecoration(
              hintText: 'Contoh: admin_sman1',
              prefixIcon: Icon(Icons.account_circle_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('KATA SANDI ADMIN *',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _adminPassCtrl,
                      obscureText: _obscurePass,
                      decoration: InputDecoration(
                        hintText: 'Min 6 karakter',
                        prefixIcon:
                            const Icon(Icons.lock_outline, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('KONFIRMASI SANDI *',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: kMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _adminConfirmPassCtrl,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        hintText: 'Ulangi sandi',
                        prefixIcon:
                            const Icon(Icons.lock_outline, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text('NOMOR WHATSAPP / HP ADMIN (OPSIONAL)',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w800, color: kMuted)),
          const SizedBox(height: 4),
          TextField(
            controller: _adminPhoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Contoh: 081234567890',
              prefixIcon: Icon(Icons.phone_iphone, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bagian 3: Ketentuan ────────────────────────────────────────────────────
  Widget _buildTermsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _agreedToTerms,
            onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              child: const Text(
                'Saya menyatakan bahwa data yang diisi adalah benar dan sah mewakili instansi sekolah untuk menggunakan EduManage School.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF334155),
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
