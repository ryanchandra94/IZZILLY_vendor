import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/add_product_screen.dart';
import 'package:vendor_izzilly/widget/publish_product.dart';
import 'package:vendor_izzilly/widget/unPublish_product.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Text('Product Screen'),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Text('20', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    ),
                    FlatButton.icon(
                        onPressed: (){
                          Navigator.pushNamed(context, AddNewProduct.id);
                        },
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.add, color: Colors.white,),
                        label: Text('Add New', style: TextStyle(color: Colors.white),))
                  ],
                ),
              ),
            ),
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Published'),
                  Tab(text: 'Not Published',)
                ]
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                    children: [
                      PublishProducts(),
                      UnPublishProducts(),
                    ]
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}
