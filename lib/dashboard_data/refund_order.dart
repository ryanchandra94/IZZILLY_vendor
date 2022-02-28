
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RefundOrder extends StatefulWidget {



  @override
  _RefundOrderState createState() => _RefundOrderState();
}

class _RefundOrderState extends State<RefundOrder> {

  User user = FirebaseAuth.instance.currentUser;
  List _order = [];

  void didChangeDependencies() {

    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Refund')
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
          Text('Refunded', style: TextStyle(fontSize: 15, color: Colors.orange),),
          _order.length != 0 ? Text('${_order.length}',style: TextStyle(fontSize: 15)) : Text('0'),
        ],
      ),
    );
  }
}