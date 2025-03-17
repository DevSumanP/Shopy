import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/user/user_repository.dart';
import 'package:flutter_application_1/features/shop/controllers/user_controller.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:flutter_application_1/utils/popups/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popups/loaders.dart';
import 'package:get/get.dart';

import '../../../../data/services/network_manager.dart';
import '../../screens/profile/profile.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  // Fetch user record
  Future<void> initializeNames() async {
    firstname.text = userController.user.value.firstname;
    lastname.text = userController.user.value.lastname;
  }

  Future<void> updateUserName() async {
    try {
      FullScreenLoader.openLoadingDialog(
          'We are updating your information...', Images.loaderAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();

        return;
      }

      // Validate Form
      if (!updateUserNameKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();

        return;
      }

      // Update user's first name and last name in the firebase firestore
      Map<String, dynamic> name = {
        'firstname': firstname.text.trim(),
        'lastname': lastname.text.trim()
      };
      await userRepository.updateSingleField(name);

      // Update the Rx value
      userController.user.value.firstname = firstname.text.trim();
      userController.user.value.lastname = lastname.text.trim();

      // Remove loader
      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(
          title: 'Congratulations', message: 'Your name has been updated.');

      Get.off(() => const ProfileScreen());
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
