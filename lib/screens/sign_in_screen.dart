import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/routes/routes.dart';
import 'package:school_management/utils/app_constants.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/dimensions.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool visiblePass = true;

  void viewPass() {
    setState(() {
      visiblePass = !visiblePass;
    });
  }

  //login method
  void login() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //try signIn


    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: userController.text, password: passController.text);

      if(context.mounted) Navigator.pop(context);
    }
    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height50 * 2),
              Text(
                'EduSoft',
                style: TextStyle(
                    fontSize: Dimensions.font30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor),
              ),
              Container(
                height: Dimensions.height70 * 3.5,
                width: Dimensions.width70 * 3.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppConstants.getPngAsset('login_image')),
                  ),
                ),
              ),
              TextField(
                controller: userController,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Input Username',
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.accentColor.withOpacity(0.4),
                  ),
                  hintText: 'Input Student Login',
                  hintStyle: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.accentColor.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: Dimensions.width5 / Dimensions.width10,
                      color: AppColors.accentColor.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: Dimensions.width5 / Dimensions.width10,
                      color: AppColors.accentColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              TextField(
                controller: passController,
                obscureText: !visiblePass,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Input Password',
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.accentColor.withOpacity(0.4),
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        viewPass();
                      });
                    },
                    child: Icon(
                      visiblePass
                          ? CupertinoIcons.eye_fill
                          : CupertinoIcons.eye_slash_fill,
                      color: AppColors.accentColor.withOpacity(0.8),
                    ),
                  ),
                  hintText: 'Input Student Password',
                  hintStyle: TextStyle(
                    fontSize: Dimensions.font14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.accentColor.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: Dimensions.width5 / Dimensions.width10,
                      color: AppColors.accentColor.withOpacity(0.4),
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: Dimensions.width5 / Dimensions.width10,
                      color: AppColors.accentColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height5),
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    'Forgotten Password?',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: Dimensions.font13),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              InkWell(
                onTap: login,
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),
              InkWell(
                onTap: () {
                  Get.offAllNamed(AppRoutes.signUpScreen);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: Dimensions.width5 / Dimensions.width15,
                        color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  child: Text(
                    'Create New Account',
                    style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w600),
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
