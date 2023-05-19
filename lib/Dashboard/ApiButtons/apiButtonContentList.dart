import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:namastethailand/Dashboard/ApiButtons/welcomeApiButton.dart';

import 'ListCardforApiButton.dart';

class ApiButtonContent extends StatelessWidget {
  const ApiButtonContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blueGrey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(height: 5,),
              BlurryContainer(
                width: double.infinity,
                color: Colors.grey.shade200,
                height: 50,
                elevation: 1,
                borderRadius: BorderRadius.circular(10),
                child: Text("SPA in Bangkok",
                  style: GoogleFonts.ptSerif(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800),),
              ),
              SizedBox(height: 5,),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    ButtonPlaceCard(title: "Shewa spa",place: "Phra Nakhon",imagePath: "assets/images/spa2.jpg",onTab: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomeApiButton()),
                      );
                    },),
                    ButtonPlaceCard(title: "Foot Master",place: "Watthana",imagePath: "assets/images/spa3.jpg",onTab: (){},),
                    ButtonPlaceCard(title: "Drain Spa",place: "Phra Nakhon",imagePath: "assets/images/spa3.jpg",onTab: (){},),
                    ButtonPlaceCard(title: "Panpuri Wellness",place: "Phra Nakhon",imagePath: "assets/images/spa2.jpg",onTab: (){},),
                    ButtonPlaceCard(title: "Spa Burasari",place: "Lumphini",imagePath: "assets/images/spa3.jpg",onTab: (){},),
                    ButtonPlaceCard(title: "Retreat on Vitayu",place: "Lumphini",imagePath: "assets/images/spa3.jpg",onTab: (){},),



                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
