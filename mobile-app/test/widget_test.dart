// Basic smoke test: the app boots and shows the onboarding screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:osec_mobile/main.dart';

void main() {
  testWidgets('App boots into onboarding with OSEC branding', (WidgetTester tester) async {
    await tester.pumpWidget(const OSECApp());
    await tester.pumpAndSettle();

    expect(find.text('OSEC'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
  });
}
