import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices{
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');


  Future<void>updateOrderStatus(documentIn, status){
    var result = orders.doc(documentIn).update({
      'orderStatus' : status
    });

    return result;
  }


  Future<void> deleteOrder({id}){
    return orders.doc(id).delete();
  }
}