import 'package:flutter_test/flutter_test.dart';
import 'package:foodlab/main.dart';

void main() {
  testWidgets('FoodLab muestra la pantalla principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FoodLabApp());
    await tester.pumpAndSettle();

    expect(find.text('FoodLab'), findsOneWidget);

    expect(
      find.text('Catálogo interactivo de\ninterfaces móviles'),
      findsOneWidget,
    );

    expect(find.text('RECETA DESTACADA'), findsOneWidget);
    expect(find.text('Pasta con vegetales'), findsOneWidget);
  });
}
