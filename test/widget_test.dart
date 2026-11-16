import 'package:flutter_test/flutter_test.dart';
import 'package:greenshift_umkm/main.dart';

void main() {
  testWidgets('Aplikasi menampilkan splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GreenShiftApp());
    expect(find.text('SAHABAT USAHA KULINER'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3)); // tunggu pindah dari splash
  });
}