


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices{

  User user = FirebaseAuth.instance.currentUser;
  CollectionReference category = FirebaseFirestore.instance.collection('category');
  CollectionReference product = FirebaseFirestore.instance.collection('products');
  CollectionReference vendorBanner = FirebaseFirestore.instance.collection('vendorBanner');
  CollectionReference coupons = FirebaseFirestore.instance.collection('coupons');
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');
  CollectionReference customer = FirebaseFirestore.instance.collection('customers');

  Future<void> publishProduct({id}){
    return product.doc(id).update({
      'published' : true,
    });
  }

  Future<void> unPublishProduct({id}){
    return product.doc(id).update({
      'published' : false,
    });
  }

  Future<void> delelteProduct({id}){
    return product.doc(id).delete();
  }

  Future<void> saveBanner(url){
    return vendorBanner.add({
      'imageUrl': url,
      'selleruid': user.uid
    });
  }

  createChat(String chatRoomId, message){
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e){
      print(e.toString());
    });
    messages.doc(chatRoomId).update({
      'lastChat':message['message'],
      'lastChatTime' : message['time'],
      'user_read': false,
      'vendor_read': false,
    });

  }

  getChat(chatRoomId)async{
    return messages.doc(chatRoomId).collection('chats').orderBy('time').snapshots();
  }

  Future<DocumentSnapshot> getProductDetail(id) async{
    DocumentSnapshot doc = await product.doc(id).get();
    return doc;
  }

  Future<DocumentSnapshot> getCustomerDetail(id) async{
    DocumentSnapshot doc = await customer.doc(id).get();
    return doc;
  }

  Future<void> delelteBanner({id}){
    return vendorBanner.doc(id).delete();
  }

  Future<void>saveCoupon({document,title, discountRate, expiry, details, activate}){
    if(document==null){
      return coupons.doc(title).set({
        'title' : title,
        'discountRate' : discountRate,
        'Expiry' : expiry,
        'details' : details,
        'activate' : activate,
        'sellerId' : user.uid,
      });
    }

    return coupons.doc(title).update({
      'title' : title,
      'discountRate' : discountRate,
      'Expiry' : expiry,
      'details' : details,
      'activate' : activate,
      'sellerId' : user.uid,
    });

  }
}