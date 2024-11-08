import 'package:flutter/material.dart';
import 'package:school_management/controllers/auth_controller.dart';
import 'package:school_management/services/chat_services.dart';

class MessageScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;


  const MessageScreen({super.key, required this.receiverEmail, required this.receiverID});



  @override
  State<MessageScreen> createState() => _MessageScreenState();
}



class _MessageScreenState extends State<MessageScreen> {


  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final ChatService _chatService = ChatService();
  final AuthPage _authPage = AuthPage();

  //send message
  void sendMessage() async {
    //check empty textfield
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
    );
  }
}
