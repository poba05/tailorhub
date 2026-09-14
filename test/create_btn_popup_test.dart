import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailorhub/widgets/create_btn_popup.dart';

void main() {
  testWidgets('CreateBtnPopup shows order and client actions when opened', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CreateBtnPopup())));

    expect(find.text('New order'), findsNothing);
    expect(find.text('New Client'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('New order'), findsOneWidget);
    expect(find.text('New Client'), findsOneWidget);
  });
}
