import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:namastethailand/AddShop/registerShopStatus.dart';

class AddShop extends StatelessWidget {
  const AddShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Shop"),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/blurBackground.jpg"),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: BlurryContainer(
              elevation: 10,
              color: Colors.white.withOpacity(0.5),
              width: MediaQuery.of(context).size.width*0.8,
              height:MediaQuery.of(context).size.height*0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Register your Shop in", style: GoogleFonts.poppins(color:Colors.black, fontSize: 17, fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  Text("Namaste Thailand", style: GoogleFonts.playfairDisplay(wordSpacing: 1, color: Colors.orangeAccent, fontWeight: FontWeight.w800, fontSize: 22)),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      border: Border.all(
                        width: 2, color: Color(0xFF000080)
                      )
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Shop name',
                        prefixIcon: Icon(Icons.shop),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),

                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                        border: Border.all(
                            width: 2, color: Color(0xFF000080)
                        )
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Shop type',
                        prefixIcon: Icon(Icons.type_specimen),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),

                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                        border: Border.all(
                            width: 2, color: Color(0xFF000080)
                        )
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'city',
                        prefixIcon: Icon(Icons.location_city),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),

                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                        border: Border.all(
                            width: 2, color: Color(0xFF000080)
                        )
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'place',
                        prefixIcon: Icon(Icons.place),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),

                  ),

                  SizedBox(height: 15,),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  RegisterStatus()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Procced",),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
