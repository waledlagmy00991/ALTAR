import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:altar/app.dart';

void main() {
  testWidgets('ALTAR app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AltarApp());

    // Verify that the app launches
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
