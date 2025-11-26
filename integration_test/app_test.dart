import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mini_game_collection/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Mini Game Collection'), findsOneWidget);
  });
}


