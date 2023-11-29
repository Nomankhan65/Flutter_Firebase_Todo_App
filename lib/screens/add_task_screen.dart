import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var taskName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: const Color(0xffFFB900),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: TextField(
              controller: taskName,
              decoration: InputDecoration(
                prefixIcon:const Icon(Icons.add_task,color:Colors.grey,),
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
            width: 150,
            height: 40,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: const Color(0xffFFB900),
                ),
                onPressed: () async {
                  var name = taskName.text;
                  if (name.isEmpty) {
                    Fluttertoast.showToast(msg: 'Plz Enter Task Name');
                    return;
                  }
                  User? user = FirebaseAuth.instance.currentUser;
                  var databaseRef = FirebaseDatabase.instance.reference();
                  if (user == null) {
                    return;
                  }
                  var key = databaseRef.child('tasks').child(user.uid).push().key;
                  try {
                    await databaseRef
                        .child('tasks')
                        .child(user.uid)
                        .child(key!)
                        .set({
                      'nodeId': key,
                      'taskName': name,
                      'dt': DateTime.now().millisecondsSinceEpoch,
                    });
                    Fluttertoast.showToast(msg: 'Task Added');
                  } catch (e) {
                    Fluttertoast.showToast(msg: 'Something went wrong');
                  }
                },
                child: const Text(
                  'Save Task',
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
    );
  }
}
