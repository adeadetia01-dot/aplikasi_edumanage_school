# EduTrack School — Panduan Wireframe Interaktif (MVP 1)

**Versi:** 1.0  
**Aplikasi:** Flutter Android untuk Admin, Guru Mata Pelajaran, dan Wali Kelas.  
**Backend:** Go Fiber + MySQL, deployment lokal.

## Cara membuka
1. Buka file `EduTrack_School_Wireframe_Interaktif.html` dengan Chrome, Edge, atau Firefox. HTML ini berjalan mandiri tanpa internet.
2. Pilih layar dari panel kiri atau gunakan navigasi di dalam ponsel.
3. Uji tombol **Tandai Semua Hadir**, status **H/S/I/A**, **Tambah Penugasan**, **Input Nilai**, dan **Tambah Catatan**. Perubahan adalah **simulasi memori browser halaman ini**, bukan penyimpanan permanen atau API.
4. Lihat panel kanan untuk tabel database sumber, batasan kewenangan, dan alur lanjutan layar.

## Inventaris 20 layar

| Kode | Aktor | Layar | Sumber data utama |
|---|---|---|---|
| AU-01 | Umum | Login | `users`, `refresh_tokens` |
| AU-02 | Umum | Pilih peran aktif | `roles`, `user_roles` |
| AD-01 | Admin | Dashboard | `students`, `teachers`, `classes`, `class_sessions` |
| AD-02 | Admin | Data Siswa | `students`, `student_enrollments` |
| AD-03 | Admin | Data Guru | `users`, `teachers`, `user_roles` |
| AD-04 | Admin | Data Kelas | `classes`, `student_enrollments` |
| AD-05 | Admin | Mata Pelajaran | `subjects` |
| AD-06 | Admin | Jadwal Mengajar | `teaching_assignments`, `schedules` |
| AD-07 | Admin | Wali Kelas | `homeroom_assignments` |
| GR-01 | Guru | Jadwal hari ini | `schedules`, `teaching_assignments` |
| GR-02 | Guru | Presensi per sesi | `class_sessions`, `session_roster`, `attendances` |
| GR-03 | Guru | Daftar penugasan | `assessments` |
| GR-04 | Guru | Tambah penugasan | `assessments` |
| GR-05 | Guru | Input nilai siswa | `student_scores` |
| GR-06 | Guru | Rekap nilai mentah | `assessments`, `student_scores` |
| WK-01 | Wali kelas | Dashboard kelas | `homeroom_assignments`, `student_enrollments`, `class_sessions` |
| WK-02 | Wali kelas | Daftar siswa binaan | `student_enrollments`, `students` |
| WK-03 | Wali kelas | Rekap presensi per sesi | `class_sessions`, `attendances` |
| WK-04 | Wali kelas | Rekap nilai lintas mapel | `assessments`, `student_scores` |
| WK-05 | Wali kelas | Catatan pembinaan | `student_notes` |

## Alur implementasi dan API

| Alur | Permintaan API (contoh) | Aturan | 
|---|---|---|
| Login → Pilih role | `POST /api/v1/auth/login` dan `GET /api/v1/auth/me` | Backend yang memutuskan peran yang tersedia |
| Admin mengatur data guru/siswa | `/api/v1/admin/students`, `/api/v1/admin/teachers` | RBAC admin, NIS unik, NISN opsional |
| Admin kelas, mapel, jadwal | `/api/v1/admin/classes`, `/api/v1/admin/subjects`, `/api/v1/admin/schedules` | Validasi jadwal kelas/guru bentrok dan teaching assignment |
| Guru membuka jadwal | `GET /api/v1/teacher/schedules/today` | Hanya jadwal teaching assignment guru aktif |
| Guru membuka presensi | `GET /api/v1/sessions/:id/attendance` | Roster sesi snapshot dari enrollments |
| Guru simpan presensi | `PUT /api/v1/sessions/:id/attendance` | Unik `(session_id,student_id)`, belum diisi ≠ A |
| Guru buat tugas | `POST /api/v1/assessments` | Guru pengampu sah, kategori TUGAS/UH/UTS/UAS |
| Guru input nilai | `GET/PUT /api/v1/assessments/:id/scores` | `0` valid dan skor kosong tidak sama dengan `0` |
| Guru lihat rekap | `GET /api/v1/grades/recap` | Nilai mentah saja, tanpa bobot/KKM |
| Wali kelas monitoring | `GET /api/v1/homeroom/classes/:id/summary` | Hanya kelas binaan untuk periode aktif |

**Catatan:** daftar API di atas adalah *pemetaan awal wireframe*, bukan pengganti kontrak resmi pada BRD/PRD. Jangan membuat endpoint baru hanya berdasarkan tampilan; cocokkan path, auth, payload, dan status HTTP dengan dokumen final.

## State desain yang wajib di Flutter
- **Loading:** skeleton/indikator per layar ketika API belum selesai.
- **Empty:** belum ada jadwal/tugas/siswa, dengan keterangan yang bisa dipahami.
- **Error:** gagal memuat/menyimpan, sertai tombol coba lagi bila relevan.
- **Forbidden:** 403 untuk guru mencoba kelas lain atau wali melihat kelas non-binaan.
- **Presensi belum diisi:** status `null`/record belum ada; tampilan tidak memilih H/S/I/A secara otomatis.
- **Nilai belum diisi:** tampil `—`; angka `0` adalah nilai nyata yang bisa disimpan.
- **Submit presensi:** jelaskan jumlah siswa yang belum diisi; jangan menganggap otomatis Alfa.
- **Simpan nilai:** input numerik 0–100, validasi client **dan server**.

## Batasan MVP 1
- **Belum ada:** kalkulasi nilai akhir berbobot, predikat, KKM otomatis, remedial, portal siswa, upload tugas siswa, integrasi Dapodik, fitur offline.
- Sample wireframe menampilkan hanya 6 siswa dari 34 agar mudah dinavigasi; database tetap memuat roster sebenarnya.
- Data jam, nama, semester, guru, dan skor pada prototype hanyalah contoh.
- Produk akhir menggunakan Flutter, **bukan HTML ini**. HTML adalah bahan spesifikasi dan prototipe alur.

## Rekomendasi urutan pembangunan
1. Database migrasi + seed minimal: 1 admin, 2 guru, 1 wali kelas, 2 kelas, 6 siswa, jadwal demo.
2. Login JWT + middleware RBAC/ownership.
3. Admin: periode aktif → master guru/siswa → kelas → mapel → teaching assignments → jadwal → wali kelas.
4. Guru: jadwal hari ini → sesi presensi → roster → submit/upsert presensi.
5. Guru: daftar penugasan → tambah assessment → isi dan simpan student_scores → rekap mentah.
6. Wali: dashboard kelas → daftar siswa → rekap presensi → rekap nilai read-only → catatan.
7. Integrasi Flutter (Dio + BLoC), tes widget/e2e, lalu deployment lokal.
