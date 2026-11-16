import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_state.dart';
import '../main.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class BayarScreen extends StatefulWidget {
  const BayarScreen({super.key});
  @override
  State<BayarScreen> createState() => _BayarScreenState();
}

class _BayarScreenState extends State<BayarScreen> {
  String _method = 'tunai';
  int _cash = 0;
  final _ctl = TextEditingController();

  int get _t => app.total;

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _setCash(int v) => setState(() {
        _cash = v;
        _ctl.text = v == 0 ? '' : '$v';
      });

  void _bayar() {
    if (_method == 'tunai' && _cash < _t) {
      toast(context, 'Uang kurang ${rp(_t - _cash)}');
      return;
    }
    final r = app.pay(_method, _cash);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SuksesScreen(r)));
  }

  void _batal() => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => const BatalScreen()));

  @override
  Widget build(BuildContext context) {
    final kembali = _cash - _t;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            const ScreenHeader('Pembayaran', 'Pilih metode dan selesaikan transaksi', back: true),
            GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('Ringkasan', style: h2),
                const SizedBox(height: 6),
                for (final m in app.cartItems)
                  _row('${app.cart[m.id]}× ${m.name}', rp(app.cart[m.id]! * m.price)),
                _row('Total', rp(_t), bold: true, big: true),
              ]),
            ),
            const Text('Metode', style: h2),
            Row(children: [
              for (final x in ['tunai', 'qris', 'transfer'])
                OptBox(x.toUpperCase(), sel: _method == x, onTap: () => setState(() => _method = x)),
            ]),
            if (_method == 'tunai') ...[
              TextField(
                controller: _ctl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: deco('Uang diterima'),
                onChanged: (v) => setState(() => _cash = int.tryParse(v) ?? 0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _cash == 0
                      ? ''
                      : (kembali >= 0 ? 'Kembalian: ${rp(kembali)}' : 'Kurang: ${rp(-kembali)}'),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Row(children: [
                for (final v in [_t, 50000, 100000])
                  OptBox(rp(v), sel: false, onTap: () => _setCash(v)),
              ]),
            ] else if (_method == 'qris')
              const GCard(
                child: Column(children: [
                  Text('▦', style: TextStyle(fontSize: 90)),
                  Text('Scan QRIS ini dengan e-wallet pelanggan\n(contoh ilustrasi)',
                      textAlign: TextAlign.center, style: small),
                ]),
              )
            else
              GCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Bank BCA 1234567890', style: boldText),
                  Text('a.n. Warung Bu Sari · transfer tepat ${rp(_t)}', style: small),
                ]),
              ),
            GBtn('Bayar ${rp(_t)} ✓', onTap: _bayar),
            GBtn('Batalkan Transaksi', kind: BtnKind.out, onTap: _batal),
          ],
        ),
      ),
    );
  }

  Widget _row(String l, String r, {bool bold = false, bool big = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l, style: bold ? boldText : null),
          Text(r,
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: big ? 22 : 14)),
        ]),
      );
}

class SuksesScreen extends StatelessWidget {
  final Receipt r;
  const SuksesScreen(this.r, {super.key});

  void _kembaliKe(BuildContext context, int tab) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    tabIndex.value = tab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 24),
          children: [
            GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('✅', textAlign: TextAlign.center, style: TextStyle(fontSize: 56)),
                const Text('Pembayaran Berhasil', textAlign: TextAlign.center, style: h1),
                const SizedBox(height: 6),
                Text('Metode: ${r.method.toUpperCase()}',
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 10),
                for (final i in r.items) _line(i.key, rp(i.value)),
                _line('Total', rp(r.total), bold: true),
                if (r.change > 0) _line('Kembalian', rp(r.change), bold: true),
              ]),
            ),
            GBtn('Transaksi Baru', onTap: () => _kembaliKe(context, 1)),
            GBtn('Ke Beranda', kind: BtnKind.out, onTap: () => _kembaliKe(context, 0)),
          ],
        ),
      ),
    );
  }

  Widget _line(String l, String v, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l, style: bold ? boldText : null),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w800)),
        ]),
      );
}

/// Layar "Transaksi dibatalkan" (sesuai desain Figma).
class BatalScreen extends StatelessWidget {
  const BatalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
          children: [
            const GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Center(child: Pill('STATUS TRANSAKSI')),
                SizedBox(height: 16),
                Text('Transaksi dibatalkan', textAlign: TextAlign.center, style: h1),
                SizedBox(height: 8),
                Text(
                  'Pembayaran tidak dicatat. Stok tetap sama dan tidak ada uang yang tersimpan. '
                  'Kamu bisa kembali ke Kasir untuk meninjau pesanan lagi.',
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            GBtn('Kembali ke Kasir', onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              tabIndex.value = 1;
            }),
          ],
        ),
      ),
    );
  }
}
