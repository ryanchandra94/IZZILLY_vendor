



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';
import 'package:intl/intl.dart';

class ChatStream extends StatefulWidget {
  final String chatRoomId;
  final DocumentSnapshot doc;
  ChatStream({this.chatRoomId, this.doc});

  @override
  _ChatStreamState createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  Stream chatMessageStream;
  User user = FirebaseAuth.instance.currentUser;
  FirebaseServices _service = FirebaseServices();

  var chatMessageController = TextEditingController();
  DocumentSnapshot chatDoc;
  DocumentSnapshot custDoc;


  @override
  void initState() {
    _service.getChat(widget.chatRoomId).then((value) {
      if (mounted) {
        setState(() {
          chatMessageStream = value;
        });
      }
    });

    _service.messages.doc(widget.chatRoomId).get().then((value) => {
      if (mounted)
        {
          setState(() {
            chatDoc = value;
            _service.getCustomerDetail(value['user']).then((result) {
              if(mounted){
                setState(() {
                  custDoc = result;
                });
              }
            });
          })
        }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return snapshot.hasData
            ? Column(
          children: [
            custDoc != null ?
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    radius: 38,
                    child: Icon(
                      CupertinoIcons.person_alt,
                      color: Colors.lightBlueAccent,
                      size: 60,
                    ),
                  ),
                ),
                title: Text(custDoc['name']),
                /*trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("\$" +
                              chatDoc['product']['price'].toStringAsFixed(0)),
                          SizedBox(
                            width: 100,
                          )
                        ],
                      ),*/
              ) : Container(),
            Expanded(
              child: Container(
                color: Colors.grey.shade300,
                child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      String sentBy = snapshot.data.docs[index]['sentBy'];
                      String me = user.uid;
                      String lastChatDate;
                      var _date = DateFormat.yMMMd().format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              snapshot.data.docs[index]['time']));
                      var _today = DateFormat.yMMMd().format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              DateTime.now().microsecondsSinceEpoch));

                      if (_date == _today) {
                        lastChatDate = DateFormat('hh:mm').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                snapshot.data.docs[index]['time']));
                      }else{
                        lastChatDate = _date.toString();
                      }
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ChatBubble(
                                alignment: sentBy==me ? Alignment.centerRight : Alignment.centerLeft,
                                backGroundColor: sentBy == me
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * .8,
                                  ),
                                  child: Text(
                                    snapshot.data.docs[index]['message'],
                                    style: TextStyle(
                                        color: sentBy == me
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                clipper: ChatBubbleClipper2(
                                    type: sentBy == me ? BubbleType.sendBubble : BubbleType.receiverBubble),
                              ),
                              SizedBox(height: 3,),
                              Align(
                                  alignment: sentBy==me ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Text(lastChatDate,style: TextStyle(fontSize: 12),)),

                            ],
                          )
                      );
                    }),
              ),
            )
          ],
        )
            : Container();
      },
    );
  }
}
