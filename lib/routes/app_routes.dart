import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/presentation/screens/auth/forgot_password.dart';
import 'package:notely/presentation/screens/auth/login_screen.dart';
import 'package:notely/presentation/screens/auth/register_screen.dart';
import 'package:notely/presentation/screens/edit_name/edit_full_name.dart';
import 'package:notely/presentation/screens/home/home_screen.dart';
import 'package:notely/presentation/screens/profile/profile_screen.dart';
import 'package:notely/presentation/screens/splash/splash_screen.dart';
import 'package:notely/presentation/widget/app_text.dart';
import 'package:notely/routes/route_names.dart';

class AppRoutes {
  
  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: AppText(data: 'Something went wrong', color: AppColors.black),
        ),
      ),
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteNames.forgot:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case RouteNames.home:
        final username = settings.arguments;
        if (username is String) {
          return MaterialPageRoute(
            builder: (_) => HomeScreen(username: username),
          );
        }
        return _errorRoute();
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouteNames.editFullName:
        return MaterialPageRoute(builder: (_) => const EditFullName());
      default:
        return _errorRoute();
    }
  }
}
