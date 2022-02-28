import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory;
  String selectedSubCategory;
  File image;
  String pickerError;
  String shopName;
  String productUrl;

  selectCategory(selected) {
    this.selectedCategory = selected;
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName) {
    this.shopName = shopName;
    notifyListeners();
  }

  resetProvider(){
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.image = null;
    this.productUrl = null;
    notifyListeners();
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
    } else {
      this.pickerError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/${this.shopName}$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}$productName$timeStamp')
        .getDownloadURL();
    this.productUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  alertDialog({context, title, content}) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }



  Future<void> saveProductDataToDb(
      {productName, description, price, comparedPrice, collection, context}) {
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(timeStamp.toString()).set({
        'seller': {'shopName': this.shopName, 'selleruid': user.uid},
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'category': {
          'categoryName': this.selectedCategory,
          'subCategoryName': this.selectedSubCategory
        },
        'published': false,
        'productId': timeStamp.toString(),
        'productImage': this.productUrl
      });
      this.alertDialog(
          context: context,
          title: 'Save Data',
          content: 'Product details saved successfully');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'Save Data', content: '${e.toString()}');
    }
    return null;
  }

  Future<void> updateProduct(
      {productName,
      description,
      price,
      comparedPrice,
      collection,
      context,
      productId,
      image,
      category,
      subCategory,
      }) {
    var timeStamp = DateTime.now().millisecondsSinceEpoch;

    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productId).update({
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'category': {
          'categoryName': category,
          'subCategoryName': subCategory
        },

        'productImage': this.productUrl == null ? image : this.productUrl
      });
      this.alertDialog(
          context: context,
          title: 'Save Data',
          content: 'Product details saved successfully');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'Save Data', content: '${e.toString()}');
    }
    return null;
  }
}
