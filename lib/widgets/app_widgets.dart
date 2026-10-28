// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import '../app_theme.dart';

// ── EduCard ─────────────────────────────────────────────────────────────────
class EduCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  const EduCard({super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EDED)), // wireframe .card
        boxShadow: const [BoxShadow(color: Color(0x08263D30), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: child,
    );
  }
}

// ── SectionHeader ────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? right;
  const SectionHeader(this.title, {super.key, this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // wireframe .section { margin: 12px 1px 2px }
      padding: const EdgeInsets.only(top: 12, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: kInk)),
          if (right != null)
            Text(right!, style: const TextStyle(fontSize: 10, color: kMuted, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── MiniLabel ────────────────────────────────────────────────────────────────
class MiniLabel extends StatelessWidget {
  final String text;
  const MiniLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
          letterSpacing: 0.8, color: kMuted),
    );
  }
}

// ── StatusChip ───────────────────────────────────────────────────────────────
enum ChipColor { green, blue, amber, red, gray }

class StatusChip extends StatelessWidget {
  final String label;
  final ChipColor color;
  const StatusChip(this.label, {super.key, this.color = ChipColor.gray});

  Color get _bg => switch (color) {
        ChipColor.green => const Color(0xFFD0F8E5),
        ChipColor.blue  => const Color(0xFFE4ECFF),
        ChipColor.amber => const Color(0xFFFFF0DC),
        ChipColor.red   => const Color(0xFFFFE7E6),
        ChipColor.gray  => const Color(0xFFE8EDEE),
      };

  Color get _fg => switch (color) {
        ChipColor.green => const Color(0xFF056945),
        ChipColor.blue  => const Color(0xFF275AD0),
        ChipColor.amber => const Color(0xFF9F5B09),
        ChipColor.red   => const Color(0xFFBE3434),
        ChipColor.gray  => const Color(0xFF73797B),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(100)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _fg)),
    );
  }
}

// ── StatCard ─────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String count;
  final String label;
  const StatCard({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFEBEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: kMuted)),
          const SizedBox(height: 7),
          Text(count, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: Color(0xFF1B3A32))),
        ],
      ),
    );
  }
}

// ── InitialsAvatar ───────────────────────────────────────────────────────────
class InitialsAvatar extends StatelessWidget {
  final String text;
  final Color? bg;
  final Color? fg;
  final double size;
  const InitialsAvatar(this.text, {super.key, this.bg, this.fg, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFFE3EEE9),
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: fg ?? kGreen)),
    );
  }
}

// ── ListItemRow ───────────────────────────────────────────────────────────────
class ListItemRow extends StatelessWidget {
  final String avatar;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? avatarBg;
  const ListItemRow({
    super.key,
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.avatarBg,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8EEEE)),
        ),
        child: Row(
          children: [
            InitialsAvatar(avatar, bg: avatarBg),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF84908F))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF8C9697), size: 20),
          ],
        ),
      ),
    );
  }
}

// ── EmptyState ───────────────────────────────────────────────────────────────
// Design state required by docs/EduTrack_School_Wireframe_Panduan.md ("Empty").
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // keeps the standard .stack gap (11px) to the next widget
      padding: const EdgeInsets.only(bottom: 11),
      child: EduCard(
        child: Column(
          children: [
            Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFE3EEE9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kGreen, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kInk)),
            const SizedBox(height: 4),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: kMuted, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

// ── InfoNotice ────────────────────────────────────────────────────────────────
class InfoNotice extends StatelessWidget {
  final String text;
  final bool warn;
  const InfoNotice(this.text, {super.key, this.warn = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: warn ? const Color(0xFFFFF9ED) : const Color(0xFFEFF9F4),
        border: Border.all(color: warn ? const Color(0xFFFDE5B2) : const Color(0xFFD9EADE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(
          fontSize: 10, color: warn ? const Color(0xFF8F611A) : const Color(0xFF326A52), height: 1.6)),
    );
  }
}

// ── AppProgressBar ────────────────────────────────────────────────────────────
class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 – 1.0
  const AppProgressBar(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 7,
        backgroundColor: const Color(0xFFE4ECE9),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF08855B)),
      ),
    );
  }
}

// ── AppButton ─────────────────────────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonStyle style;
  final bool fullWidth;

  const AppButton(this.label, {super.key, this.onTap, this.style = AppButtonStyle.primary, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Border? border;
    switch (style) {
      case AppButtonStyle.primary:
        bg = kGreen; fg = kWhite; border = null;
      case AppButtonStyle.dark:
        bg = const Color(0xFF111111); fg = kWhite; border = null;
      case AppButtonStyle.light:
        bg = const Color(0xFFECF0F2); fg = const Color(0xFF3E5558); border = null;
      case AppButtonStyle.outline:
        bg = kWhite; fg = kGreen;
        border = Border.all(color: const Color(0xFFA6D3C3));
    }

    Widget btn = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(9), border: border),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12)),
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

enum AppButtonStyle { primary, dark, light, outline }

// ── SearchField ───────────────────────────────────────────────────────────────
class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  const SearchField({super.key, this.hint = 'Cari nama siswa atau NIS...', required this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, size: 18, color: kMuted),
        hintStyle: const TextStyle(fontSize: 12, color: kMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      ),
    );
  }
}

// ── ScoreInput ────────────────────────────────────────────────────────────────
class ScoreInput extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  const ScoreInput({super.key, this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 67,
      child: TextFormField(
        initialValue: value?.toString() ?? '',
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kGreen),
        decoration: InputDecoration(
          hintText: '—',
          hintStyle: const TextStyle(color: kMuted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          filled: true,
          fillColor: const Color(0xFFF4F8F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFFDCE7E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFFDCE7E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: kGreen, width: 1.5),
          ),
        ),
        onChanged: (v) {
          if (v.isEmpty) {
            onChanged(null);
          } else {
            final n = int.tryParse(v);
            if (n != null && n >= 0 && n <= 100) onChanged(n);
          }
        },
      ),
    );
  }
}

// ── EduAppBar ─────────────────────────────────────────────────────────────────
PreferredSizeWidget eduAppBar({
  required String title,
  String? subtitle,
  bool showBack = true,
  VoidCallback? onBackTap,
  BuildContext? context,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(59),
    child: AppBar(
      backgroundColor: kWhite,
      elevation: 0,
      leading: showBack
          ? (onBackTap != null || context != null)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: onBackTap ?? () => Navigator.maybePop(context!),
                )
              : null
          : const SizedBox.shrink(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null)
            Text(subtitle,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                    letterSpacing: 0.5, color: kGreen)),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kInk)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          // wireframe: header avatar opens the active-role screen
          child: GestureDetector(
            onTap: context == null
                ? null
                : () => Navigator.pushNamed(context, '/role-select'),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFECF6F2),
              radius: 17,
              child: const Text('◉', style: TextStyle(fontSize: 14, color: kGreen)),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFEDF0F1)),
      ),
    ),
  );
}
