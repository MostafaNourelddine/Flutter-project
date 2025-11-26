import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_game_collection/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniGameCollectionApp());
    expect(find.text('Mini Game Collection'), findsOneWidget);
  });
}


