import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/features/personalization/controllers/address/address_controller.dart';
import 'package:flutter_application_1/features/personalization/models/adddress/address_model.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';

class BillingAddressSection extends StatelessWidget {
  const BillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Sectionheading(
            title: 'Shipping Address',
            buttonTitle: 'Change',
            onPressed: () => controller.selectNewAddressPopup(context),
            showActionButton: true,
          ),
          controller.selectedAddress.value.id.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedAddress.value.name.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSizes.spaceBtwItems / 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: AppSizes.spaceBtwItems),
                        Text(
                          controller.selectedAddress.value.phoneNumber
                              .toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceBtwItems / 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_history,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: AppSizes.spaceBtwItems),
                        Expanded(
                          child: Text(
                            _formattedAddress(controller.selectedAddress.value),
                            style: Theme.of(context).textTheme.bodyMedium ??
                                const TextStyle(fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  'Select Address',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
        ],
      ),
    );
  }
}

String _formattedAddress(AddressModel address) {
  List<String> parts = [
    address.street.trim(),
    address.city.trim(),
    address.state.trim(),
    address.postalCode.trim(),
    address.country.trim(),
  ];

  // Filter out empty parts and join with commas
  return parts.where((part) => part.isNotEmpty).join(', ');
}
