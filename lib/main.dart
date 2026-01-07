import 'package:flutter/material.dart';
import 'package:notely/core/service/snack_bar_service.dart';
import 'package:notely/routes/app_routes.dart';
import 'package:notely/routes/route_names.dart';

void main() {
  runApp(const Notely());
}

class Notely extends StatelessWidget {
  const Notely({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: SnackBarService.messageKey,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
