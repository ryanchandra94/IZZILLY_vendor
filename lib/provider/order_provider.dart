import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class OrderProvider with ChangeNotifier{


  String status;

  filterOrder(status){
    this.status=status;
    notifyListeners();
  }
}