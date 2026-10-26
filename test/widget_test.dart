import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradelink/main.dart';

void main() {
  testWidgets('TradeLink app launches and displays splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TradeLinkApp());

    // Verify tagline text exists
    expect(find.text('Import Export Commission Agent Platform'), findsOneWidget);

    // Verify brand icon exists
    expect(find.byIcon(Icons.swap_horizontal_circle_outlined), findsOneWidget);

    // Advance clock past the 1500ms splash navigation timer and settle
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Verify it smoothly transitions to the LoginScreen
    expect(find.text('Welcome back'), findsOneWidget);
  });
}

