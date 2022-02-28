
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/login_screen.dart';


class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {




  @override
  Widget build(BuildContext context) {

    return SliverAppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      floating: true,
      snap: true,
      leading: Container(
      ),
      title: Image.asset("images/logo.png",color: Colors.black, scale: 1.5,),
      actions: [
        IconButton(
          icon : Icon(Icons.account_circle_outlined, color: Colors.black,),
          onPressed: (){

            FirebaseAuth.instance.signOut();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));


          },
        )
      ],
      centerTitle: false,
      leadingWidth: 0,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Divider(thickness: 5,)
      ),

    );
  }
}