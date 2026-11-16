# GreenShift UMKM (Flutter)

## Cara menjalankan
1. `flutter create greenshift_umkm`   (buat project kosong)
2. Salin folder `lib/` dan `pubspec.yaml` dari zip ini ke project tersebut (timpa yang ada).
3. `flutter pub get`
4. `flutter run`

## Struktur
- `lib/main.dart`       — entry point + navigasi bawah (5 tab)
- `lib/theme.dart`      — warna, gaya teks, format rupiah
- `lib/models.dart`     — Stock, MenuItemM, Receipt
- `lib/app_state.dart`  — state global (ChangeNotifier) + simpan ke shared_preferences
- `lib/widgets.dart`    — komponen UI yang dipakai ulang
- `lib/screens/`        — splash, onboarding, home, kasir, bayar, selamat, energi, kulak
