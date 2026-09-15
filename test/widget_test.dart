import 'package:flutter_test/flutter_test.dart';
import 'package:mega_assignment_flutter_recipe_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());
    expect(find.text('What are you cooking today?'), findsOneWidget);
  });
}
