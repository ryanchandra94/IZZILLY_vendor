import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_izzilly/Screen/add_product_screen.dart';
import 'package:vendor_izzilly/Screen/edit_coupon.dart';
import 'package:vendor_izzilly/Screen/home_screen.dart';
import 'package:vendor_izzilly/Screen/login_screen.dart';
import 'package:vendor_izzilly/Screen/register_screen.dart';
import 'package:vendor_izzilly/Screen/reset_password.dart';
import 'package:vendor_izzilly/provider/auth_provider.dart';
import 'package:vendor_izzilly/provider/dashboard_provider.dart';
import 'package:vendor_izzilly/provider/order_provider.dart';
import 'package:vendor_izzilly/provider/product_provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
        providers: [
          Provider(create: (_) => AuthProvider(),),
          Provider(create: (_) => ProductProvider(),),
          Provider(create: (_) => OrderProvider(),),
          Provider(create: (_) => DashboardProvider(),),
        ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.lightBlueAccent,
          fontFamily: 'Lato'
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id : (context)=>SplashScreen(),
        RegisterScreen.id : (context)=>RegisterScreen(),
        HomeScreen.id : (context)=>HomeScreen(),
        LoginPage.id : (context)=>LoginPage(),
        AddNewProduct.id : (context)=>AddNewProduct(),
        AddEditCoupon.id : (context)=>AddEditCoupon(),
        ResetPassword.id : (context)=>ResetPassword(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const String id = 'Splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override


  void initState() {

    Timer(
        Duration(
          seconds: 3,
        ), (){
      Navigator.pushReplacementNamed(context, LoginPage.id);
    }
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/logo.png'),
            Text('Vendor App', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),)
          ],
        )
      ),
    );
  }
}

