import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/provider/order_provider.dart';
import 'package:vendor_izzilly/service/order_service.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = ['All Orders', 'Ordered', 'Accepted', 'Rejected', 'Done'];

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: Colors.lightBlueAccent,
              child: Center(
                  child: Text(
                'My Orders',
                style: TextStyle(color: Colors.white),
              )),
            ),
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                choiceStyle: C2ChoiceStyle(
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                value: tag,
                onChanged: (val) {
                  if (val == 0) {
                    _orderProvider.status = null;
                  }
                  setState(() => {
                        tag = val,
                        if (tag > 0) {_orderProvider.filterOrder(options[val])}
                      });
                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderServices.orders
                    .where('seller.sellerId', isEqualTo: user.uid)
                    .where('orderStatus',
                        isEqualTo: tag > 0 ? _orderProvider.status : null)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data.size == 0) {
                    return Center(
                      child: Text(
                          tag > 0 ? 'No ${options[tag]} order' : 'No Orders'),
                    );
                  }

                  return Expanded(
                    child: new ListView(
                      padding: EdgeInsets.zero,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return new Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                  horizontalTitleGap: 0,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 14,
                                    child: Icon(
                                      CupertinoIcons.square_list,
                                      size:25,
                                      color:
                                          document['orderStatus'] == 'Rejected'
                                              ? Colors.red : document['orderStatus'] == 'Accepted' ? Colors.lightBlueAccent
                                              : document['orderStatus'] == 'Done' ? Colors.grey : Colors.black,
                                    ),
                                  ),
                                  title: Text(
                                    document['orderStatus'],
                                    style: TextStyle(
                                        fontSize:20,
                                        color: document['orderStatus'] == 'Rejected'
                                            ? Colors.red : document['orderStatus'] == 'Accepted' ? Colors.lightBlueAccent
                                            : document['orderStatus'] == 'Done' ? Colors.grey : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'On ${DateFormat.yMMMd().format(DateTime.parse(document['timestamp']))}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Payment Type: ${document['cod'] == true ? 'Cash on Delivery' : 'Paid Online'}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Amount:  \$ ${document['total'].toStringAsFixed(0)}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              ExpansionTile(
                                title: Text(
                                  'Order Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  'View Order Details',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.network(
                                              document['products'][index]
                                                  ['productImage']),
                                        ),
                                        title: Text(document['products'][index]
                                            ['productName']),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '\$${document['products'][index]['price']}'),
                                            Text(document['products'][index]['schedule'])
                                          ],
                                        )
                                      );
                                    },
                                    itemCount: document['products'].length,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 8, bottom: 8),
                                    child: Card(
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Seller : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  document['seller']
                                                      ['shopName'],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (int.parse(
                                                    document['discount']) >
                                                0)
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Discount : ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '\$${document['discount']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 15),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    if (document[
                                                            'discountCode'] !=
                                                        null)
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Discount Code : ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            '${document['discountCode']}',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 15),
                                                          )
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 3,
                                color: Colors.grey,
                              ),
                              document['orderStatus'] == 'Accepted' ? Container(
                                color: Colors.grey[300],
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                                  child: FlatButton(
                                    onPressed: () {
                                      showDialog('Finish', 'Done', document.id);
                                    },
                                    child: Text(
                                      'Finish',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ) : document['orderStatus'] == 'Rejected'  ? Container(

                              ) : document['orderStatus'] == 'Done' ? Container(

                              ):
                              Container(
                                color: Colors.grey[300],
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FlatButton(
                                          onPressed: () {
                                            showDialog('Accept Order', 'Accepted', document.id);
                                          },
                                          child: Text(
                                            'Accept',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FlatButton(
                                          onPressed: () {
                                            showDialog('Reject Order', 'Rejected', document.id);
                                          },
                                          child: Text(
                                            'Reject',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 3,
                                color: Colors.grey,
                              ),
                              Container(
                                child: Column(),
                              ),
                              Divider(
                                height: 3,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  showDialog(title, status, documentId) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(
                'Are you sure?'),
            actions: [
              FlatButton(
                  onPressed: (){
                    EasyLoading.show(status: 'updating status');
                    status == 'Accepted' ? _orderServices.updateOrderStatus(documentId, status).then((value) {
                        EasyLoading.showSuccess('Updated Successfully');
                    }) :  _orderServices.updateOrderStatus(documentId, status).then((value) {
                      EasyLoading.showSuccess('Updated Successfully');
                    });
                    Navigator.pop(context);
                  },
                  child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor),)
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: Theme.of(context).primaryColor),)
              ),
            ],
          );
        });
  }

  showDialogDelete(title, documentId){
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(
                'Are you sure?'),
            actions: [
              FlatButton(
                  onPressed: (){
                    EasyLoading.show(status: 'Deleting Order');
                     _orderServices.deleteOrder(id: documentId).then((value) {
                      EasyLoading.showSuccess('Deleted Successfully');
                    });
                    Navigator.pop(context);
                  },
                  child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor),)
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: Theme.of(context).primaryColor),)
              ),
            ],
          );
        });
  }



}
