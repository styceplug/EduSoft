/*

This database stores posts that users have published in the app.
Its stored in a collection called 'Posts' in Firebase

Each Post contains;
-a message
- email or username
-timestamp

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_management/screens/sign_up_screen.dart';



class FirestoreDatabase {

  //get current user
  static User? getCurrentUser(){
    return FirebaseAuth.instance.currentUser;
  }


  //current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  //get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

//post a message
  Future<void> addPosts(String message) async {
    if(user != null){
      // Get the user document
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();

      // Retrieve the username if it exists
      final postUsername = userDoc.data()?['Username'] ?? 'Unknown User';

      // Add the post to Firestore
      await posts.add({
        'PostUsername': postUsername,
        'PostMessage': message,
        'TimeStamp': Timestamp.now()
      });
    }
  }

//read posts from firebase

  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
