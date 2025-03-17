import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/brands/brand_card.dart';
import 'package:flutter_application_1/features/shop/models/brand_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';

class BrandShowCase extends StatelessWidget {
  const BrandShowCase({
    super.key,
    required this.images,
    required bool isDarkMode,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
        showBorder: true,
        borderColor: AppColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(AppSizes.md),
        margin: const EdgeInsets.only(bottom: AppSizes.spaceBtwItems),
        child: Column(
          children: [
            // Brand with Products Count
            BrandCard(
              showBorder: false,
              brand: BrandModel.empty(),
            ),
            // Brand Top 3 Product Images
            Row(
              children: images
                  .map((e) => brandTopProductImageWidget(e, context))
                  .toList(),
            )
          ],
        ));
  }

  Widget brandTopProductImageWidget(String image, context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return Expanded(
      child: RoundedContainer(
        height: 100,
        backgroundColor: isDarkMode ? AppColors.darkerGrey : AppColors.light,
        padding: const EdgeInsets.all(AppSizes.md),
        margin: const EdgeInsets.only(right: AppSizes.sm),
        child: Image(
          fit: BoxFit.contain,
          image: AssetImage(image),
        ),
      ),
    );
  }
}
