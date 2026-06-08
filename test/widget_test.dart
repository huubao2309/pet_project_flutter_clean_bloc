import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pet_project_flutter_clean_bloc/environments/env_type.dart';
import 'package:pet_project_flutter_clean_bloc/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        envType: EnvType.staging,
        appName: EnvType.staging.appName,
        baseUrl: 'https://staging.api.example.com',
      ),
    );

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
