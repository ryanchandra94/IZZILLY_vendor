import 'package:flutter/material.dart';
import 'package:vendor_izzilly/Screen/Banner_screen.dart';
import 'package:vendor_izzilly/Screen/chat/chat_screen_list.dart';
import 'package:vendor_izzilly/Screen/coupon_screen.dart';
import 'package:vendor_izzilly/Screen/dashboard_screen.dart';
import 'package:vendor_izzilly/Screen/edit_coupon.dart';
import 'package:vendor_izzilly/Screen/order_screen.dart';
import 'package:vendor_izzilly/Screen/product_screen.dart';
import 'package:vendor_izzilly/widget/singout.dart';

class DrawerServices{

  Widget DrawerScreen(title){
    if(title == 'Dashboard'){
      return MainScreen();
    }

    if(title == 'Product'){
      return ProductScreen();
    }

    if(title == 'Banner'){
      return BannerScreen();
    }

    if(title == 'Coupons'){
      return CouponScreen();
    }

    if(title == 'Orders'){
      return OrderScreen();
    }

    if(title == 'Chat'){
      return ChatRoomList();
    }

    if(title == 'LogOut'){
      return SignOut();
    }

    return MainScreen();
  }
}