import 'package:fb_login/models/task_model.dart';
import 'package:fb_login/models/user_model.dart';
import 'package:fb_login/screens/LogIn_Screen.dart';
import 'package:fb_login/screens/profile_screen.dart';
import 'package:fb_login/screens/update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../widgets/drawer.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  UserModel? userModel;
  DatabaseReference? taskRef;

  @override
  void initState() {
    // TODO: implement initState
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      taskRef =
          FirebaseDatabase.instance.reference().child('tasks').child(user!.uid);
    }
    super.initState();
  }

  TextEditingController taskName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Task List'),
          backgroundColor: const Color(0xffFFB900),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
                },
                child: const Icon(
                  Icons.person_pin,
                  size: 35,
                )),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                await auth.signOut().then((value) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LogIn())));
              },
              icon: const Icon(
                Icons.logout,
                size: 35,
              ),
            ),
          ],
          leading: Builder(
              builder: (context) => InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(
                    Icons.menu,
                    size: 35,
                  )))),
      drawer: const NavDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: taskRef != null ? taskRef!.onValue : null,
              builder: (context, snap) {
                if (snap.hasData && !snap.hasError) {
                  DataSnapshot dataSnapshot = snap.data!.snapshot;

                  if (dataSnapshot.value == null) {
                    return const Center(
                      child: Text('No Task Yet '),
                    );
                  }

                  Map<String, dynamic> map =
                      Map<String, dynamic>.from(dataSnapshot.value! as Map);
                  var tasks = <TaskModel>[];

                  for (var taskMap in map.values) {
                    tasks.add(
                        TaskModel.fromMap(Map<String, dynamic>.from(taskMap)));
                    print(tasks);
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      TaskModel taskObject = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.4),
                              )
                            ],
                            border: const Border(
                                left: BorderSide(
                                    width: 5, color: Color(0xffFFB900))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyRow(
                                        Task: taskObject.taskName,
                                        Date: taskObject.dt)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          if (taskRef != null) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Confirmation"),
                                                    content: const Text(
                                                        'Are You Sure To Delete'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('No')),
                                                      TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              await taskRef!
                                                                  .child(
                                                                      taskObject
                                                                          .nodeId)
                                                                  .remove();
                                                            } catch (e) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Failes');
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Yes')),
                                                    ],
                                                  );
                                                });
                                          }
                                        },
                                        icon: const Icon(Icons.delete)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (ctx) {
                                            return UpdateScreen(
                                                taskModel: taskObject);
                                          }));
                                        },
                                        icon: const Icon(Icons.edit)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical:8),
            child: TextField(
              controller: taskName,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
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
                        var key = databaseRef
                            .child('tasks')
                            .child(user.uid)
                            .push()
                            .key;
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
                          taskName.text='';
                        } catch (e) {
                          Fluttertoast.showToast(msg: 'Something went wrong');
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xffFFB900),
                        size: 30,
                      )),
                  labelText: 'Enter Task',
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
        ],
      ),
    );
  }
}

String HumanReadable(int dt) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

class MyRow extends StatelessWidget {
  String Task;
  int Date;
  MyRow({Key? key, required this.Task, required this.Date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task : ' + Task,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Date : ' + HumanReadable(Date),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
