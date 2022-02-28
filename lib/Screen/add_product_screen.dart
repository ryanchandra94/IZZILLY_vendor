import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/provider/product_provider.dart';
import 'package:vendor_izzilly/widget/category_list.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'add-product';

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];

  String dropdownValue;

  var _categoryTextController = TextEditingController();
  var _subcategoryTextController = TextEditingController();
  var _compPriceTextController = TextEditingController();
  var _priceTextController = TextEditingController();
  File _image;
  bool _visible = false;

  String productName;
  String desc;
  int price;
  double sellingPrice;
  double comparedPrice;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
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
                        child: Container(child: Text('Product / Add')),
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if(_categoryTextController.text.isNotEmpty){
                                if(_subcategoryTextController.text.isNotEmpty){
                                  if (_image != null) {
                                    EasyLoading.show(status: 'Saving...');
                                    _provider
                                        .uploadProductImage(
                                        _image.path, productName)
                                        .then((url) {
                                      if (url != null) {
                                        EasyLoading.dismiss();
                                        _provider.saveProductDataToDb(
                                            context: context,
                                            comparedPrice:
                                            _compPriceTextController.text,
                                            collection: dropdownValue,
                                            description: desc,
                                            price: sellingPrice,
                                            productName: productName);
                                        setState(() {
                                          _formKey.currentState.reset();
                                          dropdownValue = null;
                                          _compPriceTextController.clear();
                                          _subcategoryTextController.clear();
                                          _categoryTextController.clear();
                                          _image = null;
                                          _visible = false;
                                        });
                                      } else {
                                        _provider.alertDialog(
                                            context: context,
                                            title: 'Image Upload',
                                            content:
                                            "Failed to upload product image");
                                      }
                                    });
                                  } else {
                                    _provider.alertDialog(
                                        context: context,
                                        title: 'Product Image',
                                        content: "Product Image not selected");
                                  }
                                }else{

                                    _provider.alertDialog(
                                        context: context,
                                        title: 'Sub Category',
                                        content: "Sub Category not selected");

                                }
                              }else{
                                _provider.alertDialog(
                                  context: context,
                                  title: 'Main category',
                                  content: 'Main category not selected'
                                );
                              }
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
              TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'General',
                    ),
                  ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter Product Name';
                                    }
                                    setState(() {
                                      productName = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Product Name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ))),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  maxLength: 500,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter Description';
                                    }
                                    setState(() {
                                      desc = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'About Product',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((image) {
                                        setState(() {
                                          _image = image;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(
                                          child: _image == null
                                              ? Text('Select image')
                                              : Image.file(_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter Selling Price';
                                    }
                                    setState(() {
                                      sellingPrice = double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Price', //final price
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ))),
                                ),
                                TextFormField(
                                  controller: _compPriceTextController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter Compared Price';
                                    }
                                    if (sellingPrice > double.tryParse(value)) {
                                      return 'Compared price should be higher than price';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Compared Price', //final price
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ))),
                                ),
                                Container(
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
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
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
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
                                                builder:
                                                    (BuildContext context) {
                                                  return CategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _visible = true;
                                                _categoryTextController.text =
                                                    _provider.selectedCategory;
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.edit_outlined))
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _visible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
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
                                              controller:
                                                  _subcategoryTextController,
                                              decoration: InputDecoration(
                                                  hintText: 'not selected',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                    color: Colors.grey[300],
                                                  ))),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SubCategoryList();
                                                  }).whenComplete(() {
                                                setState(() {
                                                  _subcategoryTextController
                                                          .text =
                                                      _provider
                                                          .selectedSubCategory;
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.edit_outlined))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
