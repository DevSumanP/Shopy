import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter_application_1/data/repositories/user/user_repository.dart';
import 'package:flutter_application_1/data/services/network_manager.dart';
import 'package:flutter_application_1/features/authentication/screens/signup/verify_email.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:flutter_application_1/utils/popups/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popups/loaders.dart';
import 'package:get/get.dart';

import '../../models/user.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // Form Controllers
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();

  // Form Key for validation
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  // Sign Up Method
  void signUp() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
        'We are processing your information...',
        Images.loaderAnimation,
      );

      await Future.delayed(const Duration(seconds: 2));

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your connection and try again.',
        );
        return;
      }

      // Validate Form
      if (!signUpFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
          title: 'Validation Error',
          message: 'Please fill all the required fields correctly.',
        );
        return;
      }

      // Privacy Policy Check (Optional logic can be added here)
      if (!privacyPolicy.value) {
        FullScreenLoader.stopLoading();
        Loaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message:
                'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.');
        return;
      }

      // Register User in Firebase Authentication (Add implementation here)
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save Authenticated User Data in Firebase Firestore (Add implementation here)
      final newUser = User(
          id: userCredential.user!.uid,
          firstname: firstName.text.trim(),
          lastname: lastName.text.trim(),
          username: userName.text.trim(),
          email: email.text.trim(),
          phone: phoneNumber.text.trim(),
          profilePicture: '');

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      await Future.delayed(const Duration(seconds: 2));

      // Show Success Message
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
        title: 'Sign-Up Successful',
        message: 'Your account has been created successfully.',
      );

      // Navigate to Verify Email Screen (Add navigation logic here)
      Get.to(() => VerifyEmail(
            email: email.text.trim(),
          ));
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
    firstName.dispose();
    lastName.dispose();
    userName.dispose();
    email.dispose();
    phoneNumber.dispose();
    super.onClose();
  }
}
