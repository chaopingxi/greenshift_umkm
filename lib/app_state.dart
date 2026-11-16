import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

/// State global aplikasi (dipakai lewat ListenableBuilder).
final app = AppState();

List<Stock> _defaultStock() => [
      Stock(id: 1, name: 'Beras', qty: 8, max: 10, unit: 'kg', days: 60),
      Stock(id: 2, name: 'Ayam', qty: 2.5, max: 5, unit: 'kg', days: 2),
      Stock(id: 3, name: 'Minyak', qty: 1, max: 5, unit: 'liter', days: 90),
      Stock(id: 4, name: 'Telur', qty: 20, max: 30, unit: 'butir', days: 10),
      Stock(id: 5, name: 'Tomat', qty: 0.5, max: 2, unit: 'kg', days: 1),
      Stock(id: 6, name: 'Bayam', qty: 1, max: 3, unit: 'ikat', days: 1),
      Stock(id: 7, name: 'Tempe', qty: 10, max: 20, unit: 'papan', days: 3),
      Stock(id: 8, name: 'Gula', qty: 3, max: 5, unit: 'kg', days: 120),
      Stock(id: 9, name: 'Teh', qty: 1, max: 2, unit: 'kg', days: 90),
      Stock(id: 10, name: 'Bawang Merah', qty: 1.5, max: 3, unit: 'kg', days: 14),
    ];

const _defaultMenu = <MenuItemM>[
  MenuItemM(id: 1, name: 'Nasi ayam', price: 20000, em: '🍗', uses: {1: .15, 2: .15, 3: .02}),
  MenuItemM(id: 2, name: 'Nasi goreng', price: 18000, em: '🍛', uses: {1: .15, 4: 1, 3: .02, 10: .02}),
  MenuItemM(id: 3, name: 'Tempe goreng', price: 8000, em: '🍘', uses: {7: 1, 3: .02}),
  MenuItemM(id: 4, name: 'Es teh manis', price: 5000, em: '🧋', uses: {9: .01, 8: .03}),
];

class AppState extends ChangeNotifier {
  static const _key = 'greenshift_v1';

  List<Stock> stock = _defaultStock();
  final List<MenuItemM> menu = _defaultMenu;
  final Map<int, int> cart = {};
  int nextId = 100;
  SharedPreferences? _prefs;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_key);
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      stock = (m['stock'] as List)
          .map((e) => Stock.fromJson(e as Map<String, dynamic>))
          .toList();
      nextId = (m['nextId'] as int?) ?? 100;
    } catch (_) {
      stock = _defaultStock();
    }
  }

  void _commit() {
    _prefs?.setString(
      _key,
      jsonEncode({'stock': stock.map((s) => s.toJson()).toList(), 'nextId': nextId}),
    );
    notifyListeners();
  }

  // ---------- keranjang ----------
  int get total => menu.fold(0, (a, m) => a + (cart[m.id] ?? 0) * m.price);
  List<MenuItemM> get cartItems => menu.where((m) => (cart[m.id] ?? 0) > 0).toList();
  int get itemCount => cart.values.fold(0, (a, b) => a + b);

  void addCart(int id, int d) {
    final n = math.max(0, (cart[id] ?? 0) + d);
    if (n == 0) {
      cart.remove(id);
    } else {
      cart[id] = n;
    }
    notifyListeners();
  }

  // ---------- stok ----------
  void adjustStock(int id, int d) {
    final s = stock.firstWhere((x) => x.id == id);
    final step = (s.unit == 'kg' || s.unit == 'liter') ? .5 : 1.0;
    s.qty = math.max(0.0, s.qty + d * step);
    if (s.qty > s.max) s.max = s.qty;
    _commit();
  }

  void removeStock(int id) {
    stock.removeWhere((x) => x.id == id);
    _commit();
  }

  void addStock(String name, double qty, double max, String unit) {
    stock.add(Stock(
        id: nextId++, name: name, qty: qty, max: math.max(max, qty), unit: unit, days: 30));
    _commit();
  }

  /// Dicatat dipakai (Penyelamat): bahan dihabiskan untuk dimasak hari ini.
  void markUsed(int id) {
    final s = stock.firstWhere((x) => x.id == id);
    s.qty = 0;
    s.days = 30;
    _commit();
  }

  // ---------- pembayaran ----------
  /// Stok baru berkurang SETELAH pembayaran berhasil.
  Receipt pay(String method, int cash) {
    final t = total;
    final lines = <MapEntry<String, int>>[];
    for (final m in cartItems) {
      final n = cart[m.id]!;
      lines.add(MapEntry('$n× ${m.name}', n * m.price));
      m.uses.forEach((sid, per) {
        final i = stock.indexWhere((s) => s.id == sid);
        if (i >= 0) stock[i].qty = math.max(0.0, stock[i].qty - per * n);
      });
    }
    final r = Receipt(method, t, method == 'tunai' ? cash - t : 0, lines);
    cart.clear();
    _commit();
    return r;
  }
}
