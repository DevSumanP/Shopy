import 'package:flutter/material.dart';
import 'package:flutter_application_1/bindings/general_bindings.dart';
import 'package:flutter_application_1/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter_application_1/utils/theme/theme.dart';
import 'package:get/get.dart';
import 'localization/localization_service.dart';
import 'utils/local_storage/shared_prefs.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: MySharedPref.getCurrentLocal(), // app language
      translations: LocalizationService.getInstance(),
      home: const OnBoardingScreen(),
    );
  }
}
