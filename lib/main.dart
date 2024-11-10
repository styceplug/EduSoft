import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


  // Run the one-time UID update script
  await updateUidForExistingUsers();

  runApp(const MyApp());
}

// Function to update UID for existing users
Future<void> updateUidForExistingUsers() async {
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("Users");

  // Fetch all users from Firestore
  QuerySnapshot snapshot = await usersCollection.get();

  for (QueryDocumentSnapshot doc in snapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Check if `uid` field is missing
    if (!data.containsKey("uid")) {
      String email = data["email"] ?? '';  // Assign email here for reference in catch block
      try {
        // Verify user existence by email
        User? user = (await FirebaseAuth.instance.fetchSignInMethodsForEmail(email)).isNotEmpty
            ? FirebaseAuth.instance.currentUser
            : null;

        if (user != null) {
          // Update document in Firestore with the UID
          await usersCollection.doc(doc.id).update({'uid': user.uid});
          print("Updated UID for user with email: $email");
        }
      } catch (e) {
        print("Error updating UID for user with email: $email - $e");
      }
    }
  }
  print("UID update complete for all users.");
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
