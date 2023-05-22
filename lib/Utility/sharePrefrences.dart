


import 'package:shared_preferences/shared_preferences.dart';


class AppPreferences {
  // static late String? langValue;
   static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }



  /// setUserProfile
  static void setUserProfile(String userId, String displayName, String userEmail, String photoUrl, String phone_no) {
    _preferences.setString("userId", userId);
    _preferences.setString("displayName", displayName);
    _preferences.setString("userEmail", userEmail);
    _preferences.setString("userProfileUrl", photoUrl);
    _preferences.setString("mobile_no", phone_no);

  }
   static String getUserPhoneNo() {

     String? s = _preferences.getString("mobile_no") ?? null;
     return s!;
   }
  static String getUserProfile() {

    String? s = _preferences.getString("userProfileUrl") ?? null;
    return s!;
  }
  static String getUserId() {

    String? s = _preferences.getString("userId") ?? 'Loading';
    return s!;
  }
  static String? getUserEnail() {

    String? s = _preferences.getString("userEmail") ?? 'Loading';
    return s!;
  }
  static String getUserDisplayName() {

    String? s = _preferences.getString("displayName") ?? null;
    return s!;
  }

  static void clear() {
    _preferences.clear();
  }
}