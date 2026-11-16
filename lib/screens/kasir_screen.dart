import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'bayar_screen.dart';

class KasirScreen extends StatefulWidget {
  const KasirScreen({super.key});
  @override
  State<KasirScreen> createState() => _KasirScreenState();
}

class _KasirScreenState extends State<KasirScreen> {
  final _nn = TextEditingController();
  final _nq = TextEditingController();
  final _nm = TextEditingController();
  String _unit = 'kg';
  static const _units = ['kg', 'liter', 'butir', 'ikat', 'papan', 'pcs', 'bungkus'];

  @override
  void dispose() {
    _nn.dispose();
    _nq.dispose();
    _nm.dispose();
    super.dispose();
  }

  double _num(String s) => double.tryParse(s.replaceAll(',', '.')) ?? 0;

  void _tambah() {
    final n = _nn.text.trim();
    final q = _num(_nq.text);
    final m = _num(_nm.text) > 0 ? _num(_nm.text) : q;
    if (n.isEmpty || q <= 0) {
      toast(context, 'Isi nama dan jumlah bahan');
      return;
    }
    app.addStock(n, q, m, _unit);
    _nn.clear();
    _nq.clear();
    _nm.clear();
    FocusScope.of(context).unfocus();
    toast(context, '$n ditambahkan');
  }

  Future<void> _hapus(Stock s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Hapus ${s.name}?'),
        content: const Text('Bahan akan dihapus dari stok.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) app.removeStock(s.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          children: [
            const ScreenHeader('Kasir & Stok', 'Ketuk menu · catat penjualan instan'),
            const Text('Menu warung', style: h2),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: .8,
              children: [for (final m in app.menu) _menuCard(m)],
            ),
            const SizedBox(height: 14),
            Text('Stok Bahan (${app.stock.length} bahan)', style: h2),
            const SizedBox(height: 8),
            GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (app.stock.isEmpty) const Text('Belum ada bahan.', style: small),
                for (var i = 0; i < app.stock.length; i++) ...[
                  _stockRow(app.stock[i]),
                  if (i < app.stock.length - 1)
                    const Divider(height: 1, color: Color(0xFFF0E6D0)),
                ],
                const SizedBox(height: 8),
                const Text('Tambah bahan baru', style: h2),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(flex: 10, child: TextField(controller: _nn, decoration: deco('Nama bahan'))),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: _nq,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: deco('Jumlah'),
                    ),
                  ),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: kBg,
                        border: Border.all(color: kLine),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: _unit,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: [for (final u in _units) DropdownMenuItem(value: u, child: Text(u))],
                        onChanged: (v) => setState(() => _unit = v ?? 'kg'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: _nm,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: deco('Kapasitas maks'),
                    ),
                  ),
                ]),
                GBtn('+ Tambah Bahan', kind: BtnKind.out, onTap: _tambah),
              ]),
            ),
            GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${app.itemCount} item · pesanan aktif', style: boldText),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                    child: Text(
                      app.cartItems.isEmpty
                          ? 'Belum ada pesanan'
                          : app.cartItems.map((m) => '${app.cart[m.id]}× ${m.name}').join(' + '),
                      style: small,
                    ),
                  ),
                  Text(rp(app.total), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ]),
              ]),
            ),
            GBtn(
              'Lanjut Bayar · ${rp(app.total)} →',
              onTap: app.total > 0
                  ? () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const BayarScreen()))
                  : null,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('Stok otomatis berkurang setelah transaksi dicatat',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
            ),
          ],
        );
      },
    );
  }

  Widget _menuCard(MenuItemM m) {
    final q = app.cart[m.id] ?? 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: q > 0 ? kGreen : kLine, width: q > 0 ? 2 : 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(12)),
          child: Text(m.em, textAlign: TextAlign.center, style: const TextStyle(fontSize: 40)),
        ),
        const SizedBox(height: 6),
        Text(m.name, style: boldText),
        Text(rp(m.price), style: const TextStyle(fontWeight: FontWeight.w800)),
        const Spacer(),
        Row(children: [
          SmBtn('−', onTap: () => app.addCart(m.id, -1)),
          const SizedBox(width: 10),
          Text('$q', style: boldText),
          const SizedBox(width: 10),
          SmBtn('+', onTap: () => app.addCart(m.id, 1)),
        ]),
      ]),
    );
  }

  Widget _stockRow(Stock s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text.rich(TextSpan(children: [
              TextSpan(text: s.name, style: boldText),
              TextSpan(text: '  ${fmt(s.qty)} / ${fmt(s.max)} ${s.unit}', style: small),
            ])),
            StockBar(ratio: s.ratio, low: s.low),
          ]),
        ),
        const SizedBox(width: 8),
        Tag(s.low ? 'Menipis' : (s.mid ? 'Separuh' : 'Penuh'), red: s.low),
        const SizedBox(width: 6),
        SmBtn('−', onTap: () => app.adjustStock(s.id, -1)),
        const SizedBox(width: 4),
        SmBtn('+', onTap: () => app.adjustStock(s.id, 1)),
        const SizedBox(width: 4),
        SmBtn('🗑', red: true, onTap: () => _hapus(s)),
      ]),
    );
  }
}
