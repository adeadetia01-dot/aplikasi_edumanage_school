import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Tab index: 0 = Guru, 1 = Admin
  int _selectedTab = 0;

  // Controllers Guru
  final _teacherNumberCtrl = TextEditingController(text: '19810101');
  final _teacherPassCtrl = TextEditingController(text: 'password123');
  bool _teacherObscure = true;

  // Controllers Admin
  final _adminUserCtrl = TextEditingController(text: 'admin');
  final _adminPassCtrl = TextEditingController(text: 'admin123');
  bool _adminObscure = true;

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _teacherNumberCtrl.dispose();
    _teacherPassCtrl.dispose();
    _adminUserCtrl.dispose();
    _adminPassCtrl.dispose();
    super.dispose();
  }

  void _handleTeacherLogin() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final error = AuthService.instance.loginGuru(
      uniqueNumber: _teacherNumberCtrl.text,
      password: _teacherPassCtrl.text,
    );

    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      final user = AuthService.instance.currentUser;
      if (user != null && user.isHomeroom) {
        // Jika guru juga wali kelas, arahkan ke role select
        Navigator.pushReplacementNamed(context, '/role-select');
      } else {
        // Jika guru mapel biasa, langsung ke jadwal mengajar
        Navigator.pushReplacementNamed(context, '/teacher/schedule');
      }
    }
  }

  void _handleAdminLogin() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final error = AuthService.instance.loginAdmin(
      username: _adminUserCtrl.text,
      password: _adminPassCtrl.text,
    );

    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      Navigator.pushReplacementNamed(context, '/admin/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 36),
              // Brand logo
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B274C),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0B274C).withValues(alpha: 0.22),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'EduManage School',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: kInk),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sistem Informasi Akademik Sekolah',
                style: TextStyle(fontSize: 13, color: kMuted),
              ),
              const SizedBox(height: 24),

              // Tab Switcher: GURU vs ADMIN
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8ECEF),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 0;
                            _errorMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0 ? kWhite : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: _selectedTab == 0
                                ? const [
                                    BoxShadow(
                                      color: Color(0x12000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Login Guru',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _selectedTab == 0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedTab == 0 ? kInk : kMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 1;
                            _errorMessage = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1 ? kWhite : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: _selectedTab == 1
                                ? const [
                                    BoxShadow(
                                      color: Color(0x12000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Login Admin',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _selectedTab == 1
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedTab == 1 ? kInk : kMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Error alert jika login gagal
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Form Sesuai Tab
              if (_selectedTab == 0)
                _buildTeacherLoginForm()
              else
                _buildAdminLoginForm(),

              const SizedBox(height: 20),

              // Link Registrasi Sekolah Baru
              Center(
                child: TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register-school'),
                  icon: const Icon(Icons.account_balance_outlined,
                      size: 17, color: kGreen),
                  label: const Text(
                    'Sekolah Baru? Daftarkan Sekolah di EduManage →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: kGreen,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ── Form Login Guru ────────────────────────────────────────────────────────
  Widget _buildTeacherLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF7F2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCCE8DD)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline, size: 18, color: kGreen),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Akun guru dibuatkan oleh Admin Sekolah. Guru hanya perlu login menggunakan Nomor Unik Guru & Kata Sandi yang telah didaftarkan.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF0C5A3E),
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        const Text(
          'NOMOR UNIK GURU (NIP / NUPTK)',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _teacherNumberCtrl,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Contoh: 19810101',
            prefixIcon: Icon(Icons.badge_outlined, size: 20, color: kMuted),
          ),
        ),
        const SizedBox(height: 14),

        const Text(
          'KATA SANDI',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _teacherPassCtrl,
          obscureText: _teacherObscure,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline, size: 20, color: kMuted),
            suffixIcon: IconButton(
              icon: Icon(
                _teacherObscure ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: kMuted,
              ),
              onPressed: () =>
                  setState(() => _teacherObscure = !_teacherObscure),
            ),
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleTeacherLogin,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Masuk sebagai Guru →'),
          ),
        ),
        const SizedBox(height: 16),

        // Quick demo buttons for testing
        const Text(
          'PILIHAN CEPAT DEMO GURU:',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _demoChip('Budi (19810101)', '19810101', 'password123'),
            _demoChip('Siti (19850214)', '19850214', 'password123'),
            _demoChip('Andi (19900325)', '19900325', 'password123'),
          ],
        ),
        const SizedBox(height: 14),

        const Center(
          child: Text(
            'Guru belum memiliki akun? Hubungi Admin Sekolah.',
            style: TextStyle(
              fontSize: 11,
              color: kMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  // ── Form Login Admin ───────────────────────────────────────────────────────
  Widget _buildAdminLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.admin_panel_settings_outlined,
                  size: 18, color: Color(0xFF334155)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Portal Administrator Sekolah. Admin memiliki hak akses penuh untuk mendaftarkan akun guru, mengatur data siswa, kelas, dan jadwal.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF334155),
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        const Text(
          'ID ADMIN / USERNAME',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _adminUserCtrl,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'admin',
            prefixIcon:
                Icon(Icons.person_outline, size: 20, color: kMuted),
          ),
        ),
        const SizedBox(height: 14),

        const Text(
          'KATA SANDI ADMIN',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: kMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _adminPassCtrl,
          obscureText: _adminObscure,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline, size: 20, color: kMuted),
            suffixIcon: IconButton(
              icon: Icon(
                _adminObscure ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: kMuted,
              ),
              onPressed: () =>
                  setState(() => _adminObscure = !_adminObscure),
            ),
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
            ),
            onPressed: _isLoading ? null : _handleAdminLogin,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Masuk sebagai Admin →'),
          ),
        ),
        const SizedBox(height: 14),

        // Quick demo chip
        GestureDetector(
          onTap: () {
            setState(() {
              _adminUserCtrl.text = 'admin';
              _adminPassCtrl.text = 'admin123';
              _errorMessage = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Isi Cepat Akun Demo Admin (admin / admin123)',
              style: TextStyle(fontSize: 11, color: Color(0xFF334155)),
            ),
          ),
        ),

        const SizedBox(height: 22),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 12),

        // Card Daftarkan Sekolah Baru untuk Admin
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.school_outlined, size: 20, color: Color(0xFF166534)),
                  SizedBox(width: 8),
                  Text(
                    'Sekolah Baru Ingin Bergabung?',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF166534),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Daftarkan sekolah Anda sekarang untuk mendapatkan hak akses admin, membuatkan akun guru, dan mengelola kelas.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF15803D),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kGreen,
                    side: const BorderSide(color: kGreen),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register-school'),
                  icon: const Icon(Icons.add_business_outlined, size: 16),
                  label: const Text('Daftarkan Sekolah Baru'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _demoChip(String label, String number, String pass) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: const Color(0xFFF0F4F2),
      onPressed: () {
        setState(() {
          _teacherNumberCtrl.text = number;
          _teacherPassCtrl.text = pass;
          _errorMessage = null;
        });
      },
    );
  }
}
