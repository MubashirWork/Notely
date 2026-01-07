import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/presentation/widget/app_text.dart';

class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> messageKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    messageKey.currentState?.hideCurrentSnackBar();
    messageKey.currentState?.showSnackBar(
      SnackBar(
        content: AppText(data: message, color: AppColors.white),
        backgroundColor: AppColors.royalBlue,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
