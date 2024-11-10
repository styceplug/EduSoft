import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/dimensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  //current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;


  //future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {

    if(currentUser==null){
      return Center(child: Text('No user Logged in'),);
    }


    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: TextStyle(
              letterSpacing: 5,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.font22),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Dimensions.width20, vertical: Dimensions.height20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: getUserDetails(),
                builder: (context, snapshot) {
                  //loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
        
                  //error
                  else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
        
                  //data received
        
                  else if (snapshot.hasData) {
                    //extract data
                    Map<String, dynamic>? user = snapshot.data?.data();
                    if(user== null){
                      return Center(child: Text('No User Found'));
                    }
        
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //profile pic
        
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle),
                          padding: EdgeInsets.all(30),
                          child: Icon(
                            Icons.person,
                            size: Dimensions.iconSize30,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: Dimensions.height40),
        
                        //username
                        Text(
                          user!['username'],
                          style: TextStyle(
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w500),
                        ),
        
                        //email
                        Text(
                          user['email'],
                          style: TextStyle(
                              fontSize: Dimensions.font15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    );
                  } else {
                    return Text('No Data');
                  }
                },
              ),
              Column(
                children: [
                  SizedBox(height: Dimensions.height150),
                  //logout btn
                  InkWell(
                    onTap: logout,
                    child: Container(
                      alignment: Alignment.center,
                      height: Dimensions.height50,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: Dimensions.font18,
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