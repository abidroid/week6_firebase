import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController taskC;

  @override
  void initState() {
    taskC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    taskC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskC,
              decoration: const InputDecoration(
                hintText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(onPressed: () async{

              String title = taskC.text.trim();

              String uid = FirebaseAuth.instance.currentUser!.uid;
              int createdOn  = DateTime.now().millisecondsSinceEpoch;

              var taskRef = FirebaseFirestore.instance.collection('tasks').doc(uid).collection('tasks').doc();

              await taskRef.set({
                'taskId': taskRef.id,
                'title': title,
                'createdOn': createdOn,
              });

              Fluttertoast.showToast(msg: 'Saved');
              /*
              taskId:
              title:
              createdOn:

               */


            }, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
