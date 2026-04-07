import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/app.dart';

void main() {
  testWidgets('App starts and shows onboarding or home', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: OffChatApp(),
      ),
    );

    // Verify that the app title or some onboarding text is present.
    // Since it starts with a splash screen in onboarding.
    expect(find.text('OFFCHAT'), findsOneWidget);
  });
}
