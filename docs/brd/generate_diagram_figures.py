# -*- coding: utf-8 -*-
"""
Generates publication-quality, crisp diagram images for EduTrack School:
Architecture, Use Case, Navigation Flowchart, Wireframes, ERD, Token Flow,
Logical Schema, Upload Sequence, and Provider Architecture.
"""

import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as patches

OUT_DIR = r"docs\brd\figures\edutrack"
os.makedirs(OUT_DIR, exist_ok=True)

def generate_figure_01_architecture():
    fig, ax = plt.subplots(figsize=(10, 4.2), dpi=200)
    ax.set_facecolor("#F8FAFC")
    fig.patch.set_facecolor("#F8FAFC")
    
    # Layer boxes
    # Client
    box1 = patches.FancyBboxPatch((0.05, 0.25), 0.24, 0.55, boxstyle="round,pad=0.03,rounding_size=0.04",
                                  facecolor="#EEF2FF", edgecolor="#4338CA", linewidth=2)
    ax.add_patch(box1)
    ax.text(0.17, 0.70, "Flutter Mobile Client", fontsize=11, fontweight="bold", ha="center", color="#312E81")
    ax.text(0.17, 0.60, "Android / iOS (API 26+)", fontsize=8.5, ha="center", color="#4338CA")
    ax.text(0.17, 0.50, "• Provider State Mgmt\n• Secure Token Storage\n• Camera & Image Picker\n• Dio / HTTP Client", 
            fontsize=8, ha="center", color="#1E293B")
    
    # Gateway / REST API
    box2 = patches.FancyBboxPatch((0.38, 0.25), 0.25, 0.55, boxstyle="round,pad=0.03,rounding_size=0.04",
                                  facecolor="#F0FDF4", edgecolor="#16A34A", linewidth=2)
    ax.add_patch(box2)
    ax.text(0.505, 0.70, "REST API Backend Services", fontsize=11, fontweight="bold", ha="center", color="#14532D")
    ax.text(0.505, 0.60, "Go Fiber Framework / Node", fontsize=8.5, ha="center", color="#16A34A")
    ax.text(0.505, 0.48, "• JWT & RBAC Middleware\n• School / Admin Handler\n• Teacher Attendance API\n• Class & Student CRUD", 
            fontsize=8, ha="center", color="#1E293B")
    
    # Database
    box3 = patches.FancyBboxPatch((0.72, 0.52), 0.23, 0.38, boxstyle="round,pad=0.03,rounding_size=0.04",
                                  facecolor="#FEF3C7", edgecolor="#D97706", linewidth=2)
    ax.add_patch(box3)
    ax.text(0.835, 0.81, "MySQL 8.0 Relational DB", fontsize=10.5, fontweight="bold", ha="center", color="#78350F")
    ax.text(0.835, 0.68, "InnoDB • Foreign Keys\n8 Tables (schools, users,\nclasses, students, etc.)", 
            fontsize=8, ha="center", color="#1E293B")
            
    # Storage
    box4 = patches.FancyBboxPatch((0.72, 0.10), 0.23, 0.35, boxstyle="round,pad=0.03,rounding_size=0.04",
                                  facecolor="#F1F5F9", edgecolor="#64748B", linewidth=2)
    ax.add_patch(box4)
    ax.text(0.835, 0.36, "S3 Private Storage", fontsize=10.5, fontweight="bold", ha="center", color="#0F172A")
    ax.text(0.835, 0.22, "Bucket: attendance-evidence\nSurat Sakit & Foto Presensi\nSigned URLs (15 Min)", 
            fontsize=8, ha="center", color="#1E293B")

    # Arrows
    arrow1 = patches.FancyArrowPatch((0.29, 0.52), (0.38, 0.52), arrowstyle='<->', mutation_scale=15, 
                                     linewidth=2, color="#4338CA")
    ax.add_patch(arrow1)
    ax.text(0.335, 0.56, "HTTPS / REST\nBearer JWT", fontsize=7.5, ha="center", color="#4338CA", fontweight="bold")
    
    arrow2 = patches.FancyArrowPatch((0.63, 0.65), (0.72, 0.68), arrowstyle='<->', mutation_scale=15, 
                                     linewidth=2, color="#D97706")
    ax.add_patch(arrow2)
    ax.text(0.675, 0.70, "SQL / Pool", fontsize=7.5, ha="center", color="#D97706", fontweight="bold")
    
    arrow3 = patches.FancyArrowPatch((0.63, 0.38), (0.72, 0.30), arrowstyle='<->', mutation_scale=15, 
                                     linewidth=2, color="#64748B")
    ax.add_patch(arrow3)
    ax.text(0.675, 0.32, "Multipart / S3", fontsize=7.5, ha="center", color="#64748B", fontweight="bold")

    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_01_architecture.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

def generate_figure_02_usecase():
    fig, ax = plt.subplots(figsize=(10, 6.5), dpi=200)
    ax.set_facecolor("#F8FAFC")
    fig.patch.set_facecolor("#F8FAFC")
    
    # System boundary box
    sys_box = patches.FancyBboxPatch((0.22, 0.04), 0.56, 0.92, boxstyle="round,pad=0.02,rounding_size=0.03",
                                     facecolor="#FFFFFF", edgecolor="#475569", linewidth=2, linestyle="--")
    ax.add_patch(sys_box)
    ax.text(0.50, 0.92, "Sistem Informasi EduTrack School (Batas Sistem)", fontsize=11, fontweight="bold", ha="center", color="#0F172A")
    
    # Actors (Left: Admin & Guru; Right: Wali Kelas)
    # Admin
    ax.text(0.10, 0.82, "[Aktor Utama]\nAdmin Sekolah", fontsize=9.5, fontweight="bold", ha="center", color="#1E293B")
    # Guru
    ax.text(0.10, 0.44, "[Aktor Guru]\nGuru Pengampu", fontsize=9.5, fontweight="bold", ha="center", color="#1E293B")
    # Wali Kelas
    ax.text(0.89, 0.38, "[Aktor Khusus]\nWali Kelas", fontsize=9.5, fontweight="bold", ha="center", color="#1E293B")
    
    # Use cases (ellipses)
    ucs = [
        (0.50, 0.84, "Registrasi Sekolah Baru (NPSN)"),
        (0.50, 0.74, "Login via Nomor Unik (NIP/ID Admin)"),
        (0.50, 0.64, "Kelola Akun Guru (Admin Only)"),
        (0.50, 0.54, "Kelola Data Kelas & Rombel (CRUD)"),
        (0.50, 0.44, "Kelola Data Siswa (CRUD)"),
        (0.50, 0.34, "Input Presensi Harian Siswa"),
        (0.50, 0.24, "Unggah Foto Bukti & Surat Sakit"),
        (0.50, 0.14, "Rekap Presensi & Pantau Siswa Berisiko"),
        (0.50, 0.06, "Logout / Keluar Sesi")
    ]
    
    for x, y, label in ucs:
        el = patches.Ellipse((x, y), 0.44, 0.065, facecolor="#EEF2FF", edgecolor="#4338CA", linewidth=1.5)
        ax.add_patch(el)
        ax.text(x, y-0.012, label, fontsize=8.5, ha="center", color="#312E81", fontweight="bold")
        
    # Association lines
    # Admin -> Reg, Login, Kelola Guru, Kelola Kelas, Kelola Siswa, Logout
    lines_admin = [0.84, 0.74, 0.64, 0.54, 0.44, 0.06]
    for y in lines_admin:
        ax.plot([0.15, 0.28], [0.82, y], color="#4338CA", linewidth=1.2)
        
    # Guru -> Login, Presensi, Unggah Foto, Siswa, Logout
    lines_guru = [0.74, 0.44, 0.34, 0.24, 0.06]
    for y in lines_guru:
        ax.plot([0.15, 0.28], [0.44, y], color="#16A34A", linewidth=1.2)
        
    # Wali Kelas -> Login, Kelola Siswa, Rekap Presensi, Presensi, Logout
    lines_wali = [0.74, 0.44, 0.34, 0.14, 0.06]
    for y in lines_wali:
        ax.plot([0.84, 0.72], [0.38, y], color="#D97706", linewidth=1.2)

    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_02_usecase.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

def generate_figure_03_navigation():
    fig, ax = plt.subplots(figsize=(10, 5.0), dpi=200)
    ax.set_facecolor("#F8FAFC")
    fig.patch.set_facecolor("#F8FAFC")
    
    # Flow boxes
    # Splash
    b_splash = patches.FancyBboxPatch((0.02, 0.42), 0.14, 0.16, boxstyle="round,pad=0.02",
                                      facecolor="#312E81", edgecolor="#1E1B4B", linewidth=2)
    ax.add_patch(b_splash)
    ax.text(0.09, 0.50, "Splash Screen\nAuth Gate", fontsize=8.5, fontweight="bold", ha="center", color="#FFFFFF")
    
    # Login / Register
    b_auth = patches.FancyBboxPatch((0.22, 0.42), 0.16, 0.16, boxstyle="round,pad=0.02",
                                    facecolor="#EEF2FF", edgecolor="#4338CA", linewidth=2)
    ax.add_patch(b_auth)
    ax.text(0.30, 0.50, "Login (NIP)\n<-> Reg Sekolah", fontsize=8.5, fontweight="bold", ha="center", color="#312E81")
    
    # Role Selector
    b_role = patches.FancyBboxPatch((0.44, 0.42), 0.14, 0.16, boxstyle="round,pad=0.02",
                                    facecolor="#FEF3C7", edgecolor="#D97706", linewidth=2)
    ax.add_patch(b_role)
    ax.text(0.51, 0.50, "Role Switcher /\nPortal Selector", fontsize=8.5, fontweight="bold", ha="center", color="#78350F")

    # 3 Portals
    # Admin Portal
    b_adm = patches.FancyBboxPatch((0.66, 0.70), 0.31, 0.22, boxstyle="round,pad=0.02",
                                   facecolor="#EFF6FF", edgecolor="#2563EB", linewidth=1.8)
    ax.add_patch(b_adm)
    ax.text(0.815, 0.84, "Portal Admin Sekolah", fontsize=9, fontweight="bold", ha="center", color="#1E3A8A")
    ax.text(0.815, 0.74, "• Dashboard & Statistik\n• Kelola Guru • Kelola Kelas • Kelola Siswa", fontsize=7.5, ha="center", color="#1E293B")
    
    # Teacher Portal
    b_tch = patches.FancyBboxPatch((0.66, 0.39), 0.31, 0.22, boxstyle="round,pad=0.02",
                                   facecolor="#F0FDF4", edgecolor="#16A34A", linewidth=1.8)
    ax.add_patch(b_tch)
    ax.text(0.815, 0.53, "Portal Guru Pengampu", fontsize=9, fontweight="bold", ha="center", color="#14532D")
    ax.text(0.815, 0.43, "• Presensi Harian Kelas • Unggah Bukti Sakit\n• Jadwal Mengajar • Input Asesmen & Nilai", fontsize=7.5, ha="center", color="#1E293B")

    # Homeroom Portal
    b_hmr = patches.FancyBboxPatch((0.66, 0.08), 0.31, 0.22, boxstyle="round,pad=0.02",
                                   facecolor="#FAF5FF", edgecolor="#9333EA", linewidth=1.8)
    ax.add_patch(b_hmr)
    ax.text(0.815, 0.22, "Portal Wali Kelas", fontsize=9, fontweight="bold", ha="center", color="#581C87")
    ax.text(0.815, 0.12, "• Rekapitulasi Presensi • Siswa Perhatian Khusus\n• Catatan Bimbingan • Unduh Rekap Bulanan", fontsize=7.5, ha="center", color="#1E293B")

    # Connectors
    ax.add_patch(patches.FancyArrowPatch((0.16, 0.50), (0.22, 0.50), arrowstyle='->', mutation_scale=12, linewidth=1.5, color="#4338CA"))
    ax.add_patch(patches.FancyArrowPatch((0.38, 0.50), (0.44, 0.50), arrowstyle='->', mutation_scale=12, linewidth=1.5, color="#4338CA"))
    
    ax.add_patch(patches.FancyArrowPatch((0.58, 0.55), (0.66, 0.78), arrowstyle='->', mutation_scale=12, linewidth=1.5, color="#2563EB"))
    ax.add_patch(patches.FancyArrowPatch((0.58, 0.50), (0.66, 0.50), arrowstyle='->', mutation_scale=12, linewidth=1.5, color="#16A34A"))
    ax.add_patch(patches.FancyArrowPatch((0.58, 0.45), (0.66, 0.20), arrowstyle='->', mutation_scale=12, linewidth=1.5, color="#9333EA"))

    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_03_navigation.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

def generate_figure_04_wireframes():
    fig, axes = plt.subplots(1, 4, figsize=(11, 4.8), dpi=200)
    fig.patch.set_facecolor("#F8FAFC")
    
    screens = [
        ("Login Screen", [
            ("Judul: EduTrack", 0.85, "#4338CA"),
            ("Input: Nomor Unik (NIP)", 0.70, "#E2E8F0"),
            ("Input: Kata Sandi", 0.56, "#E2E8F0"),
            ("Button: Masuk", 0.40, "#4338CA"),
            ("Link: Registrasi Sekolah", 0.26, "#EEF2FF"),
        ]),
        ("Admin Dashboard", [
            ("AppBar: Admin Portal", 0.85, "#2563EB"),
            ("Card: Total Guru: 24", 0.70, "#EFF6FF"),
            ("Card: Total Siswa: 480", 0.56, "#EFF6FF"),
            ("Card: Total Kelas: 12", 0.42, "#EFF6FF"),
            ("Action: Kelola Guru/Kelas", 0.26, "#2563EB"),
        ]),
        ("Teacher Presensi", [
            ("AppBar: Presensi Kelas", 0.85, "#16A34A"),
            ("Dropdown: X MIPA 1", 0.72, "#F0FDF4"),
            ("Siswa 1: [H] [S] [I] [A]", 0.58, "#FFFFFF"),
            ("Siswa 2: [H] [S] [I] [A]", 0.44, "#FFFFFF"),
            ("Button: Simpan Presensi", 0.26, "#16A34A"),
        ]),
        ("Homeroom Rekap", [
            ("AppBar: Wali Kelas X-A", 0.85, "#9333EA"),
            ("Card: Kehadiran: 96.2%", 0.72, "#FAF5FF"),
            ("Card: 2 Siswa Perhatian", 0.58, "#FEE2E2"),
            ("Chart: Tren Mingguan", 0.42, "#FAF5FF"),
            ("Button: Unduh Laporan", 0.26, "#9333EA"),
        ])
    ]
    
    for ax, (title, comps) in zip(axes, screens):
        ax.set_facecolor("#FFFFFF")
        # Bezel
        box = patches.FancyBboxPatch((0.05, 0.05), 0.90, 0.90, boxstyle="round,pad=0.03,rounding_size=0.05",
                                     facecolor="#FFFFFF", edgecolor="#94A3B8", linewidth=2)
        ax.add_patch(box)
        ax.text(0.50, 0.96, title, fontsize=9.5, fontweight="bold", ha="center", color="#0F172A")
        
        # Draw component blocks
        for comp_text, y_pos, color in comps:
            c_box = patches.FancyBboxPatch((0.12, y_pos - 0.04), 0.76, 0.08, boxstyle="round,pad=0.01",
                                           facecolor=color, edgecolor="#CBD5E1", linewidth=1)
            ax.add_patch(c_box)
            text_color = "#FFFFFF" if color in ["#4338CA", "#2563EB", "#16A34A", "#9333EA"] else "#1E293B"
            ax.text(0.50, y_pos - 0.01, comp_text, fontsize=7.5, ha="center", color=text_color, fontweight="bold")
            
        ax.set_xlim(0, 1)
        ax.set_ylim(0, 1)
        ax.axis("off")
        
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_04_wireframes.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

def generate_figure_05_erd():
    fig, ax = plt.subplots(figsize=(10, 6.5), dpi=200)
    ax.set_facecolor("#F8FAFC")
    fig.patch.set_facecolor("#F8FAFC")
    
    tables = [
        # (x, y, title, cols, header_color)
        (0.04, 0.65, "schools", ["id (PK) : varchar(36)", "npsn : varchar(8) [UQ]", "name : varchar(120)", "level : varchar(20)", "city : varchar(80)", "academic_year : varchar(30)"], "#1E293B"),
        (0.38, 0.65, "users", ["id (PK) : varchar(36)", "school_id (FK) : varchar(36)", "unique_number : varchar(30) [UQ]", "name : varchar(120)", "password : text (bcrypt)", "role : enum('admin','teacher')"], "#4338CA"),
        (0.72, 0.65, "classes", ["id (PK) : varchar(36)", "school_id (FK) : varchar(36)", "name : varchar(50)", "grade_level : varchar(10)", "capacity : int", "homeroom_teacher_id (FK)"], "#15803D"),
        (0.72, 0.15, "students", ["id (PK) : varchar(36)", "school_id (FK) : varchar(36)", "class_id (FK) : varchar(36)", "nis : varchar(20)", "nisn : varchar(20) [UQ]", "name : varchar(120)", "gender : enum('L','P')"], "#B45309"),
        (0.38, 0.15, "attendances", ["id (PK) : varchar(36)", "school_id (FK) : varchar(36)", "class_id (FK) : varchar(36)", "student_id (FK) : varchar(36)", "teacher_id (FK) : varchar(36)", "date : date", "status : enum('H','S','I','A')"], "#BE185D"),
        (0.04, 0.15, "attendance_attachments", ["id (PK) : varchar(36)", "attendance_id (FK) : varchar(36)", "file_path : text", "file_name : varchar(120)", "file_size : bigint", "mime_type : varchar(50)"], "#475569"),
    ]
    
    for x, y, name, cols, hcolor in tables:
        w, h = 0.25, 0.28
        # Header box
        ax.add_patch(patches.Rectangle((x, y + h - 0.05), w, 0.05, facecolor=hcolor, edgecolor="#94A3B8"))
        ax.text(x + w/2, y + h - 0.035, name, fontsize=8.5, fontweight="bold", ha="center", color="#FFFFFF")
        # Body box
        ax.add_patch(patches.Rectangle((x, y), w, h - 0.05, facecolor="#FFFFFF", edgecolor="#94A3B8"))
        for idx, col in enumerate(cols):
            ax.text(x + 0.01, y + h - 0.08 - (idx * 0.038), col, fontsize=6.8, color="#1E293B")

    # Connectors (Foreign Keys)
    # schools -> users
    ax.annotate("", xy=(0.38, 0.78), xytext=(0.29, 0.78), arrowprops=dict(arrowstyle="->", color="#4338CA", lw=1.5))
    # users -> classes (homeroom)
    ax.annotate("", xy=(0.72, 0.78), xytext=(0.63, 0.78), arrowprops=dict(arrowstyle="->", color="#15803D", lw=1.5))
    # classes -> students
    ax.annotate("", xy=(0.84, 0.43), xytext=(0.84, 0.65), arrowprops=dict(arrowstyle="->", color="#B45309", lw=1.5))
    # students -> attendances
    ax.annotate("", xy=(0.63, 0.28), xytext=(0.72, 0.28), arrowprops=dict(arrowstyle="->", color="#BE185D", lw=1.5))
    # attendances -> attachments
    ax.annotate("", xy=(0.29, 0.28), xytext=(0.38, 0.28), arrowprops=dict(arrowstyle="->", color="#475569", lw=1.5))

    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_05_erd.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

def generate_figure_08_token_flow():
    fig, ax = plt.subplots(figsize=(10, 2.5), dpi=200)
    ax.set_facecolor("#F8FAFC")
    fig.patch.set_facecolor("#F8FAFC")
    
    steps = [
        ("1. Flutter Login", "Input NIP &\nKata Sandi", "#EEF2FF", "#4338CA"),
        ("2. Backend Verify", "Verifikasi bcrypt\n& Terbitkan JWT", "#F0FDF4", "#16A34A"),
        ("3. Secure Storage", "Simpan JWT di\nEncrypted Vault", "#EFF6FF", "#2563EB"),
        ("4. Request API", "Kirim Header\nBearer <token>", "#FEF3C7", "#D97706"),
        ("5. DB Isolation", "Query Scoped\nschool_id & RBAC", "#FAF5FF", "#9333EA"),
    ]
    
    for i, (title, desc, bg, edge) in enumerate(steps):
        x = 0.03 + i * 0.195
        box = patches.FancyBboxPatch((x, 0.15), 0.165, 0.70, boxstyle="round,pad=0.02",
                                     facecolor=bg, edgecolor=edge, linewidth=1.8)
        ax.add_patch(box)
        ax.text(x + 0.082, 0.66, title, fontsize=8.5, fontweight="bold", ha="center", color=edge)
        ax.text(x + 0.082, 0.40, desc, fontsize=7.5, ha="center", color="#1E293B")
        
        if i < len(steps) - 1:
            ax.annotate("", xy=(x + 0.195, 0.50), xytext=(x + 0.165, 0.50),
                        arrowprops=dict(arrowstyle="->", color="#64748B", lw=1.5))

    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_08_token_flow.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

def generate_figure_20_sequence():
    fig, ax = plt.subplots(figsize=(10, 3.2), dpi=200)
    ax.set_facecolor("#F8FAFC")
    fig.patch.set_facecolor("#F8FAFC")
    
    actors = ["Teacher App", "Camera / Gallery", "Local Compression", "Storage Service", "MySQL Database"]
    for i, act in enumerate(actors):
        x = 0.10 + i * 0.20
        ax.add_patch(patches.FancyBboxPatch((x-0.08, 0.80), 0.16, 0.15, boxstyle="round,pad=0.01",
                                            facecolor="#312E81", edgecolor="#1E1B4B"))
        ax.text(x, 0.87, act, fontsize=7.8, fontweight="bold", ha="center", color="#FFFFFF")
        ax.plot([x, x], [0.10, 0.80], color="#94A3B8", linestyle="--", lw=1)

    # Sequence arrows
    # 1. Capture photo
    ax.annotate("1. Ambil foto absensi", xy=(0.30, 0.70), xytext=(0.10, 0.70), arrowprops=dict(arrowstyle="->", color="#4338CA"))
    # 2. Return file
    ax.annotate("2. Berkas RAW", xy=(0.10, 0.60), xytext=(0.30, 0.60), arrowprops=dict(arrowstyle="->", color="#64748B", linestyle=":"))
    # 3. Compress (<500KB)
    ax.annotate("3. Kompresi JPEG <500KB", xy=(0.50, 0.50), xytext=(0.10, 0.50), arrowprops=dict(arrowstyle="->", color="#16A34A"))
    # 4. Upload multipart
    ax.annotate("4. POST Multipart to S3", xy=(0.70, 0.40), xytext=(0.10, 0.40), arrowprops=dict(arrowstyle="->", color="#D97706"))
    # 5. Return object key
    ax.annotate("5. Object Key & Path", xy=(0.10, 0.30), xytext=(0.70, 0.30), arrowprops=dict(arrowstyle="->", color="#64748B", linestyle=":"))
    # 6. Save metadata to DB
    ax.annotate("6. INSERT attachment metadata", xy=(0.90, 0.20), xytext=(0.10, 0.20), arrowprops=dict(arrowstyle="->", color="#9333EA"))

    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_20_upload_sequence.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

def generate_figure_21_22_charts():
    # Figure 21: Bar Chart
    fig, ax = plt.subplots(figsize=(6, 4.5), dpi=200)
    ax.set_facecolor("#FFFFFF")
    fig.patch.set_facecolor("#FFFFFF")
    
    classes = ['X MIPA 1', 'X MIPA 2', 'XI MIPA 1', 'XI IPS 1', 'XII MIPA']
    hadir = [96, 94, 98, 92, 97]
    absen = [4, 6, 2, 8, 3]
    
    x = range(len(classes))
    ax.bar([i - 0.15 for i in x], hadir, width=0.3, label="Kehadiran (%)", color="#16A34A")
    ax.bar([i + 0.15 for i in x], absen, width=0.3, label="Ketidakhadiran (%)", color="#DC2626")
    ax.set_xticks(x)
    ax.set_xticklabels(classes, fontsize=8.5)
    ax.set_ylabel("Persentase (%)", fontsize=9)
    ax.set_title("Figure 21. Tren & Perbandingan Kehadiran per Kelas", fontsize=10, fontweight="bold", pad=12)
    ax.legend(fontsize=8)
    ax.grid(axis='y', linestyle='--', alpha=0.5)
    plt.tight_layout()
    p1 = os.path.join(OUT_DIR, "figure_21_chart_bar.png")
    plt.savefig(p1, bbox_inches="tight")
    plt.close()
    print("Saved:", p1)
    
    # Figure 22: Pie Chart
    fig, ax = plt.subplots(figsize=(6, 4.5), dpi=200)
    ax.set_facecolor("#FFFFFF")
    fig.patch.set_facecolor("#FFFFFF")
    
    labels = ['Hadir (94.2%)', 'Sakit (2.8%)', 'Izin (2.1%)', 'Alpa (0.9%)']
    sizes = [94.2, 2.8, 2.1, 0.9]
    colors = ['#16A34A', '#2563EB', '#D97706', '#DC2626']
    explode = (0.05, 0, 0, 0)
    
    ax.pie(sizes, explode=explode, labels=labels, colors=colors, autopct='%1.1f%%',
           shadow=False, startangle=140, textprops={'fontsize': 8.5})
    ax.set_title("Figure 22. Proporsi Sebaran Status Kehadiran Sekolah", fontsize=10, fontweight="bold", pad=12)
    plt.tight_layout()
    p2 = os.path.join(OUT_DIR, "figure_22_chart_pie.png")
    plt.savefig(p2, bbox_inches="tight")
    plt.close()
    print("Saved:", p2)

def generate_figure_09_schema():
    # Figure 9: Logical Schema
    fig, ax = plt.subplots(figsize=(10, 4.8), dpi=200)
    ax.set_facecolor("#F8FAFC")
    fig.patch.set_facecolor("#F8FAFC")
    
    ax.text(0.50, 0.92, "Skema Relasional Logis Database EduTrack School (MySQL 8.0)", fontsize=11, fontweight="bold", ha="center", color="#0F172A")
    
    schemas = [
        ("schools", "PK: id | npsn (UQ) | name | level | city | address | academic_year"),
        ("users", "PK: id | FK: school_id | unique_number (UQ) | name | password (hash) | role | is_homeroom"),
        ("classes", "PK: id | FK: school_id | name | grade_level | capacity | room | FK: homeroom_teacher_id"),
        ("students", "PK: id | FK: school_id | FK: class_id | nis | nisn (UQ) | name | gender | status"),
        ("attendances", "PK: id | FK: school_id, class_id, student_id, teacher_id | date | status | note"),
        ("attendance_attachments", "PK: id | FK: attendance_id | file_path | file_name | file_size | mime_type"),
    ]
    
    for i, (tbl, cols) in enumerate(schemas):
        y = 0.78 - (i * 0.125)
        box = patches.FancyBboxPatch((0.08, y - 0.04), 0.84, 0.09, boxstyle="round,pad=0.02",
                                     facecolor="#FFFFFF", edgecolor="#312E81", linewidth=1.5)
        ax.add_patch(box)
        ax.text(0.12, y + 0.005, tbl.upper(), fontsize=9, fontweight="bold", color="#312E81")
        ax.text(0.28, y + 0.005, cols, fontsize=7.5, color="#1E293B")
        
    ax.set_xlim(0, 1)
    ax.set_ylim(0, 1)
    ax.axis("off")
    plt.tight_layout()
    p = os.path.join(OUT_DIR, "figure_09_logical_schema.png")
    plt.savefig(p, bbox_inches="tight", facecolor=fig.get_facecolor())
    plt.close()
    print("Saved:", p)

if __name__ == "__main__":
    generate_figure_01_architecture()
    generate_figure_02_usecase()
    generate_figure_03_navigation()
    generate_figure_04_wireframes()
    generate_figure_05_erd()
    generate_figure_08_token_flow()
    generate_figure_20_sequence()
    generate_figure_21_22_charts()
    generate_figure_09_schema()
    print("All core diagrams generated successfully.")
