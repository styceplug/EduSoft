import 'package:flutter/material.dart';
import 'package:school_management/controllers/auth_controller.dart';
import 'package:school_management/database/firestore.dart';
import 'package:school_management/screens/message_screen.dart';
import 'package:school_management/services/chat_services.dart';
import 'package:school_management/services/firestore.dart';
import 'package:school_management/widgets/user_tile.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //chat & auth services
  final ChatService _chatService = ChatService();
  final AuthPage _authPage = AuthPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          'CHAT',
          style: TextStyle(
              letterSpacing: 5,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.font22),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
      ),
      body: _buildUserList(),
    );
  }

  //build a list of users except current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStreams(),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return const Text('Error');
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //debugging
          print("Snapshot Data: ${snapshot.data}");
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No Users Available'),
            );
          }

          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  //build individual list tile for user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    final currentUserEmail = FirestoreDatabase.getCurrentUser()?.email;
    final email = userData["email"] as String? ?? "Unknown User";
    final uid = userData["uid"] as String? ?? "NO ID";

    //debugging
    print("CurrentUserEmail: $currentUserEmail");
    print("User Data - Email: $email, UID: $uid");

    // display all users except current user
    if (email != currentUserEmail && email.isNotEmpty) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tap on a user -> message screen
          if (email != "Unknown User" && uid != "NO ID") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessageScreen(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                ),
              ),
            );
          } else {
            // Handle cases where email is not available
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User data is incomplete")),
            );
          }
        },
      );
    } else {
      // Return an empty container to satisfy the non-null return type requirement
      return const SizedBox.shrink(); // Invisible widget when no data
    }
  }
}