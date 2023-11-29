import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool SecurePassword = true;
  bool SecureConfirmPassword = true;
  final FullName = TextEditingController();
  final Email = TextEditingController();
  final Password = TextEditingController();
  final ConfirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFB900),
      body: Column(
        children: [
          const Center(
              child: Image(
            image: AssetImage('assets/Signup.png'),
            height: 270,
          )),
          Expanded(
            child: Container(
              height: 500,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(70))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        controller: FullName,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.supervised_user_circle,
                                color: Color(0xffFFB900)),
                            hintText: 'Enter Name',
                            labelText: 'Full Name',
                            labelStyle: const TextStyle(
                                color: Color(0xffFFB900), fontSize: 18),
                            fillColor: Colors.grey.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffFFB900))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffFFB900)))),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        controller: Email,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email,
                                color: Color(0xffFFB900)),
                            hintText: 'Enter Email',
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                                color: Color(0xffFFB900), fontSize: 18),
                            fillColor: Colors.grey.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffFFB900))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffFFB900)))),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        controller: Password,
                        obscureText: SecurePassword,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password,
                                color: Color(0xffFFB900)),
                            suffixIcon: IconButton(
                              color: const Color(0xffFFB900),
                              icon: Icon(SecurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  SecurePassword = !SecurePassword;
                                });
                              },
                            ),
                            hintText: 'Enter Password',
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                color: Color(0xffFFB900), fontSize: 18),
                            fillColor: Colors.grey.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffFFB900))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffFFB900)))),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        controller: ConfirmPassword,
                        obscureText: SecureConfirmPassword,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.paste_sharp,
                                color: Color(0xffFFB900)),
                            suffixIcon: IconButton(
                              color: const Color(0xffFFB900),
                              icon: Icon(SecureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  SecureConfirmPassword=!SecureConfirmPassword;
                                });
                              },
                            ),
                            hintText: 'Confirm Password',
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(
                                color: Color(0xffFFB900), fontSize: 18),
                            fillColor: Colors.grey.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffFFB900))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffFFB900)))),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(

                          onTap: () async{
                            var FarmValid=true;
                            var fullName=FullName.text;
                            var email=Email.text;
                            var password=Password.text;
                            var confirmPassword=ConfirmPassword.text;
                            if(fullName.isEmpty)
                            {
                              Fluttertoast.showToast(msg: 'Please Enter Your Name');
                              FarmValid=false;
                            }
                            if(email.isEmpty)
                            {
                              Fluttertoast.showToast(msg:'Enter Email');
                              FarmValid=false;
                            }
                            if(password.isEmpty)
                            {
                              Fluttertoast.showToast(msg:'Enter Password');
                              FarmValid=false;
                            }
                            if(confirmPassword.isEmpty)
                            {
                              Fluttertoast.showToast(msg:'Enter Conf Password');
                              FarmValid=false;
                            }
                            if(password.length<5)
                            {
                              Fluttertoast.showToast(msg:'Password Must Be 5 Digit');
                              FarmValid=false;
                            }
                            if(password!=confirmPassword)
                            {
                              Fluttertoast.showToast(msg:'Passwords Do Not Match');
                              FarmValid=false;
                            }
                            if(FarmValid==false)
                            {
                              return;
                            }
                            ProgressDialog progressDialog=ProgressDialog(
                              context,
                              message: const Text('Signing Up',style:TextStyle(color:Color(0xffFFB900)),),
                              title: const Text('Please Wait...',style:TextStyle(color:Color(0xffFFB900)),),
                            );
                            progressDialog.show();
                            FirebaseAuth firebase=FirebaseAuth.instance;
                            try
                            {
                              UserCredential userCredential=await firebase.createUserWithEmailAndPassword(
                                  email:email,
                                  password:password
                              );
                              User? user =userCredential.user;
                              if(user != null)
                                {
                                  //we save record in real time data base
                                  final databaseRefrence=FirebaseDatabase.instance.reference();
                                  await databaseRefrence.child('users').child(user.uid).set(
                                    {
                                      'uid':user.uid,
                                      'name': fullName,
                                      'email': email,
                                      'dt': DateTime.now().microsecondsSinceEpoch,
                                      'profileImage': '',
                                      'password': password,
                                    }

                                  );
                                  Fluttertoast.showToast(msg: 'Sign Up Successful');
                                  Navigator.of(context).pop();
                                  progressDialog.dismiss();
                                }
                            }
                            on FirebaseAuthException catch(e)
                            {
                              progressDialog.dismiss();
                              if(e.code=='weak-password')
                              {
                                Fluttertoast.showToast(msg:'Weak Password');
                              }
                              else if(e.code=='email-already-in-use')
                              {
                                Fluttertoast.showToast(msg: 'Email Allready In Used');
                              }
                            }
                            catch(e)
                            {
                              progressDialog.dismiss();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                                color: const Color(0xffFFB900),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 3),
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ]),
                            child: const Center(
                                child: Text(
                                  'SignUp',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontFamily: 'Roboto-Medium',
                                      letterSpacing: 2),
                                )),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
