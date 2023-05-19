import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../GateWayPayment/app_in_purchase.dart';
import '../GateWayPayment/paypal.dart';
import 'dart:io' as io;


class RegisterStatus extends StatelessWidget {
  const RegisterStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Thank you "),
                SizedBox(height: 10,),
                Text("Your Registration is sucessfull "),
                SizedBox(height: 10,),
                Text("Status is pending "),
                SizedBox(height: 10,),
                Text("Please wait our team is checking your request"),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  if (io.Platform.isMacOS) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppInPurchaseScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayPalScreen(title: 'kk'),
                      ),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => PayPalScreen(
                    //       totalPrice: _totalPrice(),
                    //       totalProducts:_totalQuantity(), title: 'Peeptoon',
                    //     ),
                    //   ),
                    // );
                  }
                }, child: Text("Continue"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
