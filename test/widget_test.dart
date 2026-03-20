import 'package:flutter_test/flutter_test.dart';
import 'package:mnemosyne/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MnemosyneApp(),
      ),
    );

    // Verify Mnemosyne logo or app name exists on splash
    expect(find.text('MNEMOSYNE'), findsOneWidget);
  });
}
