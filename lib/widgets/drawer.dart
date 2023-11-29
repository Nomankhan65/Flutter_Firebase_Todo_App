import 'package:fb_login/models/drawer_model.dart';
import 'package:fb_login/screens/add_task_screen.dart';
import 'package:fb_login/screens/profile_screen.dart';
import 'package:fb_login/screens/task_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Model? model;
  User? user;
  DatabaseReference? userRef;

  getUserDetail() async {
    if (userRef != null) {
      try {
        DatabaseEvent dataSnapshot = await userRef!.once();

        if (dataSnapshot.snapshot != null) {
          model = Model.fromJson(Map<String, dynamic>.from(dataSnapshot.snapshot! as Map));
          setState(() {});
        }
      } catch (error) {
        // Handle error if any
        print("Error fetching user detail: $error");
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef =
          FirebaseDatabase.instance.reference().child('users').child(user!.uid);
    }
    getUserDetail();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:model==null?const Center(child: CircularProgressIndicator(
        color:Colors.orange,
      ))
          :ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xffFFB900),
            ),
            accountName: Text(
              model!.name,
              style: const TextStyle(fontSize: 16),
            ),
            accountEmail: Text(model!.email),
            currentAccountPicture: ClipOval(
              child:Image.network(
                model!.profileImage==''?'https://www.iconfinder.com/icons/1120619/businessman_client_man_manager_person_icon'
                :model!.profileImage,
                fit: BoxFit.cover,
              ),
            ),
          ),  ListTile(
            leading:const Icon(Icons.home,size:35,color:Color(0xffFFB900),),
            title:const Text('Home',style:TextStyle(fontSize:18,color:Color(0xffFFB900),),),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
            },
    ),
            ListTile(
            leading:const Icon(Icons.add_task,size:35,color:Color(0xffFFB900),),
            title:const Text('Add Task',style:TextStyle(fontSize:18,color:Color(0xffFFB900),),),
            onTap:(){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddTask()));},
          ),
           ListTile(
            leading:const Icon(Icons.person_pin,size:35,color:Color(0xffFFB900),),
            title:const Text('Profile',style:TextStyle(fontSize:18,color:Color(0xffFFB900),),),
             onTap:(){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen()));},
          ),
          const ListTile(
            leading:Icon(Icons.edit,size:35,color:Color(0xffFFB900),),
            title:Text('Edit',style:TextStyle(fontSize:18,color:Color(0xffFFB900),),),
          ),
          const ListTile(
            leading:Icon(Icons.settings,size:35,color:Color(0xffFFB900),),
            title:Text('Settings',style:TextStyle(fontSize:18,color:Color(0xffFFB900),),),
          ),

          const ListTile(
            leading:Icon(Icons.logout,size:35,color:Color(0xffFFB900),),
            title:Text('Logout',style:TextStyle(fontSize:18,color:Color(0xffFFB900),),),
          ),
          const Divider(
            color:Color(0xffFFB900),
            thickness:1,
          ),
            const ListTile(
            leading:Text('Rate App',style:TextStyle(fontSize:18,color:Color(0xffFFB900),),),
            title:Row(children: [
              Icon(Icons.star,),
              SizedBox(width:5,),
              Icon(Icons.star,),
              SizedBox(width:5,),
              Icon(Icons.star,),
              SizedBox(width:5,),
              Icon(Icons.star,),
              SizedBox(width:5,),
              Icon(Icons.star,)

            ],)
          ),
        ],
      ),
    );
  }
}
