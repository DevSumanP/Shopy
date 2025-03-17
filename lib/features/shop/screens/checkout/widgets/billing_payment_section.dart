import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/checkout_controller.dart';

class BillingPaymentSection extends StatelessWidget {
  const BillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    final dark = HelperFunctions.isDarkMode(context);
    return Column(
      children: [
        // Heading
        Sectionheading(
          title: 'Payment Method',
          buttonTitle: 'Change',
          showActionButton: true,
          onPressed: () => controller.selectPaymentMethod(context),
        ),
        const SizedBox(
          height: AppSizes.spaceBtwItems / 2,
        ),
        Obx(
          () => Row(children: [
            RoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? AppColors.light : AppColors.white,
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Image(
                image: AssetImage(controller.selectedPaymentMethod.value.image),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: AppSizes.spaceBtwItems / 2,
            ),
            Text(
              controller.selectedPaymentMethod.value.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ]),
        )
      ],
    );
  }
}
