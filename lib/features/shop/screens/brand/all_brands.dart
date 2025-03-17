import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/features/shop/controllers/brand_controller.dart';
import 'package:flutter_application_1/features/shop/screens/brand/brand_products.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/brands/brand_card.dart';
import '../../../../common/widgets/shimmer/brand_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: const Appbar(
        title: Text('Brand'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              // Heading
              const Sectionheading(
                title: 'Brands',
                showActionButton: false,
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              // -- Brands
              Obx(() {
                if (controller.isLoading.value) {
                  return const BrandShimmer();
                }
                if (controller.allBrands.isEmpty) {
                  return Center(
                      child: Text(
                    'No Data Found!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: Colors.white),
                  ));
                }
                return GridLayout(
                  itemCount: controller.allBrands.length,
                  mainAxisExtent: 80,
                  itemBuilder: (context, index) {
                    final brand = controller.allBrands[index];
                    return BrandCard(
                      showBorder: true,
                      brand: brand,
                      onTap: ()=> Get.to(()=>  BrandProducts(brand: controller.allBrands[index])),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
