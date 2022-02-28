
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FeaturedProductsDashboard extends StatefulWidget {



  @override
  _FeaturedProductsDashboardState createState() => _FeaturedProductsDashboardState();
}

class _FeaturedProductsDashboardState extends State<FeaturedProductsDashboard> {

  User user = FirebaseAuth.instance.currentUser;
  List _order = [];

  void didChangeDependencies() {

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.selleruid', isEqualTo: user.uid)
        .where('collection', isEqualTo: 'Featured Products')
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
          Text('Featured Products', style: TextStyle(fontSize: 15, color: Colors.black),),
          _order.length != 0 ? Text('${_order.length}',style: TextStyle(fontSize: 15)) : Text('0'),
        ],
      ),
    );
  }
}