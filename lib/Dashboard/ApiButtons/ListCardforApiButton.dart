import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonPlaceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String place;
  final VoidCallback onTab;
  const ButtonPlaceCard({Key? key, required this.imagePath, required this.title, required this.onTab, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 180,
        decoration:  BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [ BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 5
            )

            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 180,
                width: 180,
                color: Colors.transparent,
                child: Image.asset(imagePath,
                  fit: BoxFit.fill,
                  scale: 0.15,

                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: GoogleFonts.ptSerif(fontSize: 14 ,fontWeight: FontWeight.w400, color: Colors.blueGrey),),
                  SizedBox(height: 5,),
                  Text(place, style: GoogleFonts.poppins(fontSize: 12 ,fontWeight: FontWeight.w300, color: Colors.black),),
                ],
                  )
                ],
              ),




          ),
        ),

      );
  }
}
