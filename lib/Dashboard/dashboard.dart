import 'dart:async';
import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:namastethailand/Calender/thaiCalender.dart';
import 'package:namastethailand/Dashboard/recomandedContent.dart';
import 'package:namastethailand/HelpLineNumber/helpus.dart';
import 'package:namastethailand/LanguageTranslation/languageTraslation.dart';
import 'package:namastethailand/UserProfile/userprofile.dart';
import 'package:namastethailand/Utility/logout.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';
import 'package:namastethailand/login.dart';
import '../AddShop/add_shop.dart';
import '../CityInformation/cityInformation.dart';
import '../ContactUs/contactus.dart';
import '../DeleteAccount/deleteAccount.dart';
import 'TimeWidget/indiaThaiTime.dart';
import 'allPlaceContent.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var weatherApi;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = true;
  String? inr;
  String? thb;



  final fetchCities = FutureProvider((ref) async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
    'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.get(
          'https://test.pearl-developer.com/thaitours/public/api/get-cities');
      print(
          "#################################################################################categoryResponse${response.data}");

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
  int current = 0;

  @override
  var temp;
  var description;
  var currently;
  var icon;
  var celciousTemp;
  var indianTime;
  var thailandTime;
  List<String> imageNames = [
    'assets/images/hotel1.jpg',
    'assets/images/hotel2.jpg',
    'assets/images/newThai3.jpg',
  ];

  void getTime() {
    DateTime now = DateTime.now();

    // Indian Time
    this.indianTime = DateFormat('hh:mm:ss a')
        .format(now.toUtc().add(Duration(hours: 5, minutes: 30)));
    print('Indian Time: $indianTime');

    // Thailand Time
    this.thailandTime =
        DateFormat('hh:mm:ss a').format(now.toUtc().add(Duration(hours: 7)));
    print('Thailand Time: $thailandTime');
  }

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=bangkok&unit=standard&appid=d2543525e18d401cc374116eebc57c14"));
    var results = jsonDecode(response.body);
/*
    print(response.body);
*/
/*
    print(temp);
*/
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.icon = results['weather'][0]['icon'];
      this.celciousTemp = temp - 273.15;
      this.celciousTemp = this.celciousTemp.round();
    });
  }

  bool _isConnected = false;


/*
  Future getCurrency() async {
    http.Response response = await http.get(Uri.parse(
        "https://v6.exchangerate-api.com/v6/819ad29f831b13eec9bf0b74/latest/INR"));
    var rates = jsonDecode(response.body);
    print(response.body);
    print(inr);
    setState(() {
      this.inr = rates['conversion_rates']['INR'];
      this.thb = rates['conversion_rates']['THB'];
    });
  }
*/

  @override
  void initState() {
    super.initState();
    this.getWeather();
    this.getTime();
    getConnectivity();
    fetchCurrencyData();


    // print('currency data ${getCurrency()}');
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


  @override
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: drawer(),
      appBar:
      AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
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
                  height: 158,
                  width: double.infinity,
                  child:
                  Consumer(
                    builder: (context, watch, _) {
                      final citiesFuture = watch.watch(fetchCities);

                      return citiesFuture.when(
                        data: (response) {
                          final cities = response['cities'];

                          return SizedBox(
                            // Your desired size for the container
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cities.length,
                              itemBuilder: (context, index) {
                                final city = cities[index];

                                return RecomandedContent(
                                    imagePath: city["image"],
                                    place: city['cityname'],
                                    onTab: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (
                                                  context) =>  CityInformation(id: city['id'].toString()??'1', city_name: city["cityname"].toString()??"oops!",)));
                                    });

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
                            width: 50,
                            child: CircularProgressIndicator())),
                        error: (error, _) => Text('Error: $error'),
                      );
                    },
                  )


/*
                ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    RecomandedContent(
                      imagePath: "assets/images/place1.jpg",
                      place: "Bangkok",
                      onTab: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CityInformation()));
                      },
                    ),
                    RecomandedContent(
                      imagePath: "assets/images/place2.jpg",
                      place: "Pattaya",
                      onTab: () {},
                    ),
                    RecomandedContent(
                      imagePath: "assets/images/place3.jpg",
                      place: " River Chao Phraya",
                      onTab: () {},
                    ),
                    RecomandedContent(
                      imagePath: "assets/images/place4.jpg",
                      place: "Burinam",
                      onTab: () {},
                    ),
                    RecomandedContent(
                      imagePath: "assets/images/place5.jpg",
                      place: "Chiang Dao Massif",
                      onTab: () {},
                    ),
                    RecomandedContent(
                      imagePath: "assets/images/place6.jpg",
                      place: "Chiang Mai",
                      onTab: () {},
                    ),
                  ],
                ),
*/
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Welcome to Thailand",
                style: GoogleFonts.ptSerif(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.blueGrey,
                    letterSpacing: 2),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 50,
                child:

                ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                        child: Row(
                          children: [/*
                            if (description == "clear sky") ...[
                              const Icon(
                                Icons.circle,
                                size: 20,
                                color: Colors.orangeAccent,
                              ),
                            ] else
                              if (description == "overcast clouds") ...[
                                const Icon(
                                  Icons.cloud,
                                  size: 20,
                                  color: Colors.blueGrey,
                                )
                              ] else
                                if (description == "scattered clouds") ...[
                                  const Icon(
                                    Icons.cloud,
                                    color: Colors.blueGrey,
                                  )
                                ] else
                                  if (description == "broken clouds") ...[
                                    const FaIcon(FontAwesomeIcons.cloudRain)
                                  ] else
                                    if (description == "shower rain") ...[
                                      const FaIcon(FontAwesomeIcons.cloudRain)
                                    ] else
                                      if (description == "rain") ...[
                                        const FaIcon(FontAwesomeIcons.cloudRain)
                                      ] else
                                        if (description == "thunderstorm") ...[
                                          const Icon(Icons.thunderstorm)
                                        ] else
                                          if (description == "snow") ...[
                                            const Icon(Icons.snowing)
                                          ] else
                                            if (description == "mist") ...[
                                              const Icon(Icons.foggy)
                                            ],*/
                            SizedBox(
                              width: 5,
                            ),
                            FaIcon(
                              FontAwesomeIcons.thermometer,
                              size: 17,
                            ),
                            SizedBox(
                              width: 2,
                            ),

                            /*Text(
                              celciousTemp != null
                                  ? celciousTemp.toString() + "\u00b0 C"
                                  : "Loading",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                            )*/
                            // Currency of India and thai
                Consumer(
                  builder: (context, watch, _) {
                    final countryFuture = watch.watch(aboutCountry);

                    return countryFuture.when(
                      data: (response) {
                        final countryWeather = response['weather']['temperature'].toString();

                        return SizedBox(
                          // Your desired size for the container
                          child: Text("countryWeather\u00b0 C")
                        );
                      },
                      loading: () => Center(child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator())),
                      error: (error, _) => Text('Error: $error'),
                    );
                  },
                ),

                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              inr != null ? inr.toString() : "loading",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "INR",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              thb != null ? thb.toString() : "loading",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "THB",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            // timing india or thai
                            SizedBox(
                              width: 15,
                            ),
                            DualClockWidget(),
                            // Text(indianTime, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, ),),
                            // SizedBox(width: 2,),
                            // // Text("IST", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, ),),
                            // SizedBox(width: 5,),
                            // Text(thailandTime, style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w500, ),),
                            // SizedBox(width: 2,),
                            // Text("ICT", style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w400, ),),
                          ],
                        ))
                  ],
                ),
              ),
              SizedBox(
                  height: 210,
                  width: double.infinity,
                  child: Consumer(
                    builder: (context, watch, _) {
                      final citiesFuture = watch.watch(advertisement);

                      return citiesFuture.when(
                        data: (response) {
                          final cities = response['advert'];

                          return SizedBox(
                            // Your desired size for the container
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cities.length,
                              itemBuilder: (context, index) {
                                final city = cities[index];

                                return AllPlaces(
                                  imagePath: city["image"],
                                  place: city['name'],
                                  onTab: () {},
                                );

/*
                                  RecomandedContent(
                                    imagePath: city["image"],
                                    place: city['name'],
                                    onTab: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (
                                                  context) => const CityInformation()));
                                    });
*/

                                /*ListTile(
                                title: Text(city['cityname']),
                                // Add other widgets to display additional information about the city, such as the image
                              );*/
                              },
                            ),
                          );
                        },
                        loading: () => Center(
                          child: Container(
                              height:50,
                              width:50,
                              child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => Text('Error: $error'),
                      );
                    },
                  )


/*
                ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    AllPlaces(
                      imagePath: "assets/images/pexels-chan-walrus-941869.jpg",
                      place: "advertisement",
                      onTab: () {},
                    ),
                    AllPlaces(
                      imagePath: "assets/images/pexels-chris-f-1283219.jpg",
                      place: " advertisement",
                      onTab: () {},
                    ),
                    AllPlaces(
                      imagePath: "assets/images/pexels-maurício-mascaro-1154189.jpg",
                      place: "advertisement",
                      onTab: () {},
                    ),
                    AllPlaces(
                      imagePath: "assets/images/orange.jpg",
                      place: "advertisement",
                      onTab: () {},
                    ),
                    AllPlaces(
                      imagePath: "assets/images/pexels-monstera-6620948.jpg",
                      place: "advertisement",
                      onTab: () {},
                    ),
                  ],
                ),
*/
              ),
              SizedBox(
                height: 10,
              ),
              BlurryContainer(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "About Thailand ",
                        style: GoogleFonts.notoSansAnatolianHieroglyphs(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
              SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Thailand\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '- Country in Southeast Asia\n'),
                    TextSpan(text: '- Bangkok (capital city)\n'),
                    TextSpan(text: '- Thai language\n'),
                    TextSpan(text: '- Buddhism (predominant religion)\n'),
                    TextSpan(
                        text: '- Thai cuisine (popular for its use of herbs and spices)\n'),
                    TextSpan(text: '- Tropical climate\n'),
                    TextSpan(
                        text: '- Beaches and islands (e.g. Phuket, Koh Samui, Krabi)\n'),
                    TextSpan(
                        text: '- Historical and cultural landmarks (e.g. Grand Palace, Wat Arun, Ayutthaya)\n'),
                    TextSpan(text: '- Famous for tourism industry\n'),
                    TextSpan(text: '- Elephants (national animal)\n'),
                    TextSpan(
                        text: '- King Rama IX (Bhumibol Adulyadej) - the longest-reigning monarch in Thai history\n'),
                    TextSpan(text: '- Songkran (Thai New Year festival)\n'),
                    TextSpan(
                        text: '- Tuk-tuks (three-wheeled motorized vehicles)\n'),
                    TextSpan(
                        text: '- Muay Thai (Thai boxing) - a popular martial art\n'),
                    TextSpan(
                        text: '- The River Kwai Bridge - a historic bridge located in Kanchanaburi province\n'),
                    TextSpan(
                        text: '- Thai silk - a type of fabric known for its beauty and durability\n'),
                    TextSpan(
                        text: '- Floating markets - where vendors sell goods from boats\n'),
                    TextSpan(
                        text: '- The Full Moon Party - a monthly beach party held on Koh Phangan island\n'),
                    TextSpan(
                        text: '- Tom Yum soup - a spicy and sour soup commonly found in Thai cuisine\n'),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: 16 / 9,
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
                        image: AssetImage('assets/images/newThai2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/newThai3.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              BlurryContainer(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  child: Row(children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Culture ",
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400),
                    ),
                  ])),
              SizedBox(
                height: 5,
              ),
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
                    child: Image.asset("assets/images/culture1.PNG",
                        fit: BoxFit.fill),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phi Ta Khon",
                        style: GoogleFonts.robotoSlab(
                            color: Colors.black, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("The Ghost Festival",
                          style: GoogleFonts.libreBaskerville(
                              letterSpacing: 1, color: Colors.blueGrey))
                    ],
                  ),
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '- Also known as the Ghost Festival or the Festival of Ghosts\n'),
                    TextSpan(
                        text: '- An annual Buddhist festival held in the Dan Sai district of Loei province, northeastern Thailand\n'),
                    TextSpan(
                        text: '- Celebrated during the first week of July\n'),
                    TextSpan(
                        text: '- Participants wear elaborate masks made of carved coconut-tree trunks and colorful costumes made of bright cloth\n'),
                    TextSpan(
                        text: '- The festival features parades, traditional music and dance, and a playful atmosphere\n'),
                    TextSpan(
                        text: '- The masks and costumes are inspired by local folklore and are meant to represent ghosts or spirits\n'),
                    TextSpan(
                        text: '- The festival is believed to have originated from a local legend involving the return of Buddha from heaven\n'),
                    TextSpan(
                        text: '- The festival is seen as a way to pay homage to local spirits and ancestors and to ensure a good harvest\n'),
                    TextSpan(
                        text: '- The festival is a popular tourist attraction and is recognized as an intangible cultural heritage by UNESCO\n'),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Songkran Festival",
                        style: GoogleFonts.robotoSlab(
                            color: Colors.black, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Water Festival",
                          style: GoogleFonts.libreBaskerville(
                              letterSpacing: 1, color: Colors.blueGrey))
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.25,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      child:
                      Image.asset("assets/images/wt.PNG", fit: BoxFit.fill))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '- Also known as the Thai New Year\n'),
                    TextSpan(text: '- Celebrated annually from April 13-15\n'),
                    TextSpan(
                        text: '- The festival marks the end of the dry season and the beginning of the rainy season\n'),
                    TextSpan(
                        text: '- Participants engage in a water fight using water guns, buckets, and hoses\n'),
                    TextSpan(
                        text: '- The water symbolizes purification and the washing away of sins and bad luck\n'),
                    TextSpan(
                        text: '- Many Thai people visit temples during the festival to offer food to the monks and participate in traditional ceremonies\n'),
                    TextSpan(
                        text: '- The festival is a time for family reunions and showing respect to elders\n'),
                    TextSpan(
                        text: '- The festival is also celebrated in other countries, such as Laos and Myanmar\n'),
                    TextSpan(
                        text: '- The festival is a major tourist attraction and draws visitors from around the world\n'),
                    TextSpan(
                        text: '- The festival is also known for its parties, particularly in tourist destinations such as Bangkok and Phuket\n'),
                  ],
                ),
              ),

              SizedBox(
                height: 5,
              ),
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
                    child: Image.asset("assets/images/culture2.PNG",
                        fit: BoxFit.fill),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Boon Bang Fai",
                        style: GoogleFonts.robotoSlab(
                            color: Colors.black, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Rocket Festival",
                          style: GoogleFonts.libreBaskerville(
                              letterSpacing: 1, color: Colors.blueGrey))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '- Also known as the Rocket Festival\n'),
                    TextSpan(
                        text: '- Celebrated in May each year in the northeastern region of Thailand\n'),
                    TextSpan(
                        text: '- The festival is meant to bring good luck and encourage the coming of the rainy season\n'),
                    TextSpan(
                        text: '- Participants construct homemade rockets and launch them into the sky\n'),
                    TextSpan(
                        text: '- The rockets are often decorated with colorful designs and carry offerings to the gods\n'),
                    TextSpan(
                        text: '- The festival also features parades, traditional music and dance, and a playful atmosphere\n'),
                    TextSpan(
                        text: '- The rockets are judged for their height, speed, and decoration\n'),
                    TextSpan(
                        text: '- The festival has its roots in ancient fertility rituals and is believed to have originated in Laos\n'),
                    TextSpan(
                        text: '- The festival is a way to celebrate local traditions and culture\n'),
                    TextSpan(
                        text: '- The festival is a popular tourist attraction and is recognized as an intangible cultural heritage by UNESCO\n'),
                  ],
                ),
              ),

              SizedBox(
                height: 5,
              ),
              BlurryContainer(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 1,
                  child: Row(children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "National Monuments",
                      style: GoogleFonts.notoSansAnatolianHieroglyphs(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400),
                    ),
                  ])),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.4,
                width: double.infinity,
                child: Image.asset("assets/images/budha.jpg", fit: BoxFit.fill),
              ),
              Text(
                "Big Buddha",
                style: GoogleFonts.robotoSlab(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(height: 5,),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '- Also known as the Phra Buddha Maha Nawamin\n'),
                    TextSpan(
                        text: '- Located in the province of Ang Thong, north of Bangkok\n'),
                    TextSpan(
                        text: '- Features a giant Buddha statue made of gold and bronze\n'),
                    TextSpan(
                        text: '- The statue is 92 meters tall, making it one of the largest Buddha statues in the world\n'),
                    TextSpan(
                        text: '- The statue sits on a pedestal that is 15 meters high, making the total height of the monument 107 meters\n'),
                    TextSpan(
                        text: '- The statue was completed in 2008 after 18 years of construction\n'),
                    TextSpan(
                        text: '- The monument is a popular tourist attraction and a symbol of Thai Buddhism\n'),
                    TextSpan(
                        text: '- Visitors can climb stairs to reach the base of the statue and enjoy panoramic views of the surrounding area\n'),
                    TextSpan(
                        text: '- The monument is also home to a museum showcasing Buddhist art and history\n'),
                    TextSpan(
                        text: '- The monument is a testament to the craftsmanship and dedication of the Thai people\n'),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.4,
                width: double.infinity,
                child:
                Image.asset("assets/images/monument.jpg", fit: BoxFit.fill),
              ),
              Text(
                "The Sanctuary Of Truth",
                style: GoogleFonts.robotoSlab(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              SizedBox(height: 5,),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'The Sanctuary of Truth\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '- A wooden temple and museum located in Pattaya, Thailand\n'),
                    TextSpan(
                        text: '- Constructed entirely of teak wood, the temple is a stunning example of traditional Thai architecture\n'),
                    TextSpan(
                        text: '- The temple was started in 1981 and is still under construction today\n'),
                    TextSpan(
                        text: '- The temple is dedicated to traditional Thai religious and philosophical beliefs\n'),
                    TextSpan(
                        text: '- The temple features intricate carvings and sculptures depicting mythological figures and scenes from Buddhist and Hindu mythology\n'),
                    TextSpan(
                        text: '- The temple is a symbol of the traditional Thai culture and a reminder of the importance of art in everyday life\n'),
                    TextSpan(
                        text: '- The temple is open to visitors and offers guided tours and cultural performances\n'),
                    TextSpan(
                        text: '- The temple is a popular tourist attraction in Pattaya and a unique cultural experience\n'),
                    TextSpan(
                        text: '- The temple is a tribute to the beauty and grandeur of Thai architecture and craftsmanship\n'),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.zero,
                color: Colors.red,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.4,
                width: double.infinity,
                child: Image.asset("assets/images/monument3.PNG",
                    fit: BoxFit.fill),
              ),
              SizedBox(height: 5,),
              Text(
                "Phuket Heroines Monument",
                style: GoogleFonts.robotoSlab(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Phuket Heroines Monument\n',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '- A statue monument located in Phuket, Thailand\n'),
                    TextSpan(
                        text: '- Commemorates two sisters who led the local people in defending the island against a Burmese invasion in the 18th century\n'),
                    TextSpan(
                        text: '- The sisters, Thao Thep Krasattri and Thao Sri Sunthon, are regarded as heroines in Thai history\n'),
                    TextSpan(
                        text: '- The monument was built in 1967 and is a popular tourist attraction\n'),
                    TextSpan(
                        text: '- The monument is made of brass and stands at 2.75 meters tall\n'),
                    TextSpan(
                        text: '- The statue features the sisters standing back to back, holding a sword and a baby, respectively\n'),
                    TextSpan(
                        text: '- The monument serves as a reminder of the bravery and sacrifice of the local people in defending their homeland\n'),
                    TextSpan(
                        text: '- The monument is a symbol of pride and unity for the people of Phuket\n'),
                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      elevation: 2,
      backgroundColor: Colors.grey[300],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: ListView(
        children: [
          DrawerHeader(

            child: Column(

              children: [
                ClipOval(
                    child:
                    AppPreferences.getUserProfile() != null && AppPreferences
                        .getUserProfile()
                        .isNotEmpty
                        ?
                    Image.network(
                      AppPreferences.getUserProfile(), height: 70, width: 70,)
                        :
                    Image.asset(
                      "assets/icons/user.png", height: 70, width: 70,)
                ),
                Text(
                  AppPreferences.getUserDisplayName(),
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 17, letterSpacing: 2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    Text(
                      AppPreferences.getUserEnail()!,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 12, letterSpacing: 2),
                    ),
                    SizedBox(height: 10,)
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.blueGrey,
            ),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blueGrey),
            title: Text("Profile", style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserProfile()));
            },
          ),
/*
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blueGrey),
            title: Text(
              'Thai Calender',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ThaiCalender()));
            },
          ),
*/
          ListTile(
            leading: const Icon(Icons.speaker, color: Colors.blueGrey),
            title: Text(
              'Translator',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LanguageTranslator()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_page, color: Colors.blueGrey),
            title: Text(
              'ContactUs',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUs()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shop, color: Colors.blueGrey),
            title: Text(
              'Add shop',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddShop()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.blueGrey),
            title: Text(
              'HelpUs',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpUs()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.blueGrey),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
            onTap: () async {
              await AuthLogout().logout();
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.blueGrey),
            title: Text(
              'Delete Account',
              style: GoogleFonts.poppins(),
            ),
            onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeleteAccount()),
                );
            },
          ),


        ],
      ),
    );
  }

  Future<Map<String, dynamic>> fetchCurrencyData() async {
    Dio dio = Dio();
    String url = 'https://test.pearl-developer.com/thaitours/public/api/get-currency'; // Replace with your actual API endpoint

    try {
      Response response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer ${AppPreferences.getUserId()}'
        }),
      );

      if (response.statusCode == 200) {
        print(
            "ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt${response
                .data}");
        print("indianCurency${response.data['currency']['indiancurrency']}");
        print("thaiCurrency${response.data['currency']['thailandcurrency']}");

        setState(() {
          inr = response.data["currency"]["indiancurrency"];
          thb = response.data["currency"]["thailandcurrency"];
        });


        print("jjjjjjjjjj${inr}");
        print("kkkkkkkk${thb}");
        return response.data;
      } else {
        throw Exception('Failed to fetch currency data');
      }
    } catch (e) {
      throw Exception('Failed to fetch currency data');
    }
  }

    final advertisement = FutureProvider((ref) async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
    'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.get(
          'https://test.pearl-developer.com/thaitours/public/api/get-advertisements');
      print(
          "#################################################################################categoryResponse${response
              .data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  });


  showDialogBox() =>
      showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: const Text('No Connection'),
              content: const Text('Please check your internet connectivity'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() => isAlertSet = false);
                    isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected && isAlertSet == false) {
                      showDialogBox();
                      setState(() => isAlertSet = true);
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
  final aboutCountry = FutureProvider((ref) async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
    'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.get(
          'https://test.pearl-developer.com/thaitours/public/api/about-country');
      print(
          "#################################################################################categoryResponse${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  });

}


