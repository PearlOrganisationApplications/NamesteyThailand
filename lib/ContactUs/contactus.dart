import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:
      AppBar(
        title: Text("Contact Us"),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      backgroundColor:Colors.grey[200],
      body: SafeArea(
          child: Center(
            child: BlurryContainer(elevation: 1,
              color: Colors.grey.shade300,
              height: MediaQuery.of(context).size.height*0.5,
              width: MediaQuery.of(context).size.width*0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Text("Get In Touch", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),),
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.white70,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.white70,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    maxLines: 100,
                    minLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _message = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a message';
                      }
                      return null;
                    },
                  ),
                ),
              ),


                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: (){}, child: Text("Send"))
                  ],
                ),


            ),
      )),

    );
  }
}
