

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namastethailand/UserProfile/otpScreen.dart';
import 'package:namastethailand/login.dart';
import '../Utility/logout.dart';
import '../Utility/sharePrefrences.dart';


class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: AppPreferences.getUserEnail());
  String name = '';
  String phoneNumber = '';
  late String _email;
  final ImagePicker _picker = ImagePicker();



  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  XFile? imagess;
  void pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() => imagess = image);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () {
                // Update the data using the name and phone number fields
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  TextEditingController email_controller = TextEditingController();
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.4,
                ),
                Positioned(
                   top: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: BottomClipper(),
                      child: Container(
                        color: Colors.orangeAccent,
                        height: MediaQuery.of(context).size.height*0.35,
                      ),
                    )),
                Positioned(
                    left:0,
                    right: 0,
                    bottom: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.all(Radius.circular(70))
                        ),
                        child:
                        ClipOval(
                          child: Stack(
                            children: [
                              // User profile image
                              AppPreferences.getUserProfile() != null && AppPreferences.getUserProfile().isNotEmpty
                                  ? Image.network(AppPreferences.getUserProfile(), height: 150, width: 150)
                                  : Image.asset('assets/icons/user.png', height: 150, width: 150),
                              // Camera icon
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      iconSize: 40,
                                      onPressed: () {
                                        pickImage();
                                      },
                                      icon: Icon(Icons.camera_alt),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
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
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Icon(Icons.arrow_back,color: Colors.white),

                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () async {
                      await AuthLogout().logout();
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 30,


                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Icon(Icons.logout,color: Colors.white),

                    ),
                  ),
                ),

              ],
            ),
              SizedBox(height: 10,),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8),
             child: Column(
               children: [
                 Container(
                   height: 40,
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Colors.blueGrey
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Icon(Icons.person,color: Colors.white,),
                       SizedBox(width: 10,),
                       Text(AppPreferences.getUserDisplayName(),textAlign: TextAlign.center, style: GoogleFonts.ptSerif(
                         fontSize: 17,
                         color: Colors.white
                       ),),
                     ],
                   ),
                 ),
                 SizedBox(height: 10,),
                 Container(
                   height: 40,
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: Colors.blueGrey
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Icon(Icons.email,color: Colors.white,),
                       SizedBox(width: 10,),
                       Text(AppPreferences.getUserEnail()!,textAlign: TextAlign.center, style: GoogleFonts.ptSerif(
                           fontSize: 17,
                           color: Colors.white
                       ),),
                       IconButton(
                         icon: Icon(Icons.edit),
                         color: Colors.white,
                         onPressed: () {
                           showDialog(
                             context: context,
                             builder: (context) {
                               return AlertDialog(
                                 title: Text('Enter your email'),
                                 content: TextFormField(
                                   controller: _emailController,

                                   decoration: InputDecoration(
                                     hintText: 'Email',
                                   ),

                                 ),
                                 actions: [
                                   TextButton(
                                     child: Text('Next'),
                                     onPressed: () {
                                       Navigator.pushReplacement(
                                         context,
                                         MaterialPageRoute(builder: (context) => OtpScreen(email: _emailController.text.toString())),
                                       );
                                     },
                                   ),
                                 ],
                               );
                             },
                           );
                         },
                       )

                     ],
                   ),
                 ),
                 SizedBox(height: 10,),
                 Container(
                   height: 40,
                   padding: EdgeInsets.symmetric(horizontal: 10),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: Colors.blueGrey
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Icon(Icons.phone,color: Colors.white,),
                       SizedBox(width: 10,),
                       Text("9185698745",textAlign: TextAlign.center, style: GoogleFonts.ptSerif(
                           fontSize: 17,
                           color: Colors.white
                       ),),

                     ],
                   ),
                 ),
                 SizedBox(height: 15,),
                InkWell(
                  onTap: (){
                    _showUpdateDialog();
                  },
                  child: BlurryContainer(
                    elevation: 20,
                    width: double.infinity,
                    height: 50,
                    color: Colors.orangeAccent,
                    child: Center(
                      child: Text("UPDATE",textAlign: TextAlign.center, style: GoogleFonts.ptSerif(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1
                  ),),
                    ), ),
                )
               ],
             ),
           )
          ],
        ),
      ),
    );
  }
}


class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}