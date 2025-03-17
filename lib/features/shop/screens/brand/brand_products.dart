import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/brands/brand_card.dart';
import 'package:flutter_application_1/common/widgets/products/sortable/sortable.dart';
import 'package:flutter_application_1/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:flutter_application_1/features/shop/controllers/brand_controller.dart';
import 'package:flutter_application_1/features/shop/models/brand_model.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = BrandController.instance;
    return Scaffold(
      appBar: Appbar(
        title: Text(brand.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              // Brand Detail
              BrandCard(
                showBorder: true,
                brand: brand,
              ),
              const SizedBox(
                height: AppSizes.spaceBtwSections,
              ),

              FutureBuilder(
                  future: controller.getBrandProducts(brand.id),
                  builder: (context, snapshot) {
                    const loader = VerticalProductShimmer();

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loader;
                    }

                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No Data Found!'),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Something went wrong!'),
                      );
                    }

                    final brandProducts = snapshot.data!;
                    return SortableProducts(products: brandProducts);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
