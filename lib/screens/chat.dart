import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future pushNotifications() async {
    final fcmToken = FirebaseMessaging.instance;
    fcmToken.requestPermission();

    fcmToken.subscribeToTopic('chat');
    // fcmToken.getToken();
  }

  @override
  void initState() {
    super.initState();
    pushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              firebase.signOut();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          title: const Text('Chat App'),
        ),
        body: const Column(
          children: [Expanded(child: ChatMessageScreen()), NewMessage()],
        ));
  }
}
