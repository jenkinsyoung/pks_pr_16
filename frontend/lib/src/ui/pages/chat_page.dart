import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/resources/chat_service.dart';
import 'package:pr_12/src/ui/components/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserId});
  final String receiverUserEmail;
  final String receiverUserId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserId, _messageController.text);

      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),

          _buildMessageInput(),

        ],
      )
    );
  }

  Widget _buildMessageList(){
    return StreamBuilder(
        stream: _chatService.getMessages(
        widget.receiverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting){
            return const Text('Loading..');
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Нет доступных сообщений.'));
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(

      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 2,),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }


  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Текст сообщения'),
                obscureText: false,
              ),
            ),
        ),
        IconButton(
        onPressed: sendMessage,
        icon: const Icon(
          Icons.arrow_upward_rounded,
          size: 30,
          color: Color.fromRGBO(0, 0, 0, 1,)
          ),
        )
      ],
    );
  }


}
