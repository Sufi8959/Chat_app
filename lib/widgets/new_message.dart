import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var messageController = TextEditingController();
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = messageController.text;

    if (enteredMessage.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    messageController.clear();

    final currentUser = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    // store in firebase
    FirebaseFirestore.instance.collection('chat').add({
      'message': enteredMessage,
      'time': Timestamp.now(),
      'Username': userData.data()!['Username'],
      'UserId': currentUser.uid,
      'UserImage': userData.data()!['imageUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              enableSuggestions: true,
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Type a message'),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send_sharp),
          )
        ],
      ),
    );
  }
}
