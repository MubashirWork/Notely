import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/constants/app_strings.dart';
import 'package:notely/core/data/database/dao/user_dao/user_dao.dart';
import 'package:notely/core/data/shared_preference/shared_pref_service.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Register controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password state
  bool hidePassword = true;

  // Loading state
  bool isLoading = false;

  // Storing user data in database
  Future userRegistration() async {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (fullName.isEmpty || username.isEmpty || password.isEmpty) {
      SnackBarService.show('Please fill all fields');
      return;
    }

    if (password.length < 8) {
      SnackBarService.show('Minimum password length should be eight digits');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final userRegister = await UserDao.instance.register(
      fullName: fullName,
      username: username,
      password: password,
    );

    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      isLoading = false; 
    });

    if (userRegister) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefService.fullName, fullName);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.login,
          (route) => false,
        );
        SnackBarService.show('Registered successfully');
    } else {
        SnackBarService.show('Username already exists please login');
        return;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
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
                      // Register logo
                      AppImage(
                        image: AppStrings.loginLogo,
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),

                      const SizedBox(height: 16),

                      // Register title text
                      AppText(
                        data: 'Easy Note App',
                        color: AppColors.white,
                        size: 18,
                        weight: FontWeight.w600,
                      ),

                      const SizedBox(height: 16),

                      // Register card
                      AppCard(
                        child: Column(
                          children: [
                            AppTextField(
                              prefix: Icons.account_box,
                              controller: fullNameController,
                              hint: 'Full Name',
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 16),

                            AppTextField(
                              prefix: Icons.account_box,
                              controller: usernameController,
                              hint: 'Username (must be unique)',
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 16),

                            AppTextField(
                              prefix: Icons.lock,
                              suffix: hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              controller: passwordController,
                              hint: 'Password',
                              obscureText: hidePassword,
                              suffixOnClick: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              textInputAction: TextInputAction.done,
                            ),

                            const SizedBox(height: 16),

                            AppButton(
                              borderColor: AppColors.mediumBlue,
                              onPressed: userRegistration,
                              child: isLoading
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
                                      data: 'Sign Up',
                                      color: AppColors.white,
                                      size: 14,
                                      weight: FontWeight.w500,
                                    ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Register text button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AppText(
                              data: "Already have an account?",
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 2,),
                          AppTextButton(
                            onClick: () {
                              Navigator.pushNamed(context, RouteNames.login);
                            },
                            text: 'Login',
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
