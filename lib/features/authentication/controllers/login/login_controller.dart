import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_application_1/data/services/network_manager.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:flutter_application_1/utils/popups/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Form Controllers
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();

  late SharedPreferences prefs;

  // Form Key for validation
  GlobalKey<FormState> logInFormKey = GlobalKey<FormState>();

  // Sign Up Method
  void logIn() async {
    try {
      prefs = await SharedPreferences.getInstance();

      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'Logging you in...',
        Images.loaderAnimation,
      );

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Validate Form
      if (!logInFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Save Data if remember me is selected
      if (rememberMe.value) {
        prefs.setString('REMEMBER_ME_EMAIL', email.text.trim());
        prefs.setString('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      await Future.delayed(const Duration(seconds: 2));

      // Register User in Firebase Authentication (Add implementation here)
      // ignore: unused_local_variable
      final userCredential = await AuthenticationRepository.instance
          .signInWithEmailPassword(email.text.trim(), password.text.trim());

      // Show Success Message
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
        title: 'Sign- Successful',
        message: 'Your account has been logged in successfully.',
      );

      await Future.delayed(const Duration(seconds: 2));

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // Show generic error to the user
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    // Dispose TextEditingControllers when the controller is closed
    super.onClose();
  }
}
