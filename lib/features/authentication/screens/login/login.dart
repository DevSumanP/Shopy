import 'package:flutter/material.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: SpacingStyles.paddingWithAppBarHeight,
            child: Column(
              children: [
                // Logo, Title & Sub title
                LoginHeader(dark: dark),

                // Form
                const LoginForm(),

                // Divider
                FormDivider(
                  dark: dark,
                  dividerText: 'Or Sign in with',
                ),

                const SizedBox(height: AppSizes.spaceBtwSections),

                // Footer
                const SocialButtons()
              ],
            )),
      ),
    );
  }
}
