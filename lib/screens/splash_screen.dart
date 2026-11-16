import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Pill('SAHABAT USAHA KULINER'),
              SizedBox(height: 24),
              Text('🌿', style: TextStyle(fontSize: 64)),
              SizedBox(height: 8),
              Text('GreenShift\nUMKM', textAlign: TextAlign.center, style: h1),
              SizedBox(height: 8),
              Text('Solusi Hemat Biaya & Ramah\nLingkungan untuk Kuliner Indonesia',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _mulai(BuildContext context) {
    tabIndex.value = 0;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Shell()));
  }

  @override
  Widget build(BuildContext context) {
    const fitur = [
      ['01', 'Catat Penjualan & Stok', 'Catat menu terjual dan stok harian.'],
      ['02', 'Selamatkan Bahan', 'Pantau bahan yang mendekati kedaluwarsa.'],
      ['03', 'Kulakan Bersama', 'Beli bahan bareng warung sekitar biar lebih hemat.'],
    ];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            const Align(alignment: Alignment.centerLeft, child: Pill('GREENSHIFT UMKM')),
            const SizedBox(height: 12),
            const Text('Warung hemat, bumi sehat.', style: h1),
            const SizedBox(height: 4),
            const Text('Kelola warung. Hemat biaya. Kurangi jejak.'),
            const SizedBox(height: 16),
            for (final f in fitur)
              GCard(
                child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: kGreen, shape: BoxShape.circle),
                    child: Text(f[0], style: boldText),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(f[1], style: boldText),
                      Text(f[2], style: small),
                    ]),
                  ),
                ]),
              ),
            const SizedBox(height: 8),
            GBtn('Mulai Sekarang', onTap: () => _mulai(context)),
            GBtn('Lewati', kind: BtnKind.out, onTap: () => _mulai(context)),
          ],
        ),
      ),
    );
  }
}
