import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_application_1/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:flutter_application_1/utils/popups/full_screen_loader.dart';
import 'package:get/get.dart';

import '../../../../data/services/network_manager.dart';
import '../../../../utils/constants/images.dart';
import '../../../../utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  // Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  // Send Reset password Email
  sendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'Processing your request...',
        Images.loaderAnimation,
      );

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Validate Form
      if (!forgetPasswordFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordRestEmail(email);

      FullScreenLoader.stopLoading();

      // Show Success Screen
      Loaders.successSnackBar(
          title: 'email Sent',
          message: 'Email link sent to reset your password'.tr);

      Get.to(() => ResetPassword(email: email));
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
