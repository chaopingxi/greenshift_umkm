import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class EnergiScreen extends StatefulWidget {
  const EnergiScreen({super.key});
  @override
  State<EnergiScreen> createState() => _EnergiScreenState();
}

class _EnergiScreenState extends State<EnergiScreen> {
  final _bill = TextEditingController(text: '600000');
  final _cost = TextEditingController(text: '18000000');
  int _pct = 30;

  @override
  void dispose() {
    _bill.dispose();
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bill = double.tryParse(_bill.text) ?? 0;
    final cost = double.tryParse(_cost.text) ?? 0;
    final hemat = bill * _pct / 100;
    final tahun = hemat * 12;
    final balik = hemat > 0 ? (cost / hemat).ceil() : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        const ScreenHeader('Simulasi Energi Terbarukan', 'Hitung potensi hemat listrik panel surya'),
        GCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('1. Tagihan listrik per bulan', style: boldText),
            const SizedBox(height: 6),
            TextField(
                controller: _bill,
                keyboardType: TextInputType.number,
                decoration: deco('Rp'),
                onChanged: (_) => setState(() {})),
            const SizedBox(height: 14),
            const Text('2. Bagian listrik dari matahari', style: boldText),
            Row(children: [
              for (final p in [20, 30, 40])
                OptBox('$p%', sel: _pct == p, onTap: () => setState(() => _pct = p)),
            ]),
            const Text('3. Biaya pemasangan (ilustratif)', style: boldText),
            const SizedBox(height: 6),
            TextField(
                controller: _cost,
                keyboardType: TextInputType.number,
                decoration: deco('Rp'),
                onChanged: (_) => setState(() {})),
          ]),
        ),
        GCard(
          color: kGreen,
          border: kGreen,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('HASIL CONTOH · HEMAT $_pct%', style: small),
            Text('${rp(hemat)} / bulan', style: bigText),
            Text('Setara ${rp(tahun)} per tahun', style: small),
            const SizedBox(height: 10),
            GCard(
              margin: EdgeInsets.zero,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text.rich(TextSpan(children: [
                  const TextSpan(text: 'Tagihan baru: '),
                  TextSpan(text: rp(bill - hemat), style: boldText),
                ])),
                Text.rich(TextSpan(children: [
                  const TextSpan(text: 'Balik modal: '),
                  TextSpan(
                    text: balik == null
                        ? '-'
                        : '$balik bulan (≈ ${(balik / 12).toStringAsFixed(1)} tahun)',
                    style: boldText,
                  ),
                ])),
              ]),
            ),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: kRed), borderRadius: BorderRadius.circular(14)),
          child: const Text('ℹ️ Estimasi, bukan jaminan.',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ),
      ],
    );
  }
}
