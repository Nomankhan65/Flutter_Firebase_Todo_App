import 'package:fb_login/screens/login_with_phone.dart';
import 'package:fb_login/screens/task_list_screen.dart';
import 'package:fb_login/screens/SignUp_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool SecurePass=true;
  final Password=TextEditingController();
  final Email=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffFFB900),
          systemNavigationBarColor:Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/Logo.png'),
                          ),
                          color: Color(0xffFFB900),
                        )),
                    Positioned(
                        top: 260,
                        child: Container(
                          width: 412,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
                Text('SIGNIN',
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Roboto-Bold',
                        letterSpacing: 3,
                        color: const Color(0xffFFB900),
                        shadows: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 5,
                              spreadRadius: 5,
                              offset: const Offset(1, 2))
                        ])),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller:Email,
                    keyboardType:TextInputType.emailAddress,
                    decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xffFFB900)),
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
                            borderSide:
                                const BorderSide(color: Color(0xffFFB900)))),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller:Password,
                    obscureText:SecurePass,
                    keyboardType:TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.password, color: Color(0xffFFB900)),
                        suffixIcon: IconButton(
                          color: const Color(0xffFFB900),
                          icon: Icon(SecurePass?Icons.visibility_off:Icons.visibility),
                          onPressed: () {
                            setState(() {
                              SecurePass=!SecurePass;
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
                            borderSide:
                                const BorderSide(color: Color(0xffFFB900)))),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'Forgot Passwrd!',
                        style: TextStyle(fontSize: 17, color: Color(0xffFFB900)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    var password=Password.text;
                    var email=Email.text;
                    var Farmvalid=true;
                    if(email.isEmpty)
                      {
                        Fluttertoast.showToast(msg:'Plz Enter Email');
                        Farmvalid=false;
                      }
                    if(password.isEmpty)
                      {
                        Fluttertoast.showToast(msg:'Plz Enter Password');
                        Farmvalid=false;
                      }
                    if(Farmvalid==false)
                      {
                        return;
                      }
                    ProgressDialog Progress= ProgressDialog(
                        context,
                        title:const Text('Signing In',style:TextStyle(color:Color(0xffFFB900)),),
                        message:const Text('Please Wait...',style:TextStyle(color:Color(0xffFFB900)),)
                    );
                    Progress.show();
                    FirebaseAuth FBauth=FirebaseAuth.instance;
                    try{
                      UserCredential Usercredential=await FBauth.signInWithEmailAndPassword(
                          email:email,
                          password:password);
                      Progress.dismiss();
                      User? user=Usercredential.user;
                      if(user !=null)
                        {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)
                          {
                            return Home();
                          }));
                        }
                    }on FirebaseAuthException catch(e){
                      Progress.dismiss();
                      if(e.code=='user-not-found')
                        {
                          Fluttertoast.showToast(msg:'Inavalid Email');
                        }
                      else if(e.code=='wrong-password')
                        {
                          Fluttertoast.showToast(msg:'Inavalid Password');
                        }
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
                            offset: Offset(0, 3),
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ]),
                    child: const Center(
                        child: Text(
                      'SignIn',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontFamily: 'Roboto-Medium',
                          letterSpacing: 2),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don,t have account?',
                      style: TextStyle(color: Color(0xffFFB900), fontSize: 17),
                    ),
                    TextButton(
                        onPressed:(){
                          Navigator.of(context).push(MaterialPageRoute(builder:(ctx)
                          {
                            return const SignUp();
                          }));
                        },
                        child:const Text('SignUp',style:TextStyle(fontSize:17,color:Colors.blue),)
                    )
                  ],
                ),
                const SizedBox(height:20,),
                SizedBox(
                  height:45,
                  child: OutlinedButton(
                    style:OutlinedButton.styleFrom(
                      side:const BorderSide(
                        color:Color(0xffFFB900)
                      ),

                    ),
                      onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>const LoginWithPhone()));
                  }, child:const Text('Login with phone number',style:TextStyle(color:Color(0xffFFB900),fontSize:17),)),
                )
              ],
            ),
          )),
    );
  }
}
