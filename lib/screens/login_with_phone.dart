import 'package:country_picker/country_picker.dart';
import 'package:fb_login/screens/verify_phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phoneCotroller = TextEditingController();
  final auth=FirebaseAuth.instance;
  bool isLoading=false;
  String countryCode='';
  String txt='+';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height:100,),
          const Center(
            child: Image(height: 150, image: AssetImage('assets/phone.png')),
          ),
          const SizedBox(height:30,),
          const Text(
            'Enter your phone number',
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'We will sent you 6 digit verification code',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: TextField(
              controller: phoneCotroller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon:InkWell(
                    onTap:(){
                      showCountryPicker(context: context, onSelect:(Country value){
                        countryCode=value.phoneCode.toString();
                      });
                      setState(() {
                      });
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(15),
                      child: countryCode==''?const Text('+00'):Text(txt+countryCode),
                    )),
                  labelText: 'Mobile',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),

          SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                  backgroundColor:const Color(0xffFFB900),
                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(10),
                  )
                ),
                  onPressed: () {

                  var phone=txt+countryCode+phoneCotroller.text;
                    setState(() {
                      isLoading=true;
                    });
                  auth.verifyPhoneNumber(
                    phoneNumber:phone,
                      verificationCompleted:(_)
                      {
                        setState(() {
                          isLoading=false;
                        });
                      },
                      verificationFailed: (e)
                      {
                       Fluttertoast.showToast(msg:e.toString());
                       setState(() {
                         isLoading=false;
                       });
                      },
                      codeSent:(String verificationId, int? token)
                      {
                        Navigator.push(context, MaterialPageRoute(
                            builder:(context)=>VerifyPhoneNumber(verificationId: verificationId)));
                        setState(() {
                          isLoading=false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e)
                      {
                        Fluttertoast.showToast(msg:e.toString());
                        setState(() {
                          isLoading=false;
                        });
                        });

                  },
                  child:isLoading?const CircularProgressIndicator():const Text(
                    'Generate OTP',
                    style: TextStyle(
                      fontSize:18
                    ),
                  )))
        ],
      ),
    );
  }
}
