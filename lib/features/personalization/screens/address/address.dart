import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/shimmer/shimmer_effect.dart';
import 'package:flutter_application_1/features/personalization/controllers/address/address_controller.dart';
import 'package:flutter_application_1/features/personalization/screens/address/add_new_address.dart';
import 'package:flutter_application_1/features/personalization/screens/address/widgets/single_address.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/images.dart';
import '../../../../utils/loaders/animation_loader.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(
          () => const AddNewAddressScreen(),
        ),
        backgroundColor: AppColors.primary,
        child: const Icon(
          Iconsax.add,
          color: AppColors.white,
        ),
      ),
      appBar: Appbar(
        showBackArrow: true,
        leadingOnPressed: () {
          debugPrint('Back button pressed');
          Get.back(); // or Navigator.pop(context)
        },
        title: Text(
          'Address',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Obx(
            () => FutureBuilder(
                key: Key(controller.refreshData.value.toString()),
                future: controller.getAllUserAddresses(),
                builder: (context, snapshot) {
                  // Shimmer loader while waiting for data
                  const loader = ShimmerEffect(
                    width: double.infinity,
                    height: 100,
                  );

                  // Handle the waiting state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loader;
                  }

                  // Handle errors
                  if (snapshot.hasError) {
                    debugPrint('Error loading addresses: ${snapshot.error}');
                    return const Center(
                      child: Text(
                        'Something went wrong! Please try again later.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  // Handle empty data or no favorites
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    debugPrint('Address is empty: ${snapshot.data}');
                    return AnimationLoaderWidget(
                      text: 'Whoops! Your addresses is empty...',
                      animation: Images.pencilAnimation,
                      showAction: true,
                      actionText: 'Let\'s add some',
                      onActionPressed: () =>
                          Get.to(() => const AddNewAddressScreen()),
                    );
                  }

                  final addresses =
                      snapshot.data!; // or any logic to select an address
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    itemBuilder: (context, index) => SingleAddress(
                      address: addresses[index],
                      onTap: () => controller.selectAddress(addresses[index]),
                    ),
                  );
                }),
          )),
    );
  }
}
