
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  File image;
  bool isPicAvail = false;
  String pickerError = '';
  String error = '';
  String email;
  double shopLongitude;
  double shopLatitude;
  String shopAddress;
  String placeName;
  bool permissionAllowed = false;

  Future<File> getImage() async {
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

  /// register vendor
  Future<UserCredential> registerVendor(email, password) async {
    UserCredential userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;

  }

  /// save vendor data to firestore
  Future<void> saveVendorDataToDb(
      {String url,
      String shopName,
      String mobile_number,
      String email,
      String location,
      String desc})async {
      User user = FirebaseAuth.instance.currentUser;
      DocumentReference _vendors = FirebaseFirestore.instance.collection('vendors').doc(user.uid);
      _vendors.set({
        'imageUrl': url,
        'uid': user.uid,
        'shopName': shopName,
        'mobile': mobile_number,
        'email': email,
        'description': desc,
        'address': '${this.placeName} : ${this.shopAddress}',
        'location': GeoPoint(this.shopLatitude, this.shopLongitude),
        'latitude': this.shopLatitude,
        'longitude': this.shopLongitude,
        'shopOpen': true,
        'rating': 0.00,
        'totalRating': 0,
        'isTopPicked': true,
      });
      return null;
  }


  Future<UserCredential>loginCustomer(email,password)async{
    this.email = email;
    UserCredential userCredential;
    notifyListeners();
    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);
    } on FirebaseAuthException catch(e){
      this.error = e.code;
      notifyListeners();
    }catch(e){
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }


  Future<UserCredential>resetPassword(email)async{
    UserCredential userCredential;
    notifyListeners();
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email );
    } on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        this.error = 'The password provided is too weak';
        notifyListeners();
        print('The password provided is too weak');
      }else if(e.code == 'email-already-in-use'){
        this.error = 'The account already exists for that email';
        notifyListeners();
        print('The account already exists for that email');
      }
    }catch(e){
      this.error = e.toString();
      print(e);
    }
    return userCredential;
  }


  Future getCurrentPosition()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=null){

      this.shopLatitude = position.latitude;
      this.shopLongitude = position.longitude;

      final coordinates= new Coordinates(this.shopLatitude, this.shopLongitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var shopAddress = addresses.first;
      this.shopAddress = shopAddress.addressLine;
      this.placeName = shopAddress.featureName;
      this.permissionAllowed = true;
      notifyListeners();

      return shopAddress;
    }else{
      print('permission not allowed');
    }
  }

}
