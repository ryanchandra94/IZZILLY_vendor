import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/Screen/home_screen.dart';
import 'package:vendor_izzilly/dashboard_data/Pending.dart';
import 'package:vendor_izzilly/dashboard_data/Processing.dart';
import 'package:vendor_izzilly/dashboard_data/cancel_order.dart';
import 'package:vendor_izzilly/dashboard_data/onhold_order.dart';
import 'package:vendor_izzilly/dashboard_data/order_complete.dart';
import 'package:vendor_izzilly/dashboard_data/order_piechart.dart';
import 'package:vendor_izzilly/dashboard_data/product_data/Featured_product.dart';
import 'package:vendor_izzilly/dashboard_data/product_data/best_selling.dart';
import 'package:vendor_izzilly/dashboard_data/product_data/recently_added.dart';
import 'package:vendor_izzilly/dashboard_data/refund_order.dart';
import 'package:vendor_izzilly/provider/dashboard_provider.dart';
import 'package:vendor_izzilly/service/order_service.dart';
import 'package:vendor_izzilly/widget/appbar.dart';
import 'package:vendor_izzilly/widget/drawer_menu_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  User user = FirebaseAuth.instance.currentUser;
  List _order = [];
  List _product = [];


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
        .collection('products')
        .where('seller.selleruid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _product.add(doc.id);
        });
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _dash = Provider.of<DashboardProvider>(context);
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Orders detail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OrderChart(),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart),
                                SizedBox(width: 5,),
                                Container(
                                  child: Text('Orders',style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20
                                  ),),
                                  ),
                              ],
                            ),
                          ),
                          Divider(thickness: 2, color: Colors.grey,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total', style: TextStyle(fontSize: 15),),
                                Text(_order.length.toString(),style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OrderComplete(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Pending(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProcessingOrder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CancelOrder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RefundOrder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OnHoldOrder(),
                          ),

                        ],
                      ),

                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag),
                              SizedBox(width: 5,),
                              Container(
                                child: Text('Products',style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20
                                ),),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 2, color: Colors.grey,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total', style: TextStyle(fontSize: 15),),
                              Text(_product.length.toString(),style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FeaturedProductsDashboard(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RecentlyAddedProducts(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BestSellingDashboard(),
                        ),


                      ],
                    ),

                  ),


                ],
              ),
            ),
          )
      ),
    );
  }
}
