import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/images/circular_image.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:flutter_application_1/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:flutter_application_1/features/shop/controllers/user_controller.dart';
import 'package:flutter_application_1/utils/constants/images.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const Appbar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const CircularImage(
                      image: Images.user,
                      width: 80,
                      height: 80,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Change Profile Picture',
                      ),
                    ),
                  ],
                ),
              ),

              // Details
              const SizedBox(
                height: AppSizes.spaceBtwItems / 2,
              ),
              const Divider(),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),

              // Heading Profile Info
              const Sectionheading(title: 'Profile Information'),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),

              ProfileMenu(
                  onTap: () => Get.to(() => const ChangeName()),
                  title: 'Name',
                  value: controller.user.value.fullName),
              ProfileMenu(
                  onTap: () {},
                  title: 'Username',
                  value: controller.user.value.username),

              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              const Divider(),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),

              // Heading Personal Info
              const Sectionheading(title: 'Personal Information'),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),

              ProfileMenu(
                onTap: () {},
                title: 'User ID',
                value: controller.user.value.id,
                icon: Iconsax.copy,
              ),
              ProfileMenu(
                  onTap: () {},
                  title: 'E-mail',
                  value: controller.user.value.email),
              ProfileMenu(
                  onTap: () {},
                  title: 'Phone Number',
                  value: controller.user.value.phone),
              ProfileMenu(onTap: () {}, title: 'Gender', value: 'Male'),
              ProfileMenu(
                  onTap: () {}, title: 'Date of Birth', value: '10 Oct, 1994'),

              const Divider(),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),

              Center(
                child: TextButton(
                    onPressed: () => controller.deleteAccountWarningPopup(),
                    child: const Text(
                      'Close Account',
                      style: TextStyle(color: Colors.red),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
