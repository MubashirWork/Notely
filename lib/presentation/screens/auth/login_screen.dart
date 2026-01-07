import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/constants/app_strings.dart';
import 'package:notely/core/data/database/constants/user/user.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Login controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password state
  bool hidePassword = true;

  // Loading state
  bool isLoadingLogin = false;
  bool isLoadingRegister = false;

  Future userLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      SnackBarService.show('Please fill all fields');
      return;
    }

    if (password.length < 8) {
      SnackBarService.show('Minimum password length should be eight digits');
      return;
    }

    setState(() {
      isLoadingLogin = true; 
    });

    final userLogin = await UserDao.instance.loginUser(
      username: username,
      password: password,
    );

    final usernameLogin = await UserDao.instance.loginWithUsername(
      username: username,
    );

    await Future.delayed(Duration(milliseconds: 300));
    
    setState(() {
      isLoadingLogin = false; 
    });

    if (userLogin.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await prefs.setBool(SharedPrefService.loginKey, true);
      await prefs.setString(SharedPrefService.username, username);
      final fullName = userLogin.first['${User.colFullName}'];
      await prefs.setString(SharedPrefService.fullName, fullName);

        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.home,
          arguments: username,
          (routes) => false,
        );
        SnackBarService.show('Logged in successfully');
    } else {
      if (usernameLogin.isEmpty) {
          SnackBarService.show('Username not found');
      } else {
          SnackBarService.show('Password is incorrect');
      }
    }
  }

  @override
  void dispose() {
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
      resizeToAvoidBottomInset: true,
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
                      // Login logo
                      AppImage(
                        image: AppStrings.loginLogo,
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),

                      const SizedBox(height: 16),

                      // Login title text
                      AppText(
                        data: 'Easy Note App',
                        color: AppColors.white,
                        size: 18,
                        weight: FontWeight.w600,
                      ),

                      const SizedBox(height: 16),

                      // Login card
                      AppCard(
                        child: Column(
                          children: [
                            AppTextField(
                              prefix: Icons.account_box,
                              controller: usernameController,
                              hint: 'Username',
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AppButton(
                                    borderColor: AppColors.mediumBlue,
                                    onPressed: userLogin,
                                    child: isLoadingLogin
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
                                            data: 'Login',
                                            color: AppColors.white,
                                            size: 14,
                                            weight: FontWeight.w500,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppButton(
                                    backgroundColor: AppColors.white,
                                    onPressed: () {
                                      setState(() => isLoadingRegister = true);
                                      Future.delayed(
                                        Duration(milliseconds: 300),
                                        () {
                                          setState(
                                            () => isLoadingRegister = false,
                                          );
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            RouteNames.register,
                                            (routes) => false,
                                          );
                                        },
                                      );
                                    },
                                    child: isLoadingRegister
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AppText(
                                                data: 'Loading...',
                                                color: AppColors.royalBlue,
                                                size: 14,
                                                weight: FontWeight.w500,
                                              ),
                                              const SizedBox(width: 8),
                                              LoadingIndicator(
                                                color: AppColors.royalBlue,
                                              ),
                                            ],
                                          )
                                        : AppText(
                                            data: 'Sign Up',
                                            color: AppColors.royalBlue,
                                            size: 14,
                                            weight: FontWeight.w500,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Login text button
                      AppTextButton(
                        onClick: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.forgot,
                            (routes) => false,
                          );
                        },
                        text: "Forgot Password?",
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
