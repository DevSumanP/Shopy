import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/images.dart';
import '../../../utils/constants/sizes.dart';
import '../models/payment_method_model.dart';
import '../screens/checkout/widgets/payment_tile.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value =
        PaymentMethodModel(image: Images.paypal, name: 'Paypal');
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  children: [
                    const Sectionheading(
                      title: 'Select Payment Method',
                      showActionButton: false,
                    ),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Paypal', image: Images.paypal)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Google Pay', image: Images.googlePay)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Apple Pay', image: Images.applePay)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'VISA', image: Images.visa)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Master Card', image: Images.masterCard)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Paytm', image: Images.paytm)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Paystack', image: Images.paystack)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                    PaymentTile(
                        paymentMethod: PaymentMethodModel(
                            name: 'Credit Card', image: Images.creditCard)),
                    const SizedBox(
                      height: AppSizes.spaceBtwSections / 2,
                    ),
                  ],
                ),
              ),
            ));
  }
}
