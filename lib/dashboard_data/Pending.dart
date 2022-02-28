
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Pending extends StatefulWidget {



  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {

  User user = FirebaseAuth.instance.currentUser;
  List _order = [];

  void didChangeDependencies() {

    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Pending')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _order.add(doc.id);
        });
      });
    });

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Pending', style: TextStyle(fontSize: 15, color: Colors.grey),),
          _order.length != 0 ? Text('${_order.length}',style: TextStyle(fontSize: 15)) : Text('0'),
        ],
      ),
    );
  }
}
