
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/chat/chat_screen.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';
import 'package:intl/intl.dart';




class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;
  ChatCard(this.chatData);
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  FirebaseServices _services = FirebaseServices();
  DocumentSnapshot doc;
  DocumentSnapshot custDoc;
  String _lastChatDate='';




  @override
  void initState() {
    _services
        .getProductDetail(widget.chatData['product']['productId'])
        .then((value) {
      setState(() {
        doc = value;
      });
    });
    _services.getCustomerDetail(widget.chatData['user']).then((result) {
      custDoc = result;
    });
    getChatTime();
    super.initState();
  }


  getChatTime() {
    var _date = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));
    var _today = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));
    if(_date==_today){
      if(mounted){
        setState(() {
          _lastChatDate = 'Today';
        });
      }else{
        if(mounted){
          setState(() {
            _lastChatDate = _date.toString();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return doc == null
        ? Container(
      child: Center(
        child: Text('No Chat'),
      ),
    )
        : Container(
      child: Stack(
        children: [
          SizedBox(height: 10,),
          if(custDoc!=null)
          ListTile(
            onTap: (){
              _services.messages.doc(widget.chatData['chatRoomId']).update({
                'vendor_read' : 'true',
              });
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId: widget.chatData['chatRoomId'], doc: custDoc,)));
            },
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

            title: custDoc != null ? Text(custDoc['name'], style: TextStyle(fontWeight: FontWeight.bold),) : Text(''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.chatData['lastChat'] != null)
                  Text(
                    widget.chatData['lastChat'],
                    maxLines: 1,
                    style: TextStyle(fontSize: 10),
                  )
              ],
            ),
            /*trailing: IconButton(
                    icon: Icon(Icons.more_vert_sharp),
                    onPressed: () {},
                  ),*/

          ),
          Positioned(
            right: 10.0,
            top: 5.0,
            child: Text(_lastChatDate),
          )
        ],
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
    );
  }
}
