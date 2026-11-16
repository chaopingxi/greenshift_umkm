import 'package:flutter/material.dart';

const kBg = Color(0xFFFDF0DC);
const kGreen = Color(0xFFA8CC12);
const kMaroon = Color(0xFF8B2A3E);
const kRed = Color(0xFFE0114A);
const kLine = Color(0xFFC9DE5A);

/// 12000 -> Rp12.000
String rp(num n) {
  final s = n.round().abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return n < 0 ? '-Rp$b' : 'Rp$b';
}

/// 2.50 -> "2.5", 3.0 -> "3"
String fmt(double v) {
  final r = double.parse(v.toStringAsFixed(2));
  return r == r.roundToDouble() ? r.toInt().toString() : r.toString();
}

const h1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.1);
const h2 = TextStyle(fontSize: 17, fontWeight: FontWeight.w700);
const small = TextStyle(fontSize: 12.5);
const bigText = TextStyle(fontSize: 30, fontWeight: FontWeight.w800);
const boldText = TextStyle(fontWeight: FontWeight.w700);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kBg,
    colorScheme: ColorScheme.fromSeed(seedColor: kGreen)
        .copyWith(primary: kGreen, onPrimary: kMaroon, surface: kBg, onSurface: kMaroon),
    textTheme: ThemeData.light().textTheme.apply(bodyColor: kMaroon, displayColor: kMaroon),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: kBg,
      indicatorColor: kGreen,
    ),
  );
}
