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

    expect(find.text('Pasta con pollo'), findsOneWidget);

    expect(find.text('Crea tu receta'), findsOneWidget);

    expect(find.text('Acciones de cocina'), findsOneWidget);

    expect(find.text('Personaliza tu menú'), findsOneWidget);

    expect(find.text('Explora recetas'), findsOneWidget);

    expect(find.text('Cocina en progreso'), findsOneWidget);

    expect(find.text('Diseño de FoodLab'), findsOneWidget);
  });
}
