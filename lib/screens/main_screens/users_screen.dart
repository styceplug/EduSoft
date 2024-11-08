import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          'USERS',
          style: TextStyle(
            letterSpacing: 5,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.font22),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context, snapshot) {
            //any errors
            if (snapshot.hasError) {
              return const SnackBar(
                content: Text('Something went wrong!!'),
                backgroundColor: AppColors.accentColor,
              );
            }
            //show loading circle
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null) {
              return Column(
                children: [
                  Container(
                    height: Dimensions.height70,
                    width: Dimensions.width70,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/target.gif'),
                      ),
                    ),
                  ),
                  const Text('No Registered User'),
                ],
              );
            }

            //get all users

            final users = snapshot.data!.docs;

            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return ListTile(
                    title: Text(
                      user['username'],
                      style: TextStyle(
                          fontSize: Dimensions.font18,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      user['email'],
                      style: TextStyle(
                        fontSize: Dimensions.font14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
