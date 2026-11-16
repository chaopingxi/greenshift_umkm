import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

class SelamatScreen extends StatefulWidget {
  const SelamatScreen({super.key});
  @override
  State<SelamatScreen> createState() => _SelamatScreenState();
}

class _SelamatScreenState extends State<SelamatScreen> {
  bool _layak = false; // pemeriksaan kelayakan sebelum "catat dipakai"

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        // FEFO: yang paling dekat kedaluwarsa didahulukan
        final l = app.stock.where((s) => s.qty > 0 && s.days <= 3).toList()
          ..sort((a, b) => a.days.compareTo(b.days));
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            const ScreenHeader('Selamatkan bahan', 'Bahan terpakai, uang tidak terbuang.'),
            const Text('Bahan yang mendekati kedaluwarsa', style: h2),
            const SizedBox(height: 8),
            if (l.isEmpty) const GCard(child: Text('Semua bahan aman 🎉')),
            for (final s in l)
              GCard(
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${s.name} · ${fmt(s.qty)} ${s.unit}', style: boldText),
                      Text(s.days <= 1 ? 'Mulai layu · cek hari ini' : 'Sisa ${s.days} hari',
                          style: small),
                    ]),
                  ),
                  SmBtn('✓', onTap: _layak ? () {
                    app.markUsed(s.id);
                    toast(context, '${s.name} dicatat dipakai');
                  } : null),
                ]),
              ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: kGreen,
              checkColor: kMaroon,
              value: _layak,
              onChanged: (v) => setState(() => _layak = v ?? false),
              title: const Text('Saya sudah cek bau, tampilan, dan tekstur — bahan masih layak',
                  style: TextStyle(fontSize: 13)),
            ),
            const GCard(
              color: kGreen,
              border: kGreen,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('CARA MUDAH: MASAK HARI INI', style: boldText),
                Text('Tumis bayam tomat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text('±4 porsi · Potensi terselamatkan: Rp15.000', style: small),
              ]),
            ),
            const GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🛡 Peringatan keamanan', style: boldText),
                Text('Bahan basi? Jangan digunakan.', style: small),
              ]),
            ),
            GBtn('Bagikan Promo ke WA',
                kind: BtnKind.out,
                onTap: () => shareWA('Hari ini saya selamatkan bahan makanan lewat GreenShift UMKM 🌿')),
          ],
        );
      },
    );
  }
}
