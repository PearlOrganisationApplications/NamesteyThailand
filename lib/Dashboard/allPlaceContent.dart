import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllPlaces extends StatelessWidget {
  final String imagePath;
  final String place;
  final VoidCallback onTab;

  const AllPlaces({Key? key, required this.imagePath, required this.place, required this.onTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children:[ InkWell(
          onTap: onTab,
          child: Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
              ),
              margin: EdgeInsets.all(2),
              child: Container(
                width: 200,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(imagePath,
                        fit: BoxFit.fill,
                        width: 200,
                        height: 200,

                      ),
                    ),

                  ],

                ),
              )

          ),
        ),
          Positioned(
              top: 100,
              left: 0,
              right: 0,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(place, style: GoogleFonts.merriweather(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w800, fontSize: 18),),
                ],
              ))
        ]
    );
  }
}
