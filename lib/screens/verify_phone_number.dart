import 'package:fb_login/screens/task_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
class VerifyPhoneNumber extends StatefulWidget {
  String verificationId;
    VerifyPhoneNumber({Key? key,required this.verificationId}) : super(key: key);

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final codeController = TextEditingController();
  final auth=FirebaseAuth.instance;
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
            child: Image(height: 150, image: AssetImage('assets/verify.png')),
          ),
          const SizedBox(height:30,),
          const Text(
            'OTP Verification',
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Enter the OTP sent to your phone',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
            const SizedBox(height:40,),
            PinCodeTextField(
            controller:codeController,
            maxLength:6,
            pinBoxHeight:50,
            pinBoxWidth:50,
          ),
          const SizedBox(height:50,),
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
                  onPressed: () async{
                    final credential=PhoneAuthProvider.credential(
                        verificationId:widget.verificationId,
                        smsCode:codeController.text.toString());
                    try{
                     await auth.signInWithCredential(credential);
                      Navigator.push(context,
                      MaterialPageRoute(builder:(_)=>Home())
                      );
                    }
                    catch(e)
                    {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: const Text(
                    'Verify & Continue',
                    style: TextStyle(
                        fontSize:18
                    ),
                  )))
        ],
      ),
    );
  }
}
