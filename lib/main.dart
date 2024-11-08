import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_management/controllers/auth_controller.dart';
// import 'package:school_management/helpers/dependencies.dart' as dep;
import 'package:school_management/routes/routes.dart';
import 'package:school_management/utils/colors.dart';
import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Management',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
      ),
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.authPage,
    );
  }
}
