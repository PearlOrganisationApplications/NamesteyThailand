import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPasswordSet extends StatefulWidget {
  @override
  _NewPasswordSetState createState() => _NewPasswordSetState();
}

class _NewPasswordSetState extends State<NewPasswordSet> {
  final _formKey = GlobalKey<FormState>();
  late String _newPassword;
  late String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'New Password',
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                    ),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter new password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newPassword = value!;
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm password';
                      } else if (value != _newPassword) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _confirmPassword = value!;
                    },
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // TODO: Reset password logic goes here
                      }
                    },
                    child: Text('Reset Password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}