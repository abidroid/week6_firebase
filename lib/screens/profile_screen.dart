import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentSnapshot? userSnapshot;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    print(userSnapshot! as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: userSnapshot == null
          ? const Center(
              child: SpinKitDualRing(color: Colors.purple),
            )
          : ListView(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: userSnapshot!['photo'],
                  backgroundColor: Colors.purple.withOpacity(0.2),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('From Camera'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text('From Gallery'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                ),
                const Gap(20),
                Text('Name: ${userSnapshot!['name']}',
                    textAlign: TextAlign.center),
                const Gap(20),
                Text('Email: ${userSnapshot!['email']}',
                    textAlign: TextAlign.center),
                const Gap(20),
                Text('Mobile: ${userSnapshot!['mobile']}',
                    textAlign: TextAlign.center),
                const Gap(20),
                Text('Member Since: ${userSnapshot!['createdOn']}',
                    textAlign: TextAlign.center),
              ],
            ),
    );
  }
}
