import 'package:flutter/material.dart';
import '../app_state.dart';
import '../main.dart';
import '../theme.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  static const _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    final d = DateTime.now();
    final tgl = '${_hari[d.weekday - 1]}, ${d.day} ${_bulan[d.month - 1]}';

    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final urgent = app.stock.where((s) => s.qty > 0 && s.days <= 2).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            const Text('Halo, Bu Sari!', style: h1),
            const SizedBox(height: 4),
            Text('Warung Bu Sari · $tgl', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            const GCard(
              color: kGreen,
              border: kGreen,
              margin: EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Skor Dampak Hijau', style: boldText),
                Text('84 / 100', style: bigText),
                Tag('+12 poin', red: true),
              ]),
            ),
            const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: GCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Total Hemat Hari Ini'),
                  Text('Rp35.000', style: bigText),
                ])),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Skor Efisiensi'),
                  Text('8 / 10', style: bigText),
                ])),
              ),
            ]),
            const Text('Akses cepat', style: h2),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: [
                _quick('🧾 Kasir', 'Catat pesanan pelanggan', () => tabIndex.value = 1),
                _quick('📦 Stok Bahan', '${app.stock.length} bahan tercatat', () => tabIndex.value = 1),
                _quick('🌿 Selamatkan Bahan', 'Pakai bahan tepat waktu', () => tabIndex.value = 2),
                _quick('☀️ Energi Surya', 'Cek potensi hemat listrik', () => tabIndex.value = 4),
                _quick('📞 Bagikan ke WA', 'Bagikan skor',
                    () => shareWA('Skor Dampak Hijau warung saya 84/100 di GreenShift UMKM!')),
                _quick('👥 Gabung Kulakan', 'Beli bahan bareng', () => tabIndex.value = 3),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => tabIndex.value = 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: kRed),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('⚠️ $urgent bahan perlu dicek hari ini — lihat detail…',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _quick(String title, String sub, VoidCallback onTap) => GCard(
        margin: EdgeInsets.zero,
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: boldText),
          const SizedBox(height: 2),
          Text(sub, style: small),
        ]),
      );
}
