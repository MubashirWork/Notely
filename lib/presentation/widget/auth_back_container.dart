import 'package:flutter/cupertino.dart';
import 'package:notely/core/constants/app_colors.dart';

class AuthBackContainer extends StatelessWidget {
  final Widget child;

  const AuthBackContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.lightBlue, AppColors.softPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
