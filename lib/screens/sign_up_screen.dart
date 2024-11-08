import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/routes/routes.dart';
import 'package:school_management/utils/dimensions.dart';

import '../utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

TextEditingController nameController = TextEditingController();
TextEditingController userController = TextEditingController();
TextEditingController cr8PassController = TextEditingController();
TextEditingController confPassController = TextEditingController();

bool visiblePass = true;

void viewPassword() {
  visiblePass = !visiblePass;
}

class _SignUpScreenState extends State<SignUpScreen> {
  //register method
  void registerUser() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) =>
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //make sure passwords match
    if (cr8PassController.text != confPassController.text) {
      //pop loading circle
      Navigator.pop(context);
      //show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords don’t match'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop further execution
    }
    //try creating user

    try {
      //try creating user
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: userController.text, password: cr8PassController.text);


      //create user documents and add to firestore
      createUserDocument(userCredential);


      //pop loading circle
      if(context.mounted)Navigator.pop(context);

      //display success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Successfully Created'),
          backgroundColor: AppColors.primaryColor,
          duration: Duration(milliseconds: 500),
        ),
      );

      Get.toNamed(AppRoutes.floatingMenu);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //display error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  //create user document and collect in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user !=null) {
      await FirebaseFirestore.instance.collection("Users").doc(
          userCredential.user!.email).set(
          {
            'email': userCredential.user!.email,
            'username': nameController.text
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            children: [
              SizedBox(height: Dimensions.height100 + Dimensions.height20),
              Text(
                'EduSoft',
                style: TextStyle(
                    fontSize: Dimensions.font30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor),
              ),
              SizedBox(height: Dimensions.height30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: TextStyle(
                        fontSize: Dimensions.font17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(height: Dimensions.height20),
                  //name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name(First name, Last Name)',
                        style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: Dimensions.height5),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Input Full Name',
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
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: Dimensions.width5 / Dimensions.width10,
                              color: AppColors.accentColor.withOpacity(0.2),
                            ),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  //username/email address
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Input Email Address',
                        style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: Dimensions.height5),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: userController,
                        decoration: InputDecoration(
                          hintText: 'Input Email Address',
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
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: Dimensions.width5 / Dimensions.width10,
                              color: AppColors.accentColor.withOpacity(0.2),
                            ),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  //cr8pass
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Password',
                        style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: Dimensions.height5),
                      TextField(
                        obscureText: visiblePass,
                        controller: cr8PassController,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                viewPassword();
                              });
                            },
                            child: Icon(
                              !visiblePass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.accentColor.withOpacity(0.5),
                            ),
                          ),
                          hintText: 'Create Password',
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
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: Dimensions.width5 / Dimensions.width10,
                              color: AppColors.accentColor.withOpacity(0.2),
                            ),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  //confPass
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                            fontSize: Dimensions.font13,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: Dimensions.height5),
                      TextField(
                        obscureText: visiblePass,
                        controller: confPassController,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                viewPassword();
                              });
                            },
                            child: Icon(
                              !visiblePass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.accentColor.withOpacity(0.5),
                            ),
                          ),
                          hintText: 'Confirm Password',
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
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: Dimensions.width5 / Dimensions.width10,
                              color: AppColors.accentColor.withOpacity(0.2),
                            ),
                            borderRadius:
                            BorderRadius.circular(Dimensions.radius10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height50),
                  //create btn
                  InkWell(
                    onTap: registerUser,
                    child: Container(
                      alignment: Alignment.center,
                      height: Dimensions.height50,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius:
                        BorderRadius.circular(Dimensions.radius10),
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: Dimensions.font18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  //login btn
                  InkWell(
                    onTap: () {
                      Get.offAndToNamed(AppRoutes.signInScreen);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Dimensions.height50,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        // color: AppColors.primaryColor,
                          borderRadius:
                          BorderRadius.circular(Dimensions.radius10),
                          border: Border.all(
                              width: Dimensions.width5 / Dimensions.width15,
                              color: AppColors.primaryColor)),
                      child: Text(
                        'Login Existing Account',
                        style: TextStyle(
                            color: AppColors.accentColor,
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w600),
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
