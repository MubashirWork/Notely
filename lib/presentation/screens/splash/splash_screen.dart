import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/constants/app_strings.dart';
import 'package:notely/core/data/shared_preference/shared_pref_service.dart';
import 'package:notely/presentation/widget/app_image.dart';
import 'package:notely/presentation/widget/app_text.dart';
import 'package:notely/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isLoggedIn = false;
  var username = '';

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    final loggedInPrefs = await SharedPrefService.isLoggedIn();
    final usernamePrefs = await SharedPrefService.getUsername();
    if (loggedInPrefs == true && usernamePrefs != null) {
      setState(() {
        isLoggedIn = true;
        username = usernamePrefs;
      });
    }
    Future.delayed(Duration(seconds: 1), () {
      if (isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.home,
          arguments: username,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.login,
          (route) => false,
        );
      }
    });
  }

  Future isLoggedInUser() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.royalBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImage(
                image: AppStrings.splashLogo,
                color: AppColors.white,
                width: MediaQuery.of(context).size.width * 0.3,
              ),

              const SizedBox(height: 16),

              // Splash screen text
              AppText(
                data: 'QuickNotes',
                color: AppColors.white,
                size: 18,
                weight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
