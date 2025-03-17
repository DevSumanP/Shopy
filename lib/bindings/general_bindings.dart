import 'package:flutter_application_1/data/services/network_manager.dart';
import 'package:flutter_application_1/features/personalization/controllers/address/address_controller.dart';
import 'package:flutter_application_1/features/shop/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(AddressController());
    Get.put(CheckoutController());
  }
}
