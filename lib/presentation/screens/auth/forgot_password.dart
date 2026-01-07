import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/constants/app_strings.dart';
import 'package:notely/core/data/database/dao/user_dao/user_dao.dart';
import 'package:notely/core/service/snack_bar_service.dart';
import 'package:notely/presentation/widget/app_button.dart';
import 'package:notely/presentation/widget/app_card.dart';
import 'package:notely/presentation/widget/app_image.dart';
import 'package:notely/presentation/widget/app_text.button.dart';
import 'package:notely/presentation/widget/app_text.dart';
import 'package:notely/presentation/widget/app_text_field.dart';
import 'package:notely/presentation/widget/auth_back_container.dart';
import 'package:notely/presentation/widget/loading_indicator.dart';
import 'package:notely/routes/route_names.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Forgot controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  // Password state
  bool hideNewPassword = true;

  // Loading state
  bool isLoadingForgot = false;

  Future forgotPassword() async {
    final username = usernameController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (username.isEmpty || newPassword.isEmpty) {
      SnackBarService.show('Please fill all fields');
      return;
    }

    if (newPassword.length < 8) {
      SnackBarService.show('Minimum password length should be eight digits');
      return;
    }

    setState(() {
      isLoadingForgot = true;
    });

    final updatePassword = await UserDao.instance.updatePassword(
      username: username,
      newPassword: newPassword,
    );

    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      isLoadingForgot = false; 
    });

    if (updatePassword) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.login,
          (route) => false,
        );
        SnackBarService.show('Password updated successfully');
    } else {
        SnackBarService.show('Username does not exists');
        return;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height =
        mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;

    return Scaffold(
      body: SafeArea(
        child: AuthBackContainer(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Forgot logo
                      AppImage(
                        image: AppStrings.loginLogo,
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),

                      const SizedBox(height: 16),

                      // Forgot title text
                      AppText(
                        data: 'Easy Note App',
                        color: AppColors.white,
                        size: 18,
                        weight: FontWeight.w600,
                      ),

                      const SizedBox(height: 16),

                      // Forgot card
                      AppCard(
                        child: Column(
                          children: [
                            AppTextField(
                              prefix: Icons.account_box,
                              controller: usernameController,
                              hint: 'Your username',
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 16),

                            AppTextField(
                              prefix: Icons.lock,
                              suffix: hideNewPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              controller: newPasswordController,
                              hint: 'New Password',
                              obscureText: hideNewPassword,
                              suffixOnClick: () {
                                setState(() {
                                  hideNewPassword = !hideNewPassword;
                                });
                              },
                              textInputAction: TextInputAction.done,
                            ),

                            const SizedBox(height: 16),

                            AppButton(
                              borderColor: AppColors.mediumBlue,
                              onPressed: forgotPassword,
                              child: isLoadingForgot
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          data: 'Loading...',
                                          color: AppColors.white,
                                          size: 14,
                                          weight: FontWeight.w500,
                                        ),
                                        const SizedBox(width: 8),
                                        LoadingIndicator(),
                                      ],
                                    )
                                  : AppText(
                                      data: 'Update',
                                      color: AppColors.white,
                                      size: 14,
                                      weight: FontWeight.w500,
                                    ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Forgot text button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AppText(
                              data: "Don't have an account?",
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 2,),
                          AppTextButton(
                            onClick: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.register,
                                (route) => false,
                              );
                            },
                            text: 'Register',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
