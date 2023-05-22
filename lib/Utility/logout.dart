import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';

class AuthLogout{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> logout() async {
    // sign out from Firebase
    await auth.signOut();

    // sign out from Google
    await googleSignIn.signOut();
    AppPreferences.clear();
  }
}