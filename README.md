# EduTrack School 🎓

EduTrack School adalah aplikasi manajemen akademik dan penilaian sekolah berbasis Flutter yang dirancang untuk memudahkan administrasi sekolah, guru mata pelajaran, dan wali kelas dalam mengelola proses belajar mengajar, kehadiran siswa, serta rekapitulasi nilai rapor.

---

## 🌟 Fitur Utama

### 1. 🏛️ Portal Administrator
- **Registrasi & Pengaturan Sekolah**: Setup awal identitas sekolah dan akun superadmin.
- **Manajemen Guru & Akun**: Penambahan guru, pembuatan akun dengan Nomor Unik, reset kata sandi, dan pembagian hak akses wali kelas.
- **Manajemen Kelas & Siswa**: Pendaftaran kelas, penetapan wali kelas, dan import/input data siswa per rombel.
- **Manajemen Mata Pelajaran**: Pengaturan kurikulum, mata pelajaran per tingkatan kelas, dan alokasi guru pengampu.
- **Jadwal Pelajaran**: Penjadwalan terstruktur per hari, kelas, mata pelajaran, dan jam mengajar.

### 2. 👨‍🏫 Portal Guru Mata Pelajaran
- **Presensi Siswa**: Pencatatan kehadiran real-time (Hadir, Sakit, Izin, Alpa) per sesi mata pelajaran.
- **Komponen Penilaian Fleksibel**: Pembuatan asesmen formatif (tugas, kuis) dan sumatif (UTS, UAS) dengan bobot nilai dinamis.
- **Penginputan & Rekap Nilai**: Input nilai per siswa atau massal beserta catatan evaluasi capaian kompetensi.
- **Jadwal Mengajar Harian**: Ringkasan jadwal mengajar hari ini beserta status kelas yang sedang aktif.

### 3. 📋 Portal Wali Kelas
- **Dashboard Rekap Kelas**: Gambaran umum performa akademik dan statistik kehadiran siswa di kelas binaan.
- **Rekapitulasi Kehadiran Kolektif**: Pantauan agregat presensi seluruh siswa di kelas.
- **Ledger & Nilai Rapor**: Konsolidasi nilai dari seluruh guru mata pelajaran untuk persiapan rapor akhir semester.
- **Catatan & Pembinaan Siswa**: Catatan perkembangan karakter, prestasi, dan evaluasi siswa.

---

## 🛠️ Tech Stack & Dependensi

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `>=3.3.0 <4.0.0`)
- **Desain Sistem**: Material 3 dengan custom design system modern (Color scheme, typography Inter, elevated cards, & responsive layout)
- **State & Data Management**: Service-based architecture dengan simulasi in-memory persistensi responsif
- **Asset Typography**: Inter (Regular, Medium, SemiBold, Bold, ExtraBold)

---

## 🚀 Panduan Memulai

### Prasyarat
- Flutter SDK 3.x atau lebih baru
- Android Studio / VS Code dengan ekstensi Flutter & Dart
- Android SDK (untuk menjalankan di emulator/perangkat fisik Android) atau Chrome (untuk web)

### Langkah Instalasi

1. **Clone repositori**:
   ```bash
   git clone <url-repository-anda>
   cd edutrack_school
   ```

2. **Unduh dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**:
   ```bash
   # Di perangkat default / terhubung
   flutter run

   # Di Google Chrome (Web)
   flutter run -d chrome

   # Di Emulator Android
   flutter run -d android
   ```

4. **Jalankan Pengujian Unit & Widget**:
   ```bash
   flutter test
   ```

---

## 📁 Struktur Direktori

```text
edutrack_school/
├── assets/                  # Gambar logo dan font Inter
│   ├── fonts/
│   └── images/
├── docs/                    # Dokumentasi BRD, mockup UI, dan wireframe
├── lib/
│   ├── app_theme.dart       # Konfigurasi tema Material 3 dan warna palet
│   ├── main.dart            # Titik masuk utama aplikasi (Entrypoint)
│   ├── screens/
│   │   ├── admin/           # Halaman portal administrator
│   │   ├── auth/            # Halaman login, seleksi peran, dan registrasi
│   │   ├── homeroom/        # Halaman portal wali kelas
│   │   └── teacher/         # Halaman portal guru mata pelajaran
│   ├── services/            # Logika bisnis & manajemen data (Auth, Academic)
│   └── widgets/             # Komponen UI modular (Cards, Badges, Buttons)
├── test/                    # Pengujian widget dan alur kerja aplikasi
└── pubspec.yaml             # Konfigurasi dependensi Flutter
```

---

## 🔑 Kredensial Demo

Aplikasi dilengkapi data demo siap pakai:
- **Admin**: `admin@edutrack.sch.id` / `admin123`
- **Guru Budi**: Nomor Unik `19810101` / `password123`
- **Guru Siti (Wali Kelas)**: Nomor Unik `19850214` / `password123`
- **Guru Andi**: Nomor Unik `19900325` / `password123`
