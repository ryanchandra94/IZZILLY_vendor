import 'package:flutter/material.dart';
import 'package:vendor_izzilly/widget/image_picker.dart';
import 'package:vendor_izzilly/widget/register_form.dart';



class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Image.asset("images/logo.png"),
                  SizedBox(height: 10,),
                  Text('Sign Up', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ShopPicCard(),
                  RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
