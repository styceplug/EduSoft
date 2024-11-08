import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:school_management/services/firestore.dart';
import 'package:school_management/utils/colors.dart';
import 'package:school_management/utils/dimensions.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID, String? title, String? note}) {
    titleController.text = title ?? '';
    textController.text = note ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: Dimensions.height100 * 2,
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: Dimensions.height15),
              Text(
                docID == null ? 'Create A New Note' : 'Update Existing Note',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: Dimensions.font16),
              ),
              SizedBox(height: Dimensions.height15),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Input Note Title',
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
              SizedBox(height: Dimensions.height15),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Input Note Description',
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
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              //add a new note
              if (docID == null) {
                firestoreService.addNote(
                    titleController.text, textController.text);
              } else {
                //update existing note
                firestoreService.updateNotes(
                    docID, textController.text, titleController.text);
              }
              //clear the text field
              titleController.clear();
              textController.clear();
              //return to screen
              Navigator.pop(context);
            },
            child: Text(docID == null ? 'Add Note' : 'Update Note'),
          ),
        ],
      ),
    );
  }


  void logout(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Create Note'),
        titleTextStyle: TextStyle(
            fontSize: Dimensions.font20,
            color: AppColors.accentColor,
            fontWeight: FontWeight.w600),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: logout,
            child: Icon(Iconsax.logout),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: Color(0XFFF6F6F6),
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width10, vertical: Dimensions.height20),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            //get all if there is data
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;
              //display as list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteTitle = data['title']?? 'No Title';
                  String noteText = data['note']?? 'No Description';

                  return Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.height10),
                    child: Container(
                      height: Dimensions.height100,
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.width20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.accentColor.withOpacity(0.1),
                              offset: const Offset(2, 2),
                              blurRadius: 5),
                        ],
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                noteTitle,
                                style: TextStyle(
                                    fontSize: Dimensions.font18,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: Dimensions.height10),
                              Text(noteText),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => openNoteBox(docID: docID),
                                child: const Icon(Icons.settings),
                              ),
                              SizedBox(width: Dimensions.width15),
                              InkWell(
                                onTap: () =>
                                    firestoreService.deleteNotes(docID),
                                child: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No Notes!!'));
            }
          },
        ),
      ),
    );
  }
}
