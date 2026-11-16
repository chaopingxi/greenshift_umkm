import 'package:flutter/material.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/kasir_screen.dart';
import 'screens/selamat_screen.dart';
import 'screens/kulak_screen.dart';
import 'screens/energi_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app.load();
  runApp(const GreenShiftApp());
}

class GreenShiftApp extends StatelessWidget {
  const GreenShiftApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GreenShift UMKM',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const SplashScreen(),
      );
}

/// Tab aktif: 0 Beranda, 1 Kasir, 2 Penyelamat, 3 Kulakan, 4 Energi
final tabIndex = ValueNotifier<int>(0);

class Shell extends StatelessWidget {
  const Shell({super.key});

  static const _icon = TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabIndex,
      builder: (context, i, _) => PopScope(
        // Di Beranda (tab 0) Back boleh keluar aplikasi.
        // Di tab lain, Back dialihkan dulu ke Beranda.
        canPop: i == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) tabIndex.value = 0;
        },
        child: Scaffold(
          body: SafeArea(
            child: IndexedStack(index: i, children: const [
              HomeScreen(),
              KasirScreen(),
              SelamatScreen(),
              KulakScreen(),
              EnergiScreen(),
            ]),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: i,
            onDestinationSelected: (v) => tabIndex.value = v,
            destinations: const [
              NavigationDestination(icon: Text('🏠', style: _icon), label: 'Beranda'),
              NavigationDestination(icon: Text('🧾', style: _icon), label: 'Kasir'),
              NavigationDestination(icon: Text('🌿', style: _icon), label: 'Penyelamat'),
              NavigationDestination(icon: Text('👥', style: _icon), label: 'Kulakan'),
              NavigationDestination(icon: Text('☀️', style: _icon), label: 'Energi'),
            ],
          ),
        ),
      ),
    );
  }
}
