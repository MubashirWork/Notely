import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/data/database/dao/user_dao/user_dao.dart';
import 'package:notely/core/data/shared_preference/shared_pref_service.dart';
import 'package:notely/core/service/snack_bar_service.dart';
import 'package:notely/presentation/widget/app_bar.dart';
import 'package:notely/presentation/widget/app_button.dart';
import 'package:notely/presentation/widget/app_text.dart';
import 'package:notely/presentation/widget/app_text_field.dart';
import 'package:notely/presentation/widget/loading_indicator.dart';
import 'package:notely/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFullName extends StatefulWidget {
  const EditFullName({super.key});

  @override
  State<EditFullName> createState() => _EditFullNameState();
}

class _EditFullNameState extends State<EditFullName> {
  TextEditingController fullNameController = TextEditingController();
  bool isLoadingLogin = false;
  var username = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    final getUsername = await SharedPrefService.getUsername();
    final getFullName = await SharedPrefService.getFullName();

    if (getUsername != null && getFullName != null) {
      setState(() {
        username = getUsername;
        fullNameController.text = getFullName;
      });
    }
  }

  Future updateFullName() async {
    final newName = fullNameController.text.trim();

    if(newName.isEmpty) {
      SnackBarService.show('Name cannot be empty');
      return;
    }

    setState(() {
      isLoadingLogin = true;
    });

    final update = await UserDao.instance.updateFullName(
      username: username,
      newFullName: newName,
    );

    await Future.delayed(Duration(milliseconds: 300)); 

    setState(() {
      isLoadingLogin = false;
    });

    if (update) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedPrefService.fullName, newName);
      prefs.setBool(SharedPrefService.loginKey, false);
      SnackBarService.show('Name changed');
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (route) => false);
    } else {
      SnackBarService.show('Something went wrong');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBluishGrey,
      appBar: Appbar(
        icon: Icons.arrow_back,
        iconClick: () {
          Navigator.pop(context);
        },
        titleText: 'Edit Full Name',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              AppTextField(
                borderColor: AppColors.grawish,
                controller: fullNameController,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppButton(
                      backgroundColor: AppColors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: AppText(
                        data: 'Cancel',
                        color: AppColors.royalBlue,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      borderColor: AppColors.mediumBlue,
                      onPressed: updateFullName,
                      child: isLoadingLogin
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              data: 'Save',
                              color: AppColors.white,
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
      ),
    );
  }
}
