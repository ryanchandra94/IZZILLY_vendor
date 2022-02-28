
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/provider/dashboard_provider.dart';
import 'package:vendor_izzilly/provider/order_provider.dart';


class OrderComplete extends StatefulWidget {
  
  

  @override
  _OrderCompleteState createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {

  User user = FirebaseAuth.instance.currentUser;
  List _order = [];


  void didChangeDependencies() {
    var _dash = Provider.of<DashboardProvider>(context);
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Done')
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
          Text('Completed', style: TextStyle(fontSize: 15, color: Colors.green),),
        _order.length != 0 ? Text('${_order.length}',style: TextStyle(fontSize: 15)) : Text('0'),
        ],
      ),
    );
  }
}
