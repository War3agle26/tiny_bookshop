import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_bookshop/main.dart';

void main() {
  testWidgets(
    'Book order updates total and confirms gift wrapping',
    (WidgetTester tester) async {
      // Use a tall screen so the order controls are visible.
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MyApp());

      // Add one copy of the first book.
      final addButton = find.byTooltip('Add Moth to a Flame');
      await tester.ensureVisible(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      const giftMessage =
          'Your order will be wrapped with a gold bow.';
      expect(find.text(giftMessage), findsNothing);

      // Turn on gift wrapping.
      final giftSwitch = find.byType(SwitchListTile);
      await tester.ensureVisible(giftSwitch);
      await tester.tap(giftSwitch);
      await tester.pumpAndSettle();

      expect(find.text(giftMessage), findsOneWidget);

      // Check the total row: $15.99 book plus $3.00 wrapping.
      final confirmButton = find.widgetWithText(
        FilledButton,
        'Confirm order',
      );
      await tester.ensureVisible(confirmButton);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.widgetWithText(PriceRow, 'Total'),
          matching: find.text('\$18.99'),
        ),
        findsOneWidget,
      );

      // Confirm the order and check the confirmation message.
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.text('Order confirmed!'), findsOneWidget);
      expect(
        find.textContaining('Total: \$18.99'),
        findsOneWidget,
      );
    },
  );
}