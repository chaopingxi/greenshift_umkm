class Stock {
  int id;
  String name;
  double qty;
  double max;
  String unit;
  int days; // sisa hari sebelum kedaluwarsa

  Stock({
    required this.id,
    required this.name,
    required this.qty,
    required this.max,
    required this.unit,
    required this.days,
  });

  double get ratio => max <= 0 ? 0 : qty / max;
  bool get low => ratio <= .2;
  bool get mid => ratio <= .5;

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'qty': qty, 'max': max, 'unit': unit, 'days': days};

  factory Stock.fromJson(Map<String, dynamic> j) => Stock(
        id: j['id'] as int,
        name: j['name'] as String,
        qty: (j['qty'] as num).toDouble(),
        max: (j['max'] as num).toDouble(),
        unit: j['unit'] as String,
        days: j['days'] as int,
      );
}

class MenuItemM {
  final int id;
  final String name;
  final int price;
  final String em;
  final Map<int, double> uses; // id bahan -> jumlah per porsi

  const MenuItemM({
    required this.id,
    required this.name,
    required this.price,
    required this.em,
    required this.uses,
  });
}

class Receipt {
  final String method;
  final int total;
  final int change;
  final List<MapEntry<String, int>> items;
  Receipt(this.method, this.total, this.change, this.items);
}
