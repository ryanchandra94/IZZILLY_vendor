import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/chat/chat_stream.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';




class ChatScreen extends StatefulWidget {

  static const String id = 'chat-screen';
  final String chatRoomId;
  final DocumentSnapshot doc;
  ChatScreen({this.chatRoomId, this.doc});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Stream chatMessageStream;
  User user = FirebaseAuth.instance.currentUser;
  FirebaseServices _service = FirebaseServices();
  var chatMessageController = TextEditingController();
  bool _send = false;


  sendMessage(){
    if(chatMessageController.text.isNotEmpty){
      FocusScope.of(context).unfocus();
      Map<String, dynamic> message = {
        'message' : chatMessageController.text,
        'sentBy' : user.uid,
        'time' : DateTime.now().microsecondsSinceEpoch,
      };

      _service.createChat(widget.chatRoomId, message);

      chatMessageController.clear();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.call)),
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_vert_sharp)),
        ],
        shape: Border(bottom: BorderSide(color:Colors.grey )),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatStream(chatRoomId: widget.chatRoomId,doc: widget.doc,),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:Border(
                        top: BorderSide(color: Colors.grey.shade800)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                      Expanded(
                        child: TextField(
                          controller: chatMessageController,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                            hintText: 'Type Message',
                            hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            if(value.isNotEmpty){
                              if(mounted){
                                setState(() {
                                  _send = true;
                                });
                              }else{
                                _send = false;
                              }
                            }
                          },
                          onSubmitted: (value){
                            if(value.length>0){
                              sendMessage();
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: _send,
                        child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: sendMessage
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
