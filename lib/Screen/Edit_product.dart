import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/provider/product_provider.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';
import 'package:vendor_izzilly/widget/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String prodcutId;
  EditViewProduct({this.prodcutId});
  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];

  String dropdownValue;

  var _nameText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  DocumentSnapshot doc;
  double discount;
  String image;
  File _image;
  bool _visible = false;
  bool _editing = true;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.product
        .doc(widget.prodcutId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _nameText.text = document['productName'];
          _priceText.text = document['price'].toString();
          _comparedText.text = document['comparedPrice'].toString();
          _descriptionText.text = document['description'];
          var difference = int.parse(_comparedText.text) - double.parse(_priceText.text);
          _categoryTextController.text = document['category']['categoryName'];
          discount = (difference/ int.parse(_comparedText.text) * 100);
          image = document['productImage'];
          _subcategoryTextController.text =
              document['category']['subCategoryName'];
          dropdownValue = document['collection'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          FlatButton(
            child: Text('edit', style: TextStyle(color: Colors.white),),
            onPressed: (){
              setState(() {
                _editing = false;
              });
            },
          )
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black,
                  child: Center(
                      child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            Expanded(
                child: AbsorbPointer(
                  absorbing: _editing,
                  child: InkWell(
              onTap: () {
                  if (_formKey.currentState.validate()) {
                    EasyLoading.show(status: 'Saving.....');
                    if (_image != null) {
                      _provider
                          .uploadProductImage(_image.path, _nameText.text)
                          .then((url) {
                        if (url != null) {
                          EasyLoading.dismiss();
                          _provider.updateProduct(
                            context: context,
                            productName: _nameText.text,
                            price: double.parse(_priceText.text),
                            description: _descriptionText.text,
                            collection: dropdownValue,
                            comparedPrice: int.parse(_comparedText.text),
                            productId: widget.prodcutId,
                            image: image,
                            category: _categoryTextController.text,
                            subCategory: _subcategoryTextController.text,
                          );
                        }
                      });
                    } else {
                      EasyLoading.dismiss();
                      _provider.updateProduct(
                        context: context,
                        productName: _nameText.text,
                        price: int.parse(_priceText.text),
                        description: _descriptionText.text,
                        collection: dropdownValue,
                        comparedPrice: int.parse(_comparedText.text),
                        productId: widget.prodcutId,
                        image: image,
                        category: _categoryTextController.text,
                        subCategory: _subcategoryTextController.text,
                      );
                    }
                    _provider.resetProvider();
                  }
              },
              child: Container(
                  color: Colors.lightBlueAccent,
                  child: Center(
                      child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  )),
              ),
            ),
                ))
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 30,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    hintText: 'Product Name',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Price: '),
                                  Container(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _priceText,
                                      style: TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none),
                            controller: _nameText,
                            style: TextStyle(fontSize: 30),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Container(
                                  width: 80,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: '\$',
                                    ),
                                    controller: _priceText,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, right: 8),
                                  child: Text(
                                    '${discount.toStringAsFixed(0)}% OFF',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Inclusive of all Taxes',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: _image != null
                                    ? Image.file(
                                        _image,
                                        height: 300,
                                      )
                                    : Image.network(
                                        image,
                                        height: 300,
                                      )),
                          ),
                          Text(
                            'About this product',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: TextFormField(
                              maxLines: null,
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: [
                                Text(
                                  "category",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      controller: _categoryTextController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Select Category Name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'not selected',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                            color: Colors.grey[300],
                                          ))),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _editing == false ? true : false,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _visible = true;
                                            _categoryTextController.text =
                                                _provider.selectedCategory;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit_outlined)),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Sub Category',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Select Sub Category Name';
                                          }
                                          return null;
                                        },
                                        controller: _subcategoryTextController,
                                        decoration: InputDecoration(
                                            hintText: 'not selected',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Colors.grey[300],
                                            ))),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SubCategoryList();
                                            }).whenComplete(() {
                                          setState(() {
                                            _subcategoryTextController.text =
                                                _provider.selectedSubCategory;
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.edit_outlined))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    'collection',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  DropdownButton<String>(
                                    hint: Text('Select collection'),
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_drop_down),
                                    onChanged: (String value) {
                                      setState(() {
                                        dropdownValue = value;
                                      });
                                    },
                                    items: _collection
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
