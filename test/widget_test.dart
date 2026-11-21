import 'package:flutter_test/flutter_test.dart';
import 'package:imposter/app/app.dart';
import 'package:imposter/core/constants/app_strings.dart';

void main() {
  testWidgets('App renders splash screen initially and transitions to player setup',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ImposterApp());

    // Expect splash screen title
    expect(find.text(AppStrings.splashTitle), findsOneWidget);

    // Advance time past the splash duration
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify player setup screen is now displayed
    expect(find.text(AppStrings.howManyPlayers), findsOneWidget);
  });
}
