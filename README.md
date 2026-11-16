# GreenShift UMKM (Flutter)

Aplikasi pendamping warung kuliner: kasir & stok, penyelamat bahan,
kulakan bersama, dan simulasi energi surya.

## Cara menjalankan
1. Pasang Flutter dan Android Studio (atau VS Code).
2. `git clone https://github.com/chaopingxi/greenshift_umkm.git`
3. `cd greenshift_umkm`
4. `flutter pub get`
5. `flutter run` (tambahkan `-d chrome` untuk menjalankan di browser)

## Struktur
- `lib/main.dart`       entry point + navigasi bawah (5 tab)
- `lib/theme.dart`      warna, gaya teks, format rupiah
- `lib/models.dart`     Stock, MenuItemM, Receipt
- `lib/app_state.dart`  state global (ChangeNotifier) + simpan ke shared_preferences
- `lib/widgets.dart`    komponen UI yang dipakai ulang
- `lib/screens/`        splash, onboarding, home, kasir, bayar, selamat, energi, kulak

## Alur kerja tim
- Jangan commit langsung ke `main`. Buat cabang: `git checkout -b fitur-nama-fitur`
- Jalankan `git pull` sebelum mulai mengedit.
- Buka Pull Request di GitHub, lalu gabungkan setelah ditinjau.
