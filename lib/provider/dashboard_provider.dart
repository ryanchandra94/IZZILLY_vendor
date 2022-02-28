import 'package:flutter/cupertino.dart';

class DashboardProvider with ChangeNotifier{


  int complete;
  int pending;
  int processing;
  int cancel;
  int refund;
  int onHold;



  completeOrder(num){
    this.complete = num;
    notifyListeners();
  }

  pendingOrder(num){
    this.pending = num;
    notifyListeners();
  }
  processOrder(num){
    this.processing = num;
    notifyListeners();
  }
  cancelOrder(num){
    this.cancel = num;
    notifyListeners();
  }
  refundOrder(num){
    this.refund = num;
    notifyListeners();
  }

  onHoldOrder(num){
    this.onHold = num;
    notifyListeners();
  }

}