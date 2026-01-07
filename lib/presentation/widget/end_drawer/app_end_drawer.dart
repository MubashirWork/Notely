import 'package:flutter/material.dart';
import 'package:notely/core/constants/app_colors.dart';
import 'package:notely/core/data/database/constants/note/note.dart';
import 'package:notely/core/data/shared_preference/shared_pref_service.dart';
import 'package:notely/presentation/screens/auth/login_screen.dart';
import 'package:notely/presentation/screens/home/home_screen.dart';
import 'package:notely/presentation/screens/profile/profile_screen.dart';
import 'package:notely/presentation/widget/app_text.dart';
import 'package:notely/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menus.dart';

class AppEndDrawer extends StatefulWidget {
  const AppEndDrawer({super.key});

  @override
  State<AppEndDrawer> createState() => _AppEndDrawerState();
}

class _AppEndDrawerState extends State<AppEndDrawer> {
  int index = 0;

  List<Menus> menuItems = [
    Menus(title: 'Home', icon: Icons.home_outlined),
    Menus(title: 'Profile', icon: Icons.account_circle_outlined),
    Menus(title: 'Logout', icon: Icons.logout_outlined),
  ];

  List screens = [
    HomeScreen(username: Note.username),
    ProfileScreen(),
    LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.6,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.royalBlue),
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            child: DrawerHeader(
              margin: EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(data: 'Menu', color: AppColors.white, size: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.menu, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(4),
              itemCount: menuItems.length,
              itemBuilder: (context, i) {
                final item = menuItems[i];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minTileHeight: MediaQuery.of(context).size.height * 0.06,
                  onTap: () async {
                    setState(() {
                      index = i;
                    });
                    Navigator.pop(context);
                    switch (item.title) {
                      case 'Home':
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.home,
                          arguments: await SharedPrefService.getUsername(),
                          (routes) => false,
                        );
                        break;
                      case 'Profile':
                        Navigator.pushNamed(context, RouteNames.profile);
                        break;
                      case 'Logout':
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool(SharedPrefService.loginKey, false);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.login,
                          (route) => false,
                        );
                        return;
                    }
                  },
                  selected: index == i,
                  selectedTileColor: index == i
                      ? AppColors.lightGrayish
                      : Colors.transparent,
                  title: AppText(data: item.title, size: 16),
                  leading: Icon(
                    item.icon,
                    color: Colors.black.withValues(alpha: 0.7),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 6),
            ),
          ),
        ],
      ),
    );
  }
}
