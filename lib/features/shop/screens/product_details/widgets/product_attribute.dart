import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/chips/choice_chips.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:flutter_application_1/common/widgets/texts/product_price_text.dart';
import 'package:flutter_application_1/common/widgets/texts/product_title_text.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/sizes.dart';

class ProductAttribute extends StatelessWidget {
  const ProductAttribute({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = HelperFunctions.isDarkMode(context);
    return Column(
      children: [
        // -- Selected Attribute Pricing & Description
        RoundedContainer(
          padding: const EdgeInsets.all(AppSizes.md),
          backgroundColor: darkMode ? AppColors.darkerGrey : AppColors.grey,
          child: Column(
            children: [
              // Title, Product and Stock Status
              Row(
                children: [
                  const Sectionheading(
                      title: 'Variation', showActionButton: false),
                  const SizedBox(width: AppSizes.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ProductTitleText(
                              title: 'Price : ', smallSize: true),
                          const SizedBox(width: AppSizes.spaceBtwItems),

                          // Actual Price
                          Text('\$25',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .apply(
                                      decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: AppSizes.spaceBtwItems),

                          // Sale Price
                          const ProductPriceText(price: '20'),
                        ],
                      ),

                      // Stock
                      Row(
                        children: [
                          const ProductTitleText(
                              title: 'Stock', smallSize: true),
                          Text('In Stock',
                              style: Theme.of(context).textTheme.titleMedium)
                        ],
                      )
                    ],
                  ),
                ],
              ),

              // Variation Description
              const ProductTitleText(
                title:
                    'This is the description of the product and it can be upto max 4 line.',
                smallSize: true,
                maxLines: 4,
              )
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spaceBtwItems),

        // -- Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Sectionheading(title: 'Colors'),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                CustomChoiceChip(
                  text: 'Green',
                  selected: true,
                  onSelected: (value) {},
                ),
                CustomChoiceChip(
                  text: 'Blue',
                  selected: false,
                  onSelected: (value) {},
                ),
                CustomChoiceChip(
                  text: 'Yellow',
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Sectionheading(title: 'Size'),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                CustomChoiceChip(
                  text: 'EU 34',
                  selected: true,
                  onSelected: (value) {},
                ),
                CustomChoiceChip(
                  text: 'EU 36',
                  selected: false,
                  onSelected: (value) {},
                ),
                CustomChoiceChip(
                  text: 'EU 38',
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
