import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/constants/app_strings.dart';
import 'package:notely/core/data/shared_preference/shared_pref_service.dart';
import 'package:notely/presentation/screens/profile/widget/profile_card.dart';
import 'package:notely/presentation/widget/app_bar.dart';
import 'package:notely/presentation/widget/app_text.dart';
import 'package:notely/routes/route_names.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  var username = '';
  var appVersion = '';

  @override
  void initState() {
    super.initState();
    passData();
    loadAppVersion();
  }

  Future loadAppVersion() async {
    final version = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "${version.appName} ${version.version}";
    });
  }

  Future passData() async {
    final getUsername = await SharedPrefService.getUsername();
    final getFullName = await SharedPrefService.getFullName();

    if (getUsername != null && getFullName != null) {
      setState(() {
        username = getUsername;
        fullName = getFullName;
      });
    }
  }

  Future logoutAndNavigate(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool(SharedPrefService.loginKey, false);
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  String initial(String content) {
    final fullName = content.trim();
    if (fullName.isEmpty) {
      return '';
    }
    final split = fullName.split(' ');
    if (split.length > 1) {
      return "${split[0][0]}${split[1][0]}".toUpperCase();
    } else {
      return split[0][0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ProfileCard(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(data: appVersion),
              const SizedBox(height: 4),
              AppText(data: AppStrings.footerText, size: 12),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.lightBluishGrey,
      appBar: Appbar(
        iconClick: () {
          Navigator.pop(context);
        },
        icon: Icons.arrow_back,
        titleText: 'Profile',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.grawish, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.royalBlue,
                        child: AppText(
                          data: initial(fullName),
                          size: 28,
                          weight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppText(data: fullName, size: 16, weight: FontWeight.w500),
                    const SizedBox(height: 8),
                    AppText(data: '@$username'),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppText(data: AppStrings.accInfoText),
              ),
              const SizedBox(height: 8),
              ProfileCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(context, RouteNames.editFullName);
                          passData();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(data: 'Full Name'),
                            Row(
                              children: [
                                AppText(data: fullName),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(data: 'Username'),
                          AppText(data: username),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppText(data: AppStrings.securityText),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  logoutAndNavigate(RouteNames.forgot);
                },
                child: ProfileCard(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: AppText(data: 'Change Password'),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  logoutAndNavigate(RouteNames.login);
                },
                child: ProfileCard(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: AppText(
                          data: 'Log Out',
                          color: Colors.red,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
