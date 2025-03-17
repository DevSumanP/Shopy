import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/features/authentication/controllers/onboarding/onboarding_controller.dart';

void main() {
  setUp(() {
    // Initialize GetX for testing
    Get.testMode = true;
  });

  group('OnBoardingController', () {
    test('initial page should be 0', () {
      // Arrange
      final controller = OnBoardingController();

      // Assert
      expect(controller.currentPageIndex.value, 0);
    });

    test('updatePageIndicator should update current page index', () {
      // Arrange
      final controller = OnBoardingController();

      // Act
      controller.updatePageIndicator(1);

      // Assert
      expect(controller.currentPageIndex.value, 1);
    });

    testWidgets('pageController should move to correct page',
        (WidgetTester tester) async {
      // Arrange
      final controller = OnBoardingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: PageView(
            controller: controller.pageController,
            children: [Container(), Container(), Container()],
          ),
        ),
      );

      // Ensure the widget tree is built
      await tester.pumpAndSettle();

      // Move to the correct page
      controller.pageController.jumpToPage(2);
      await tester.pumpAndSettle();

      // Assert
      expect(controller.pageController.page, 2.0);
    });
  });
}
