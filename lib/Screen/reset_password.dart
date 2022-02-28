import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vendor_izzilly/Screen/login_screen.dart';
import 'package:vendor_izzilly/provider/auth_provider.dart';



class ResetPassword extends StatefulWidget {
  static const String id = 'Reset-screen';
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 100,),
                Image.asset("images/logo.png"),
                SizedBox(height: 10,),
                Text('Reset password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 100,),
                TextFormField(
                  validator: (value){
                    if(value.isEmpty){
                      return 'Enter email';
                    }
                    final bool _valid = EmailValidator.validate(_emailTextController.text);
                    if(!_valid){
                      return 'Invalid email format';
                    }
                    return null;
                  },
                  controller: _emailTextController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)
                    ),
                    focusColor: Colors.lightBlueAccent,
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              _authData.resetPassword(_emailTextController.text);
                            }
                            Navigator.pushReplacementNamed(context, LoginPage.id);
                          },
                          color: Theme.of(context).primaryColor,
                          child: Text("Reset password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ]
                )
              ]


          ),
        ),
      ),
    );
  }
}
