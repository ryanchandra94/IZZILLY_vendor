import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/Screen/home_screen.dart';
import 'package:vendor_izzilly/Screen/login_screen.dart';
import 'package:vendor_izzilly/provider/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _shopNameTextController = TextEditingController();
  var _mobilePhoneTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  var _locationTextController = TextEditingController();
  var _descriptionTextController = TextEditingController();
  bool _isLoading = false;
  String email;
  String password;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('uploads/shopProfilePic/${_shopNameTextController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_shopNameTextController.text}')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessenge(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    controller: _shopNameTextController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Shop Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add_business),
                      labelText: 'Shop Name',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      )),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    maxLength: 9,
                    controller: _mobilePhoneTextController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Mobile Number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixText: '+886',
                      prefixIcon: Icon(Icons.phone_android),
                      labelText: 'Mobile Number',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      )),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Email';
                      }
                      final bool _isValid =
                          EmailValidator.validate(_emailTextController.text);
                      if (!_isValid) {
                        return 'Invalid Email Format';
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      )),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    controller: _passwordTextController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Password';
                      }
                      if (value.length < 6) {
                        return 'Minimum 6 characters';
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Password',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      )),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    controller: _confirmPasswordTextController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Confirm Password';
                      }
                      if (_passwordTextController.text !=
                          _confirmPasswordTextController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add_business),
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      )),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    maxLines: 6,
                    controller: _locationTextController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please press navigation button';
                      }
                      if (_authData.shopLatitude == null) {
                        return 'Please press navigation button';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city_outlined),
                      labelText: 'Location',

                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_searching),
                        onPressed: () {
                          _locationTextController.text =
                              'Locating...\n Please wait...';
                          _authData.getCurrentPosition().then((address) {
                            if (address != null) {
                              setState(() {
                                _locationTextController.text =
                                    '${_authData.placeName}\n${_authData.shopAddress}';
                              });
                            } else {

                            }
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      )),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextFormField(
                    controller: _descriptionTextController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Shop Description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.message_outlined),
                      labelText: 'Description',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      )),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have account?"),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginPage()));
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
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
                            if (_authData.isPicAvail == true) {
                              if (_formKey.currentState.validate()) {
                                _authData
                                    .registerVendor(email, password)
                                    .then((credential) {
                                  uploadFile(_authData.image.path).then((url) {
                                    if (url != null) {
                                      _authData
                                          .saveVendorDataToDb(
                                        url: url,
                                        shopName: _shopNameTextController.text,
                                        mobile_number:
                                            _mobilePhoneTextController.text,
                                        email: _emailTextController.text,
                                        desc: _descriptionTextController.text,
                                      )
                                          .then((value) {
                                        setState(() {
                                          _formKey.currentState.reset();
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      });
                                    } else {
                                      scaffoldMessenge(
                                          'Failed to upload shop profile picture');
                                    }
                                  });
                                });
                              }
                            } else {
                              scaffoldMessenge(
                                  "Shop profile picture is needed");
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
