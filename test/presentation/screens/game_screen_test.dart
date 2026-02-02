import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_betclic/core/router/app_router.dart';

void main() {
  testWidgets('Game screen shows grid after starting game from welcome', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(routerConfig: AppRouter.create()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    expect(find.text('YOUR TURN'), findsOneWidget);
  });
}
