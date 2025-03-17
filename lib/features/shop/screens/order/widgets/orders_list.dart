import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottom_navigation_bar.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:flutter_application_1/features/shop/controllers/order_controller.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/images.dart';
import '../../../../../utils/loaders/animation_loader.dart';

class OrderListItems extends StatelessWidget {
  const OrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());
    return FutureBuilder(
      future: controller.fetchUserOrders(),
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
          debugPrint('Error loading orders: ${snapshot.error}');
          return const Center(
            child: Text(
              'Something went wrong! Please try again later.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Handle empty data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          debugPrint('Orders is empty: ${snapshot.data}');
          return AnimationLoaderWidget(
            text: 'Whoops! No orders yet!',
            animation: Images.orderCompletedAnimation,
            showAction: true,
            actionText: 'Let\'s fill it',
            onActionPressed: () => Get.to(() => const BottomNavMenu()),
          );
        }

        final orders = snapshot.data!;

        return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (_, __) => const SizedBox(
            height: AppSizes.spaceBtwItems,
          ),
          itemCount: orders.length,
          itemBuilder: (_, index) {
            final order = orders[index];
            return RoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(AppSizes.md),
              backgroundColor: dark ? AppColors.dark : AppColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // 1 - Icon
                      const Icon(Iconsax.ship),
                      const SizedBox(
                        width: AppSizes.spaceBtwItems / 2,
                      ),

                      // 2 -Status & Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderStatusText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(
                                      color: AppColors.primary,
                                      fontWeightDelta: 1),
                            ),
                            Text(
                              order.formattedOrderDate,
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          ],
                        ),
                      ),

                      // 3 - Icon
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.arrow_right_34,
                            size: AppSizes.iconSm,
                          ))
                    ],
                  ),

                  const SizedBox(
                    height: AppSizes.spaceBtwItems,
                  ),

                  //  Row 2
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          // 1 - Icon
                          const Icon(Iconsax.tag),
                          const SizedBox(
                            width: AppSizes.spaceBtwItems / 2,
                          ),

                          // 2 -Status & Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  order.id,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          // 1 - Icon
                          const Icon(Iconsax.calendar),
                          const SizedBox(
                            width: AppSizes.spaceBtwItems / 2,
                          ),

                          // 2 -Status & Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping Date',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  order.formattedDeliveryDate,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
