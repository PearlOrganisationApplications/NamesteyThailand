import 'dart:convert';
import 'package:dio/dio.dart';

class Api {
  static Future<MyResponse?> signInWithOptions({
    required String email,
    required String idToken,
    required String name,
    required String type,
  }) async {
    final apiUrl = 'https://test.pearl-developer.com/thaitours/public/api/login';

    final dio = Dio();
    try {
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: json.encode({
          'email': email,
          'client_token': idToken,
          'username': name,
          'type': type,
        }),
      );

      if (response.statusCode == 200) {
        // Sign in with options successful
        // Parse and return the response
        return MyResponse.fromJson(json.decode(response.data));
      } else {
        // Sign in with options failed
        // Handle the failure scenario accordingly
        print('Sign in with options failed. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      // Handle any exceptions or errors that occur during the API call
      print('An error occurred during the API call: $error');
      return null;
    }
  }
}

class MyResponse {
  // Define the properties of the custom response class
  // based on the expected response from the API

  MyResponse.fromJson(Map<String, dynamic> json) {
    // Parse the JSON data and assign values to the properties
  }
}
