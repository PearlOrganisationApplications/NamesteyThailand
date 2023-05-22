import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:namastethailand/PlaceDescription/placedescription.dart';
import 'package:namastethailand/widet/PlacesAbout.dart';

import '../Dashboard/ApiButtons/apiButtonContentList.dart';
import '../Dashboard/allPlaceContent.dart';
import '../Dashboard/recomandedContent.dart';
import '../Utility/sharePrefrences.dart';





class CityInformation extends StatefulWidget {
    String id;
    String city_name;
   CityInformation({Key? key,required this.id, required this.city_name}) : super(key: key);

  @override
  State<CityInformation> createState() => _CityInformationState();

}


class _CityInformationState extends State<CityInformation> {
  GoogleMapController? mapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 0,
  );



  @override
  LatLng bangkokLatLng = LatLng(13.7563, 100.5018);
  final cityCategory = FutureProvider.family((ref,String id) async {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.post(
        'https://test.pearl-developer.com/thaitours/public/api/get-categories',
        data: {'id': int.parse(id)}, // Replace `yourId` with the actual id value you want to send
      );
      print("#################################################################################categoryResponse${response.data} \n Id : $id");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  });
  final cityWeather = FutureProvider.family((ref,String id) async {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.post(
        'https://test.pearl-developer.com/thaitours/public/api/get-weather',
        data: {'city_id': id}, // Replace `yourId` with the actual id value you want to send
      );
      print("#################################################################################WeatherResponse${response.data} \n Id : $id");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  });

  @override
  void initState() {
    final  iid = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      appBar: AppBar(

        title: Text(
          "${widget.city_name[0].toUpperCase()}${widget.city_name.substring(1).toLowerCase()}",style: TextStyle(color: Colors.red),
        ),        iconTheme: IconThemeData(color: Colors.blueGrey),

        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                width: double.infinity,
                child:
                Consumer(
                  builder: (context, watch, _) {
                    final citiesFuture = watch.watch(cityCategory(widget.id??'2'));

                    return citiesFuture.when(
                      data: (response) {
/*
                        EasyLoading.show(status: response['categories'].toString(), dismissOnTap: true);
*/

                        final cities = response['categories'];

                        return SizedBox(
                          // Your desired size for the container
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cities.length,
                            itemBuilder: (context, index) {
                              final city = cities[index];

                              return
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const ApiButtonContent()),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.orangeAccent,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Center(child: Text(city["name"],style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                                    ),
                                  ),
                                );
                              /*ListTile(
                                title: Text(city['cityname']),
                                // Add other widgets to display additional information about the city, such as the image
                              );*/
                            },
                          ),
                        );
                      },
                      loading: () => Center(child: Container(
                        height: 50,
                          width:50,
                          child: CircularProgressIndicator())),
                      error: (error, _) => Text('Error: $error'),
                    );
                  },
                )

/*
                ListView(
                  scrollDirection: Axis.horizontal,

                  children: [
                    InkWell(
                     onTap: (){
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const ApiButtonContent()),
                       );
                     },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.orangeAccent,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Center(child: Text("SPA",style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                      ),
                    ),
                    */
/*SizedBox(width: 5,),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orangeAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(child: Text("SPORTS",style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                    ),
                    SizedBox(width: 5,),

                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orangeAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(child: Text("RESTORENT",style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                    ),
                    SizedBox(width: 5,),

                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orangeAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(child: Text("CLUB",style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                    ),

                    SizedBox(width: 5,),

                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orangeAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(child: Text("HOTEL",style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                    ),
                    SizedBox(width: 5,),

                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orangeAccent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(child: Text("SPORTS",style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                    )

*//*


                  ],
                ),
*/
              ),
              SizedBox(
                height: 10,
              ),
              Text("Welcome to Bankok", style: GoogleFonts.ptSerif(
                  fontSize: 20, fontWeight: FontWeight.w400,
                  color: Colors.blueGrey,
                  letterSpacing: 2
              ),),
              SizedBox(height: 10,),
             
              SizedBox(
                height: 40,
                width: double.infinity,
                child:                Consumer(
                  builder: (context, watch, _) {
                    final citiesFuture = watch.watch(cityWeather(widget.id??'0'));

                    return citiesFuture.when(
                      data: (response) {

                        final weather = response;
                        String conditionName = '';
                        IconData conditionIcon = Icons.error; // Default icon for unhandled conditions
                        switch (weather['condition']) {
                          case 1:
                            conditionName = 'Tornado';
                            conditionIcon = Icons.tornado;
                            break;
                          case 2:
                            conditionName = 'Tropical Cyclone';
                            conditionIcon = Icons.cached; // Replace with the appropriate icon
                            break;
                          case 3:
                            conditionName = 'Blizzard';
                            conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                            break;
                          case 4:
                            conditionName = 'Drought';
                            conditionIcon = Icons.grain; // Replace with the appropriate icon
                            break;
                          case 5:
                            conditionName = 'Winter Storm';
                            conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                            break;
                          case 6:
                            conditionName = 'Winter Storm';
                            conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                            break;
                          case 7:
                            conditionName = 'Heat Wave';
                            conditionIcon = Icons.whatshot; // Replace with the appropriate icon
                            break;
                          case 8:
                            conditionName = 'Rain';
                            conditionIcon = Icons.beach_access; // Replace with the appropriate icon
                            break;
                          case 9:
                            conditionName = 'Wind';
                            conditionIcon = Icons.air; // Replace with the appropriate icon
                            break;
                          case 10:
                            conditionName = 'Cloud';
                            conditionIcon = Icons.cloud; // Replace with the appropriate icon
                            break;
                          case 11:
                            conditionName = 'Humidity';
                            conditionIcon = Icons.opacity; // Replace with the appropriate icon
                            break;
                          case 12:
                            conditionName = 'Precipitation';
                            conditionIcon = Icons.waves; // Replace with the appropriate icon
                            break;
                          case 13:
                            conditionName = 'Snow';
                            conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                            break;
                          default:
                          // Handle any other condition values if needed
                            break;
                        }

                        return SizedBox(
                          // Your desired size for the container
                          child: Row(
                            children: [
                              Text("weather", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17, color: Colors.black),),
                              SizedBox(width: 10,),
                              Text(weather["weather"],style: TextStyle(color:Colors.red, letterSpacing: 2, fontSize: 17),),
                              SizedBox(width: 10,),
                              Text(conditionName),
                              SizedBox(width: 10,),
                              Icon(conditionIcon),                            ],
                          )
                              /*ListTile(
                                title: Text(city['cityname']),
                                // Add other widgets to display additional information about the city, such as the image
                              );*/


                        );
                      },
                      loading: () => Center(child: Container(
                          height: 50,
                          width:50,
                          child: CircularProgressIndicator())),
                      error: (error, _) => Text('Error: $error'),
                    );
                  },
                )

/*
                ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                   Row(
                     children: [
                       Text('Weather Report'),
                       SizedBox(width: 10,),
                       Icon(Icons.sunny, color: Colors.amber,),
                       SizedBox(width: 5,),
                       Text("Clear")
                     ],
                   )
                  ],
                ),
*/
              ),
              SizedBox(height: 10,),

              BlurryContainer(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Text("About Bankok ",
                        style: GoogleFonts.notoSansAnatolianHieroglyphs(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400),),

                    ],


                  )),

              SizedBox(height: 5,),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'Population: 69 million peopl.\n',
                      style: GoogleFonts.libreBaskerville(
                        letterSpacing: 1,
                        color: Colors.blueGrey,
                      ),
                    ),

                    TextSpan(
                      text:
                      'Weather: Tropical, hot and humid.\n',
                      style: GoogleFonts.libreBaskerville(
                        letterSpacing: 1,
                        color: Colors.blueGrey,
                      ),
                    ),

                    TextSpan(
                      text:
                      'Weather: Tropical, hot and humid.\n',
                      style: GoogleFonts.libreBaskerville(
                        letterSpacing: 1,
                        color: Colors.blueGrey,
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 10,),

              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: 16/9,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: 0.8,
                ),
                items: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/newThai1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bangkok2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bangkok3.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bangkok4.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bangkok5.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),



              SizedBox(height: 5,),

                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: bangkokLatLng, // San Francisco
                      zoom: 12,
                    ),

              ),
                ),
              SizedBox(height: 10,),

              BlurryContainer(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Text("Travel facility",
                          style: GoogleFonts.notoSansAnatolianHieroglyphs(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400),),
                      ]
                  )),
              SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.25,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    child: Image.asset(
                        "assets/images/train.jpg", fit: BoxFit.fill),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("BTS (Sky Train)", style: GoogleFonts.robotoSlab(
                          color: Colors.black, fontWeight: FontWeight.w900),),
                      SizedBox(height: 5,),
                      Text(" MRT (Subway)\nand Airport Link",
                          style: GoogleFonts.libreBaskerville(
                              letterSpacing: 1, color: Colors.blueGrey))

                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'BTS is a rapid transit system\n'),
                    TextSpan(text: 'It serves Bangkok, Thailand\n'),
                    TextSpan(text: 'Consists of two lines'),
                  ],
                ),
              ),


              SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.25,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    child: Image.asset(
                        "assets/images/boat.jpg", fit: BoxFit.fill),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(" Chao Phraya", style: GoogleFonts.robotoSlab(
                          color: Colors.black, fontWeight: FontWeight.w900),),
                      SizedBox(height: 5,),
                      Text("Express Boat",
                          style: GoogleFonts.libreBaskerville(
                              letterSpacing: 1, color: Colors.blueGrey))

                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),

              RichText(
                text: TextSpan(
                  style: GoogleFonts.libreBaskerville(
                    fontSize: 16,
                    color: Colors.black,
                  ),                  children: <TextSpan>[
                    TextSpan(text: 'Chao Phraya is a river\n'),
                    TextSpan(text: 'It flows through Bangkok\n'),
                    TextSpan(text: 'Famous for boat tours'),
                  ],
                ),
              ),

              SizedBox(

                height: 5,
              ),


            ]


          ),
        ),
      )
      );

  }

}
