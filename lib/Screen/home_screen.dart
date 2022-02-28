
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:vendor_izzilly/Screen/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:vendor_izzilly/Screen/login_screen.dart';
import 'package:vendor_izzilly/service/drawer_service.dart';
import 'package:vendor_izzilly/widget/drawer_menu_widget.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DrawerServices _services = DrawerServices();
  GlobalKey<SliderMenuContainerState> _key =
  new GlobalKey<SliderMenuContainerState>();
  String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SliderMenuContainer(
            appBarColor: Colors.white,
            appBarHeight: 80,
            key: _key,
            sliderMenuOpenSize: 250,
            title: Text(
              '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("images/logo.png", color: Colors.black, scale: 1.5,),
                SizedBox(width: 60,),
                IconButton(
                  icon : Icon(Icons.account_circle_outlined, color: Colors.black,),
                  onPressed: (){

                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));


                  },
                )
              ],
            ),
            sliderMenu: MenuWidget(
              onItemClick: (title) {
                _key.currentState.closeDrawer();
                setState(() {
                  this.title = title;
                });
              },
            ),
            sliderMain: _services.DrawerScreen(title)),
      ),
    );
  }
}
