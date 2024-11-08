import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/routes/routes.dart';
import 'package:school_management/screens/sign_in_screen.dart';
import 'package:school_management/widgets/menu_bar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const FloatingBar();
            } else {
              return const SignInScreen();
            }
          }),
    );
  }
}
