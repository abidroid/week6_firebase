import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameC, mobileC, emailC, passC;
  String? selectedGender;

  @override
  void initState() {
    nameC = TextEditingController();
    mobileC = TextEditingController();
    emailC = TextEditingController();
    passC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameC.dispose();
    mobileC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(
                  hintText: 'Name', border: OutlineInputBorder()),
            ),
            const Gap(16),
            TextField(
              keyboardType: TextInputType.number,
              controller: mobileC,
              decoration: const InputDecoration(
                  hintText: 'Mobile', border: OutlineInputBorder()),
            ),
            const Gap(16),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                  hintText: 'Email', border: OutlineInputBorder()),
            ),
            const Gap(16),
            TextField(
              controller: passC,
              decoration: const InputDecoration(
                  hintText: 'Password', border: OutlineInputBorder()),
            ),
            const Gap(16),
            CupertinoSegmentedControl<String>(
                groupValue: selectedGender,
                children: const {
                  'Male': Text('Male'),
                  'Female': Text('Female'),
                },
                onValueChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                }),
            const Gap(16),
            ElevatedButton(
                onPressed: () async {
                  // please apply validations

                  try {
                    FirebaseAuth auth = FirebaseAuth.instance;

                    UserCredential? userCredentials =
                        await auth.createUserWithEmailAndPassword(
                      email: emailC.text.trim(),
                      password: passC.text.trim(),
                    );

                    if (userCredentials.user != null) {
                      // save other info in firestore

                      FirebaseFirestore firebaseFirestore =
                          FirebaseFirestore.instance;

                      await firebaseFirestore
                          .collection('users')
                          .doc(userCredentials.user!.uid)
                          .set({
                        'name': nameC.text.trim(),
                        'mobile': mobileC.text.trim(),
                        'gender': selectedGender,
                        'email': emailC.text.trim(),
                        'uid': userCredentials.user!.uid,
                        'createdOn': DateTime.now().millisecondsSinceEpoch,
                        'photo': null,
                      });
                    }

                    Fluttertoast.showToast(msg: 'Success', fontSize: 30);
                  } on FirebaseAuthException catch (e) {
                    print(e.code);
                    print(e.message!);

                    Fluttertoast.showToast(msg: e.message!, fontSize: 30);
                  }
                },
                child: const Text('Register')),
            const Gap(16),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Already Registered? Login'))
          ],
        ),
      ),
    );
  }
}
