import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/login_screen.dart';



class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
        FirebaseAuth.instance.signOut();

      },
    );
  }
}
