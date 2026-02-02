import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_betclic/app.dart';

void main() {
  testWidgets('App loads with ProviderScope', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    expect(find.text('Tic Tac Toe'), findsOneWidget);
  });
}
