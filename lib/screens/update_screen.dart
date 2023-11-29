import 'package:fb_login/models/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateScreen extends StatefulWidget {

  final TaskModel taskModel;
  const UpdateScreen({Key? key,required this.taskModel}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
    var taskNameController=TextEditingController();

    @override
  void initState() {
    // TODO: implement initState
      taskNameController.text=widget.taskModel.taskName;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('Update Task'),
        backgroundColor:const Color(0xffFFB900),
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                  prefixIcon:const Icon(Icons.update,color:Colors.grey,),
                  labelText: 'Enter Task Name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                    const BorderSide(width: 2, color: Color(0xffFFB900)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          width: 2, color: Color(0xffFFB900)))),
            ),
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: const Color(0xffFFB900),
                ),
                onPressed: () async {
                  var taskName=taskNameController.text;
                   if(taskName.isEmpty)
                     {
                       Fluttertoast.showToast(msg: 'Please Enter Task Name');
                       return;
                     }
                   User? user=FirebaseAuth.instance.currentUser;
                   if(user !=null){
                      var taskRef=FirebaseDatabase.instance.reference().child('tasks').child(user.uid);

                      await taskRef.child(widget.taskModel.nodeId).update({ 'taskName': taskName});
                      Navigator.of(context).pop();
                   }
    },
                child: const Text(
                  'Update Task',
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
    );
  }
}
