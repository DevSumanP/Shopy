import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/images/circular_image.dart';
import 'package:flutter_application_1/features/personalization/screens/profile/profile.dart';
import 'package:flutter_application_1/features/shop/controllers/user_controller.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: const CircularImage(
        image: Images.user,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text(
        controller.user.value.fullName,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: AppColors.white),
      ),
      subtitle: Text(
        controller.user.value.email,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .apply(color: AppColors.white),
      ),
      trailing: IconButton(
        icon: const Icon(
          Iconsax.edit,
          color: AppColors.white,
        ),
        onPressed: () => Get.to(const ProfileScreen()),
      ),
    );
  }
}
