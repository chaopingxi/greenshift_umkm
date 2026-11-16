import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

class GCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final Color? color;
  final Color? border;
  final VoidCallback? onTap;
  const GCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 10),
    this.color,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(16);
    return Container(
      margin: margin,
      child: Material(
        color: color ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: r, side: BorderSide(color: border ?? kLine)),
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(12), child: child),
        ),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  const Pill(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(99)),
        child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
      );
}

class Tag extends StatelessWidget {
  final String text;
  final bool red;
  const Tag(this.text, {super.key, this.red = false});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: red ? kRed : kBg, borderRadius: BorderRadius.circular(99)),
        child: Text(text,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: red ? Colors.white : kMaroon)),
      );
}

enum BtnKind { green, red, out }

class GBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final BtnKind kind;
  const GBtn(this.label, {super.key, this.onTap, this.kind = BtnKind.green});

  @override
  Widget build(BuildContext context) {
    final bg = kind == BtnKind.red ? kRed : (kind == BtnKind.out ? Colors.white : kGreen);
    final fg = kind == BtnKind.red ? Colors.white : kMaroon;
    final r = BorderRadius.circular(14);
    return Opacity(
      opacity: onTap == null ? .5 : 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
              borderRadius: r,
              side: kind == BtnKind.out ? const BorderSide(color: kLine) : BorderSide.none),
          child: InkWell(
            borderRadius: r,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Center(
                child: Text(label,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tombol kecil 32x32 (+ / − / hapus / ✓)
class SmBtn extends StatelessWidget {
  final String t;
  final VoidCallback? onTap;
  final bool red;
  const SmBtn(this.t, {super.key, this.onTap, this.red = false});

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(10);
    return Opacity(
      opacity: onTap == null ? .5 : 1,
      child: Material(
        color: red ? kRed : kGreen,
        borderRadius: r,
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Text(t,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: red ? Colors.white : kMaroon)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pilihan (TUNAI / 20% / dst). Pakai di dalam Row.
class OptBox extends StatelessWidget {
  final String label;
  final bool sel;
  final VoidCallback onTap;
  const OptBox(this.label, {super.key, required this.sel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(12);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Material(
          color: sel ? kGreen : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: r, side: const BorderSide(color: kLine)),
          child: InkWell(
            borderRadius: r,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Center(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StockBar extends StatelessWidget {
  final double ratio;
  final bool low;
  const StockBar({super.key, required this.ratio, required this.low});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0).toDouble(),
            minHeight: 8,
            backgroundColor: const Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation(low ? kRed : kGreen),
          ),
        ),
      );
}

class ScreenHeader extends StatelessWidget {
  final String title;
  final String sub;
  final bool back;
  const ScreenHeader(this.title, this.sub, {super.key, this.back = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          if (back) ...[
            Material(
              color: Colors.white,
              elevation: 1,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: const SizedBox(
                    width: 36, height: 36, child: Center(child: Text('←', style: TextStyle(fontSize: 18)))),
              ),
            ),
            const SizedBox(width: 10),
          ],
          const Pill('GreenShift UMKM'),
        ]),
        const SizedBox(height: 8),
        Text(title, style: h1),
        const SizedBox(height: 4),
        Text(sub, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 12),
      ],
    );
  }
}

InputDecoration deco(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: kBg,
      isDense: true,
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kLine)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kLine)),
    );

void toast(BuildContext context, String t) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    content: Text(t, style: const TextStyle(color: Colors.white)),
    backgroundColor: kMaroon,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(milliseconds: 1800),
  ));
}

Future<void> shareWA(String text) async {
  final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
