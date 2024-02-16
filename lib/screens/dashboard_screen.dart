import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:week6_firebase/screens/add_task_screen.dart';
import 'package:week6_firebase/screens/login_screen.dart';
import 'package:week6_firebase/screens/profile_screen.dart';
import 'package:week6_firebase/screens/update_task_screen.dart';
import 'package:week6_firebase/utility/utility.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CollectionReference? tasksRef;

  @override
  void initState() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    tasksRef = FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('tasks');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const AddTaskScreen();
          }));
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ProfileScreen();
                }));
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Row(
                          children: [
                            Icon(Icons.logout),
                            Text('Are you sure to logout')
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                FirebaseAuth.instance.signOut();

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }));
                              },
                              child: const Text('Yes')),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: tasksRef!.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {



            List tasksList = snapshot.data!.docs;

            if( tasksList.isEmpty){
              return const Center(child: Text('No Tasks Saved Yet'));
            }

            // UI construct
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: tasksList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.purple,
                      child: ListTile(
                        title: Text(
                          tasksList[index]['title'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          Utility.getHumanReadableDate(tasksList[index]['createdOn']),
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Confirmation'),
                                            content: const Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                Gap(16),
                                                Text('Are you sure to delete?')
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('No')),
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();

                                                    // Delete logic here

                                                    await tasksRef!.doc(tasksList[index]['taskId']).delete();

                                                    Fluttertoast.showToast(msg: 'Deleted');
                                                    },
                                                  child: const Text('Yes')),
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 40,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () {

                                    Navigator.of(context).push(MaterialPageRoute(builder: (context){

                                      return UpdateTaskScreen(taskSnapshot: tasksList[index]);
                                    }));

                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 40,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else {
            return const Center(child: SpinKitDualRing(color: Colors.purple));
          }
        },
      ),
    );
  }
}
