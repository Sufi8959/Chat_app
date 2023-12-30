import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatMessageScreen extends StatelessWidget {
  const ChatMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUserId = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(left: 13, right: 13, bottom: 40),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final currentChatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = currentChatMessage['UserId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['UserId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: currentChatMessage['message'],
                isMe: authenticatedUserId.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: currentChatMessage['UserImage'],
                username: currentChatMessage['Username'],
                message: currentChatMessage['message'],
                isMe: authenticatedUserId.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
