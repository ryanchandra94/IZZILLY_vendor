
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/chat/chat_card.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';

class ChatRoomList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Chat',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            ],
          ),
          body: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _services.messages
                  .where('users', arrayContains: _services.user.uid)
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }

                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    return ChatCard(data);
                  }).toList(),
                );
              },
            ),
          )),
    );
  }
}
