import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namastethailand/CreateAccount/signUp.dart';
import 'package:namastethailand/Dashboard/dashboard.dart';
import 'package:namastethailand/widet/appleApi.dart';
import 'package:namastethailand/widet/otpForFogetPassword.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';
import 'UserProfile/otpScreen.dart';
import 'Utility/sharePrefrences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  Future<void> signInWithGooogle() async {
    print("method running 1");
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    print("method running 2");

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    print("method running 3");

    if (googleUser != null &&
        googleUser.id != null &&
        googleUser.displayName != null &&
        googleUser.email != null &&
        googleUser.photoUrl != null) {
      // User is signed in and has all the required properties
      AppPreferences.setUserProfile(googleUser.id, googleUser.displayName!,
          googleUser.email, googleUser.photoUrl!, "phoneNo");
      print("User signed in successfully");
    } else {
      // User is not signed in or is missing required properties
      print("User sign-in failed or missing required properties");
    }
  }

  Dio dio = Dio();

  void _onSubmit() async {
    // Validate form data
    EasyLoading.show(status: "please wait");
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all the fields')),
      );
      return;
    }

    // Make a POST request to the SignUp API
    try {
      final response = await dio.post(
        'https://test.pearl-developer.com/thaitours/public/api/login',
        data: {
          'email': _emailController.text,
          'type': "normal",
          'password': _passController.text,
        },
      );

      String userId = response.data["token"];
      String displayName = response.data['user']['name'];
      String userEmail = response.data['user']['email'];
      String phone_no = response.data['user']['mobile_no'];

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        print(
            "signUpUserdata455555555555555555555555555555555555555555555555555555555555555555555555${response.data["token"]}");
        AppPreferences.setUserProfile(
            userId, displayName, userEmail, "", phone_no);
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const Dashboard(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome to Thailand tour')),
        );
      } else {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SignUp failed')),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SignUp failed')),
      );

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // email
                // password
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset("assets/icons/namasteThai.png"),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: 'Email'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextField(
                              controller: _passController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: 'Password'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            _onSubmit();
                          },
                          child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
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
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtpScreenForgetPassword(
                                                      email: _emailController.text
                                                          .toString())),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("Forget your password")),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Not a member?',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 17,
                                  letterSpacing: 1)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            child: Text('Register',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17,
                                    color: Colors.blue,
                                    letterSpacing: 1)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Colors.blueGrey,
                          )),
                          Text(
                            "Or Login With",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                letterSpacing: 1),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.blueGrey,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Platform.isIOS?
                          BlurryContainer(
                            height: 70,
                            width: 70,
                            blur: 10,
                            elevation: 1,
                            color: Colors.white,
                            padding: EdgeInsets.all(25),
                            child: Icon(
                              Icons.apple,
                              color: Colors.black,
                            ),
                          ):


                          GestureDetector(
                            onTap: () async {
                              print("GoogleButton");
                              await signInWithGooogle();
                              if (mounted) {
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        Dashboard(),
                                  ),
                                );
                              }
                            },
                            child: GestureDetector(
                              onTap: () async{
                                try {

                                  final credential = await SignInWithApple.getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );
                                  if (credential.identityToken != null) {
                                    final MyResponse? response = await Api.signInWithOptions(
                                      email: credential.email ?? '',
                                      idToken: credential.identityToken ?? '',
                                      name: '${credential.givenName} ${credential.familyName}' ?? '',
                                      type: 'apple',
                                    );
                                    print(response);
                                    // Handle the response accordingly
                                  }
                                  else {
                                    EasyLoading.showError('Canceled by user',
                                        duration: Duration(seconds: 3));
                                  }
                                  //credential.
                                }catch (exception) {
                                  EasyLoading.showError(exception.toString(),
                                      duration: Duration(seconds: 3));
                                  print(
                                      'error error - ' + exception.toString());
                                }
                              },
                              child: BlurryContainer(
                                height: 70,
                                width: 70,
                                blur: 10,
                                elevation: 1,
                                color: Colors.white,
                                padding: EdgeInsets.all(25),
                                child: Image.asset("assets/icons/google.png"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
