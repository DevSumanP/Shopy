import 'package:get/get.dart';

class SwitchController extends GetxController {
  static SwitchController get instance => Get.find();

  RxBool isSafeMode = false.obs;
  RxBool isHDImage = false.obs;
}
