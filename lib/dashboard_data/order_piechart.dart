import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class OrderChart extends StatefulWidget {



  @override
  _OrderChartState createState() => _OrderChartState();
}

class _OrderChartState extends State<OrderChart> {

  User user = FirebaseAuth.instance.currentUser;
  List _completeOrder = [];
  List _pendingOrder = [];
  List _processOrder = [];
  List _cancelOrder = [];
  List _refund = [];
  List _onHold = [];
  List _order = [];
  int touchedIndex = -1;

  void didChangeDependencies() {

    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _order.add(doc.id);
        });
      });
    });

    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Done')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _completeOrder.add(doc.id);
        });
      });
    });
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Pending')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _pendingOrder.add(doc.id);
        });
      });
    });
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Ordered')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _processOrder.add(doc.id);
        });
      });
    });
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Rejected')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _cancelOrder.add(doc.id);
        });
      });
    });
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Refunded')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _refund.add(doc.id);
        });
      });
    });
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'On Hold')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _onHold.add(doc.id);
        });
      });
    });

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return _order.length == 0 ? Container() : SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.green,
                value: double.parse(_completeOrder.length.toString()),
              title: _completeOrder.length.toString(),
                titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),

            ),
            PieChartSectionData(
              color: Colors.grey,
              value: double.parse(_pendingOrder.length.toString()),
              title: _pendingOrder.length.toString(),
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

            ),
            PieChartSectionData(
              color: Colors.blue,
              value: double.parse(_processOrder.length.toString()),
              title: _processOrder.length.toString(),
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

            ),
            PieChartSectionData(
              color: Colors.red,
              value: double.parse(_cancelOrder.length.toString()),
              title: _cancelOrder.length.toString(),
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

            ),
            PieChartSectionData(
              color: Colors.orange,
              value: double.parse(_refund.length.toString()),
              title: _refund.length.toString(),
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

            ),
            PieChartSectionData(
              color: Colors.brown,
              value: double.parse(_onHold.length.toString()),
              title: _onHold.length.toString(),
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),

            ),
          ]
        )
      ),
    );

  }
  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: double.parse(_completeOrder.length.toString()),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )
          );
        case 1:
          return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: double.parse(_completeOrder.length.toString()),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )
          );
        case 2:
          return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: double.parse(_completeOrder.length.toString()),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )
          );
        case 3:
          return PieChartSectionData(
              color: const Color(0xff0293ee),
              value: double.parse(_completeOrder.length.toString()),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )
          );
        default:
          throw Error();
      }
    });
  }
}