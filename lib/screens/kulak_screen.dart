import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class KulakScreen extends StatefulWidget {
  const KulakScreen({super.key});
  @override
  State<KulakScreen> createState() => _KulakScreenState();
}

class _KulakScreenState extends State<KulakScreen> {
  int _kg = 20;
  static const _hargaKulak = 12000;
  static const _hargaNormal = 15000;

  @override
  Widget build(BuildContext context) {
    final terkumpul = 40 + _kg; // 40 kg dari 2 pesanan terkonfirmasi + jatah Anda
    final pct = (terkumpul / 50).clamp(0.0, 1.0).toDouble();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        const ScreenHeader('Kulakan Hijau', 'Beli bareng. Modal ringan. Jejak lebih kecil.'),
        const GCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Komunitas Dapur Cipete', style: boldText),
            Text('8 UMKM sekitar · 1 titik ambil bersama', style: small),
          ]),
        ),
        GCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Tag('SIMULASI', red: true),
            const SizedBox(height: 6),
            const Text('🌾 Beras lokal premium', style: h2),
            const Text('Dari petani Karawang', style: small),
            const SizedBox(height: 4),
            Text.rich(TextSpan(children: [
              TextSpan(text: rp(_hargaKulak), style: bigText),
              const TextSpan(text: '/kg', style: small),
            ])),
            Text.rich(TextSpan(children: [
              const TextSpan(text: 'Normal ', style: small),
              TextSpan(
                  text: '${rp(_hargaNormal)}/kg',
                  style: const TextStyle(
                      fontSize: 12.5, decoration: TextDecoration.lineThrough)),
              const TextSpan(text: ' · ', style: small),
              const TextSpan(text: 'Hemat 20%', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            ])),
            const SizedBox(height: 10),
            Text('${terkumpul > 50 ? 50 : terkumpul} / 50 kg terkumpul', style: const TextStyle(fontSize: 14)),
            StockBar(ratio: pct, low: false),
            const SizedBox(height: 14),
            const Text('Jatah Anda (kg)', style: boldText),
            const SizedBox(height: 6),
            Row(children: [
              SmBtn('−', onTap: () => setState(() => _kg = _kg > 5 ? _kg - 5 : 5)),
              const SizedBox(width: 10),
              Text('$_kg kg', style: boldText),
              const SizedBox(width: 10),
              SmBtn('+', onTap: () => setState(() => _kg += 5)),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text.rich(TextSpan(children: [
                const TextSpan(text: 'Bayar: '),
                TextSpan(text: rp(_kg * _hargaKulak), style: boldText),
              ])),
              Text('Normal ${rp(_kg * _hargaNormal)}', style: small),
            ]),
          ]),
        ),
        GBtn('Gabung Kulakan →', onTap: () => toast(context, 'Berhasil gabung kulakan $_kg kg ✓')),
        GBtn('Bagikan Promo ke WA',
            kind: BtnKind.red,
            onTap: () => shareWA('Yuk gabung kulakan beras Rp12.000/kg di GreenShift UMKM!')),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Harga contoh. Belum dikonfirmasi pemasok. Belum ada penagihan.',
              textAlign: TextAlign.center, style: small),
        ),
      ],
    );
  }
}
