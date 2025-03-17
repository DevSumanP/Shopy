import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/login_signup/social_buttons.dart';
import 'package:flutter_application_1/features/authentication/screens/login/login.dart';
import 'package:flutter_application_1/features/authentication/screens/login/widgets/login_form.dart';
import 'package:flutter_application_1/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/main.dart'
    as app; // Adjust import based on your main.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding and Login Integration Tests', () {
    testWidgets('Onboarding Screen Flow', (WidgetTester tester) async {
      // Start the app
      app.main(); // Launches the app; adjust if your entry point differs
      await tester.pumpAndSettle();

      // Verify the first onboarding page
      expect(find.text('Choose your product'), findsOneWidget);
      expect(
          find.text(
              'Welcome to a World of limitless Choices - Your Perfect product Awaits!'),
          findsOneWidget);

      // Tap the "Next" button (assuming OnBoardingButton is a "Next" button)
      await tester.tap(
          find.byType(ElevatedButton)); // Adjust if your button type differs
      await tester.pumpAndSettle();

      // Verify the second onboarding page
      expect(find.text('Select payment method'), findsOneWidget);
      expect(
          find.text(
              'For Seamless Transcations, Choose Your Payment Path - Your Convenience, Our Priority!'),
          findsOneWidget);

      // Tap "Next" again
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify the third onboarding page
      expect(find.text('Deliver at your door step'), findsOneWidget);
      expect(
          find.text(
              'From Our DoorStep to Yours - Swift, Secure, and Contactless Delivery!'),
          findsOneWidget);

      // Tap "Skip" button to navigate away (assuming it goes to LoginScreen)
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Verify navigation to LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Login Screen Elements', (WidgetTester tester) async {
      // Directly launch the LoginScreen for this test
      await tester.pumpWidget(
        const GetMaterialApp(
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the login header
      expect(find.byType(LoginHeader), findsOneWidget);

      // Verify the login form
      expect(find.byType(LoginForm), findsOneWidget);

      // Verify the divider text
      expect(find.text('Or Sign in with'), findsOneWidget);

      // Verify social buttons
      expect(find.byType(SocialButtons), findsOneWidget);
    });
  });
}
