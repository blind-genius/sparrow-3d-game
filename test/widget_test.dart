import 'package:flutter_test/flutter_test.dart';
import 'package:sparrow_3d_game/main.dart';

void main() {
  testWidgets('Sparrow 3D Game app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Sparrow3DApp());
    expect(find.byType(Sparrow3DApp), findsOneWidget);
  });
}
