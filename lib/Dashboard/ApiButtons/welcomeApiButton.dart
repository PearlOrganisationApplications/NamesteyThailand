import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dashboard.dart';


class WelcomeApiButton extends StatefulWidget {
  // final String image;
  const WelcomeApiButton({Key? key,}) : super(key: key);

  @override
  State<WelcomeApiButton> createState() => _WelcomeApiButtonState();
}

class _WelcomeApiButtonState extends State<WelcomeApiButton> {
  // Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          final String address = '1600 Amphitheatre Parkway, Mountain View, CA';
          final String mapUrl = 'https://www.google.com/maps/search/?api=1&query=$address';
          if (await canLaunch(mapUrl)) {
          await launch(mapUrl);
          } else {
          throw 'Could not launch $mapUrl';
          }

        },
        backgroundColor: Colors.orangeAccent,
        label:Text("Navigate",style: GoogleFonts.ptSerif(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),),
        icon: Icon(Icons.location_on),
        elevation: 20,

      ),
      body: SafeArea(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: double.infinity,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                      ),

                child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight:Radius.circular(30)),
                  child: Image.asset("assets/images/spa2.jpg", fit: BoxFit.fill,),
                ),

              ),
      Positioned(
          top: 16,
          left: 16,
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 30,
              width: 30,


              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(Icons.arrow_back,color: Colors.white),

            ),
          ),
      ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(Icons.home,color: Colors.blueGrey,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Dashboard()),
                      );                    },
                  ),
                )
      ]
            ),
            SizedBox(height: 10,),


            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                  BlurryContainer(
                    color: Colors.grey.shade200,
                    elevation: 1,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Foot Master", style: GoogleFonts.ptSerif(
                              fontSize: 17, fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                              letterSpacing: 2
                          ),),
                            Text("Watthana", style: GoogleFonts.ptSerif(
                                fontSize: 15, fontWeight: FontWeight.w400,
                                color: Colors.black,
                                letterSpacing: 2
                            ),),],
                        ),
                        SizedBox(height: 5,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text("Price", style: GoogleFonts.ptSerif(
                                fontSize: 17, fontWeight: FontWeight.w400,
                                color: Colors.blueGrey,
                                letterSpacing: 2
                            ),),
                            SizedBox(height: 5,),
                            Text("\$200", style: GoogleFonts.ptSerif(
                                fontSize: 15, fontWeight: FontWeight.w400,
                                color: Colors.red,
                                letterSpacing: 2
                            ),),
                          ],
                        ),
                       SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Contact", style: GoogleFonts.ptSerif(
                                fontSize: 17, fontWeight: FontWeight.w400,
                                color: Colors.blueGrey,
                                letterSpacing: 2
                            ),),
                            Text("8001259865", style: GoogleFonts.ptSerif(
                                fontSize: 15, fontWeight: FontWeight.w400,
                                color: Colors.black,
                                letterSpacing: 2
                            ),),
                          ],
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 5,),


                  BlurryContainer(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    elevation: 1,
                    child: Column(
                      children: [
                        Text("About", style: GoogleFonts.ptSerif(
                            fontSize: 17, fontWeight: FontWeight.w400,
                            color: Colors.blueGrey,
                            letterSpacing: 2
                        ),),
                        Text("Relaxation is the state of being free from tension and anxiety. "
                            "To be in this state, various things can be done and one of such is going to spas",
                          style: GoogleFonts.ptSerif(
                            fontSize: 15, fontWeight: FontWeight.w400,
                            color: Colors.black,
                            letterSpacing: 2
                        ),),

                      ],
                    ),

                  ),
                  SizedBox(
                    height: 5,
                  ),
                  BlurryContainer(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    elevation: 1,
                    child: Column(
                      children: [
                        Text("Address", style: GoogleFonts.ptSerif(
                            fontSize: 20, fontWeight: FontWeight.w400,
                            color: Colors.blueGrey,
                            letterSpacing: 2
                        ),),
                        Text("Address", style: GoogleFonts.ptSerif(
                            fontSize: 20, fontWeight: FontWeight.w400,
                            color: Colors.black,
                            letterSpacing: 2
                        ),),

                      ],
                    ),
                  ),
                      SizedBox(height: 5,),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
