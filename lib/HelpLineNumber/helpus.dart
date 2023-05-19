import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpUs extends StatelessWidget {
   HelpUs({Key? key}) : super(key: key);
  Map<String, String> data = {
    "Tourist Police": "1155",
    "Police": "191",
    "Tourism Authority of Thailand": "1672",
  "Ambulance": "112",
  "Fire department": "999",
    "Ambulance": "1646 (For Bangkok)",
    "Thai Airways": "1566",
    "Air Ambulance":"02 586 7654"
  };
   final _random = Random();

   Color _getRandomColor() {
     return Color.fromRGBO(
       _random.nextInt(128),
       _random.nextInt(120),
       _random.nextInt(119),
       1,
     );
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),

        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.9,
            child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              String key = data.keys.elementAt(index);
              String? value = data[key];
              return
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    splashColor: Colors.orangeAccent,
                    title: Text(key),
                    subtitle: Text(value!),
                  ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
              ),
                );
            },
        ),
          )
            ],
          ),
        ),
      ),
    );
  }
}
