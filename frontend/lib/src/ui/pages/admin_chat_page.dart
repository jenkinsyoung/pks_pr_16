import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr_12/src/ui/pages/chat_page.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = _getUserChats();
  }

  Stream<QuerySnapshot> _getUserChats() {
    String currentUserId = _firebaseAuth.currentUser!.uid;

    return _firestore.collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Нет доступных чатов.'));
          }

          var chatRooms = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              var chatRoom = chatRooms[index];
              var participants = List<String>.from(chatRoom['participants']);
              participants.remove(_firebaseAuth.currentUser!.uid); // Remove current user from the list of participants

              String otherUserId = participants.first; // Assuming there's only one other participant
              return ListTile(
                title: Text('Чат с пользователем: $otherUserId'),
                onTap: () {
                  // Navigate to chat page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverUserEmail: otherUserId,
                        receiverUserId: otherUserId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
