import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:school_management/database/firestore.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//firestore access
final FirestoreDatabase database = FirestoreDatabase();

//text controller
TextEditingController newPostController = TextEditingController();

//post message

class _HomeScreenState extends State<HomeScreen> {
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.primaryColor);
  }

  void postMessage() {
    //only post when field == not empty
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPosts(message);
    }

    //clear the controller
    newPostController.clear();

    //alert for successful post
    showToast('Successfully Posted to board');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'H O M E',
          style: TextStyle(
              letterSpacing: 2,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: Dimensions.font22),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Dimensions.height20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newPostController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Say Something....',
                        hintStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.accentColor.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.accentColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radius20),
                            bottomLeft: Radius.circular(Dimensions.radius20),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.accentColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radius20),
                            bottomLeft: Radius.circular(Dimensions.radius20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.accentColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radius20),
                            bottomLeft: Radius.circular(Dimensions.radius20),
                          ),
                        )),
                  ),
                ),
                InkWell(
                  onTap: postMessage,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width10,
                        vertical: Dimensions.height18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dimensions.radius20),
                        bottomRight: Radius.circular(Dimensions.radius20),
                      ),
                    ),
                    child: Text(
                      'Create Post',
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimensions.font15),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            // Posts
            StreamBuilder(
                stream: database.getPostsStream(),
                builder: (context, snapshot) {
                  //show loading circle
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //get all posts
                  final posts = snapshot.data!.docs;

                  //no data?
                  if (snapshot.data == null || posts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.height20),
                        child: const Text('No Posts... Add Something to Board'),
                      ),
                    );
                  }

                  //return as a list
                  return Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        //get each individual posts
                        final post = posts[index];
                        //get data from each post
                        String message = post['PostMessage'];
                        String userEmail = post['Username'];
                        Timestamp timestamp = post['TimeStamp'];

                        //return as list tile
                        return Padding(
                          padding: EdgeInsets.only(
                              // left: Dimensions.width10,
                              bottom: Dimensions.height10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius10),
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.accentColor.withOpacity(0.06),
                                    offset: Offset(4, 2),
                                    blurRadius: Dimensions.radius5,
                                    spreadRadius: 0
                                  ),
                                ]),
                            child: ListTile(
                              title: Text(
                                message,
                                style: TextStyle(
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: Text(
                                userEmail,
                                style: TextStyle(
                                  fontSize: Dimensions.font12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
