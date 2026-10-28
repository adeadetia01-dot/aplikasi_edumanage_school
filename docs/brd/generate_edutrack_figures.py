# -*- coding: utf-8 -*-
"""
Generates 45 custom, professional, high-resolution figures and UI mockups
specifically for EDUTRACK SCHOOL (School Management, Attendance, and Academic System).
Matches 1:1 with the reference report structure.
"""

import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = r"docs\brd\figures\edutrack"
os.makedirs(OUT_DIR, exist_ok=True)

# Colors
C_PRIMARY = "#4338CA"    # Indigo 700
C_PRIMARY_LIGHT = "#EEF2FF" # Indigo 50
C_SECONDARY = "#0F172A"  # Slate 900
C_BG = "#F8FAFC"         # Slate 50
C_CARD = "#FFFFFF"
C_TEXT = "#1E293B"       # Slate 800
C_MUTED = "#64748B"      # Slate 500
C_BORDER = "#CBD5E1"     # Slate 300
C_SUCCESS = "#059669"    # Emerald 600
C_WARNING = "#D97706"    # Amber 600
C_DANGER = "#DC2626"     # Rose 600
C_INFO = "#0284C7"       # Sky 600

def draw_phone_frame(title, subtitle="", width=420, height=780):
    """Creates a base smartphone mockup image with status bar, app bar, and bottom nav."""
    im = Image.new("RGB", (width, height), C_BG)
    draw = ImageDraw.Draw(im)
    
    # Outer bezel / shadow simulation
    draw.rounded_rectangle([(0, 0), (width-1, height-1)], radius=36, outline="#94A3B8", width=3)
    
    # Status bar
    draw.rectangle([(0, 0), (width, 28)], fill="#1E1B4B")
    draw.text((24, 6), "08:15", fill="#FFFFFF")
    draw.text((width - 70, 6), "LTE 98%", fill="#FFFFFF")
    
    # App Bar
    draw.rectangle([(0, 28), (width, 80)], fill=C_PRIMARY)
    draw.text((20, 42), title, fill="#FFFFFF")
    if subtitle:
        draw.text((width - 120, 44), subtitle, fill="#C7D2FE")
        
    # Bottom Nav Bar
    draw.rectangle([(0, height - 56), (width, height)], fill="#FFFFFF", outline=C_BORDER)
    navs = ["Beranda", "Presensi", "Kelas", "Profil"]
    step = width // len(navs)
    for i, n in enumerate(navs):
        x = i * step + step // 2
        color = C_PRIMARY if i == 0 else C_MUTED
        draw.text((x - 18, height - 36), n, fill=color)
        draw.rectangle([(x - 8, height - 50), (x + 8, height - 42)], fill=color)
        
    return im, draw

print("Helper definitions loaded.")
