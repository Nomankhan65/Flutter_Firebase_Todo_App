import 'dart:ffi';
import 'dart:io';
import 'package:fb_login/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../models/user_model.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  bool localImage=false;
  UserModel? userModel;
  User? user;
  DatabaseReference? userRef;
  getUserDetail() async {
    if (userRef != null) {
      try {
        DatabaseEvent event = await userRef!.once();
        DataSnapshot dataSnapshot = event.snapshot;

        if (dataSnapshot.value != null) {
          userModel = UserModel.fromJson(Map<String, dynamic>.from(dataSnapshot.value! as Map));
          setState(() {
            // Update your UI or do something with userModel
          });
        }
      } catch (error) {
        // Handle error if there's any
        print("Error fetching user detail: $error");
      }
    }
  }




  pickImageGallery()async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;

    final tempImage = File(xFile.path);
    image = tempImage;
    localImage = true;
    setState(() {
    });

    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: Text('Uploading !!!'),
      message: Text('Please wait'),
    );
    progressDialog.show();
    // upload to firebase storage

    var fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    UploadTask uploadTask = FirebaseStorage.instance.ref().child(fileName).putFile(image!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);

    // update user in realtime database

    if (userRef != null) {
      userRef!.update(
        {
          'profileImage': imageUrl,
        },
      );
    }

    progressDialog.dismiss();
  }
  pickImageCamera()async{
    XFile? xFile=await ImagePicker().pickImage(source: ImageSource.camera);
    if(xFile==null)return;
    final temImage=File(xFile.path);
    image=temImage;
    localImage=true;
    setState(() {

    });
  }
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef = FirebaseDatabase.instance.reference().child('users').child(user!.uid);
    }
    getUserDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor:const Color(0xffFFB900),
            appBar:AppBar(
              systemOverlayStyle:const SystemUiOverlayStyle(
                statusBarColor:Colors.transparent,
                statusBarBrightness:Brightness.dark,
              ),
              actions:[
                Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: IconButton(onPressed: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Gallery'),
                                  onTap: () {
                                    pickImageGallery();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    pickImageCamera();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        }
                    );
                  }, icon:const Icon(Icons.camera_alt,size:35,),),
                )
              ],
              backgroundColor:Colors.transparent,
              elevation:0,
            ),
            body:userModel==null?const Center(child:CircularProgressIndicator(),):
            Stack(
              alignment:Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:100),
                  child: Container(
                    height:double.infinity,
                    width:double.infinity,
                    decoration: const BoxDecoration(
                      color:Colors.white,
                      borderRadius:BorderRadius.only(topLeft:Radius.circular(30),topRight:Radius.circular(30)),
                    ),
                  ),
                ),
                Positioned(
                  top:20,
                  child: Container(
                    height:160,
                    width:160,
                    decoration:  BoxDecoration(
                      shape:BoxShape.circle,
                      color:Colors.white,
                      border:Border.all(
                        width:3,
                        color:Colors.white,
                      ),
                      boxShadow:[
                        BoxShadow(
                          color:Colors.black.withOpacity(0.2),
                          blurRadius:10,
                          offset:Offset(0,5)

                        )
                      ]
                    ),
                    child: ClipOval(
                    child:localImage==true?Image.file(image!,height:125,width:125,fit:BoxFit.cover,)
                        :Image.network(
                      userModel!.profileImage == ''?'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU'
                          : userModel!.profileImage.toString(),
                      height:125,
                      width:125,
                      fit: BoxFit.cover,
                    ),
                ),
                  ),),
                Padding(
                  padding: const EdgeInsets.only(top:200 ),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children:[
                      Text(userModel!.name.toString(),style:const TextStyle(fontSize:25,color:Colors.black87),),
                      const SizedBox(height:5,),
                      Text(userModel!.email.toString(),style:const TextStyle(color:Colors.black54),),
                      const SizedBox(height:50,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,250, 20, 10),
                  child: Container(
                      width:double.infinity,
                      height:MediaQuery.of(context).size.height*0.45,
                      decoration:const BoxDecoration(
                        border:Border(
                          bottom:BorderSide(
                            width:2,
                            color:Color(0xffFFB900),
                          )
                        )
                      ),
                    child:GridView(
                        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3),
                      children: const [
                        Icon(Icons.home,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.task,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.settings,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.logout,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.add_task,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.delete,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.edit,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.person,size:40,color:Color(0xffFFB900),),
                        Icon(Icons.logout,size:40,color:Color(0xffFFB900)),

                      ],
                    )
                  ),
                )
              ],
            ),

           );
  }  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd-MMM-yyyy').format(dateTime);
  }

}
