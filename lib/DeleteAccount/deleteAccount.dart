import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:       AppBar(
        title: Text("Contact Us"),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8,),
            Container(
              height: 50,
              width: double.infinity,
              child: Card(
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 0.1,),
                    Text("Delete Account", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                    IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.delete, color: Colors.red,),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
