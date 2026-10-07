import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailorhub/models/garment_type.dart';
import 'package:tailorhub/widgets/template_container.dart';

void main() {
  testWidgets('Template container renders without overflow in a grid', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 220,
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                children: [
                  TemplateContainer(
                    garmentType: GarmentType(
                      id: '1',
                      name: 'Classic Shirt',
                      description:
                          'Premium custom shirt template with sleeve and collar adjustments.',
                      isActive: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Classic Shirt'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
