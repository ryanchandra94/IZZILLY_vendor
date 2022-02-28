import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:vendor_izzilly/service/firebase_service.dart';

class AddEditCoupon extends StatefulWidget {
  static const String id = 'update-coupon';
  final DocumentSnapshot document;
  AddEditCoupon({this.document});
  @override
  _AddEditCouponState createState() => _AddEditCouponState();
}

class _AddEditCouponState extends State<AddEditCoupon> {
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  DateTime _selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var titleText = TextEditingController();
  var detailsText = TextEditingController();
  var discountRate = TextEditingController();
  bool _activate = false;

  _selectDate(context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      if (mounted) {
        setState(() {
          _selectedDate = picked;
          String formattedText = DateFormat('yyyy-MM-dd').format(_selectedDate);
          dateText.text = formattedText;
        });
      }
    }
  }

  @override
  void initState() {
    if(widget.document!=null)
      if(mounted)
        setState(() {
          titleText.text = widget.document['title'];
          discountRate.text = widget.document['discountRate'].toString();
          detailsText.text = widget.document['details'].toString();
          dateText.text = widget.document['Expiry'].toDate();
          _activate = widget.document['activate'];
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title: Text("ADD / EDIT Coupon", style: TextStyle(color: Colors.white),),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: titleText,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Coupon title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Coupon title',
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
                TextFormField(
                  controller: discountRate,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Set discount rate';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Discount %',
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
                TextFormField(
                  controller: dateText,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Apply Expiry Date';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Expiry Date',
                    labelStyle: TextStyle(color: Colors.grey),
                    suffixIcon: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Icon(Icons.date_range_outlined),
                    ),
                  ),
                ),
                TextFormField(
                  controller: detailsText ,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Coupon details';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Coupon Details',
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Activate Coupon'),
                  value: _activate,
                  onChanged: (bool newValue) {
                    if (mounted) {
                      setState(() {
                        _activate = !_activate;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            EasyLoading.show(status: 'Please Wait..');
                            _services.saveCoupon(
                              document: widget.document,
                              title: titleText.text.toUpperCase(),
                              details: detailsText.text,
                              discountRate: int.parse(discountRate.text),
                              expiry: _selectedDate,
                              activate: _activate
                            ).then((value) {
                              if(mounted){
                                setState(() {
                                  titleText.clear();
                                  discountRate.clear();
                                  detailsText.clear();
                                  _activate = false;
                                });
                                EasyLoading.showSuccess('Saved Successfully');
                              }
                            });
                          }
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
