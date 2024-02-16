import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:week6_firebase/screens/login_screen.dart';
import 'package:week6_firebase/utility/utility.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentSnapshot? userSnapshot;
  
  File? chosenImage;
  bool showLocalImage = false;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {

    });
    //print(userSnapshot! as Map<String, dynamic>);
  }

  pickImageFrom( ImageSource imageSource) async{
    
    XFile? xFile = await ImagePicker().pickImage(source: imageSource);
  
    if( xFile == null ) return;
    
    chosenImage = File(xFile.path);
    setState(() {
      showLocalImage = true;
    });


    // upload image to storage
    FirebaseStorage storage = FirebaseStorage.instance;

    var fileName = userSnapshot!['email'] + '.png';

    UploadTask uploadTask = storage
        .ref()
        //.child('profile_images')
        .child(fileName)
        .putFile(chosenImage!, SettableMetadata(contentType: 'image/png'));

    TaskSnapshot snapshot = await uploadTask;

    String profileImageUrl = await snapshot.ref.getDownloadURL();
    print(profileImageUrl);


    // save its url in users collection

    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'photo': profileImageUrl});

    Fluttertoast.showToast(msg: 'Profile image uploaded');
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
                  backgroundImage: 
                  showLocalImage ? FileImage(chosenImage!) as ImageProvider:

                  userSnapshot!['photo'] == null ? null :
                  NetworkImage(userSnapshot!['photo'] as String) ,
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
                                    pickImageFrom(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text('From Gallery'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    pickImageFrom(ImageSource.gallery);

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
                Text('Member Since: ${Utility.getHumanReadableDate(userSnapshot!['createdOn'])}',
                    textAlign: TextAlign.center),
                const Gap(20),

                ElevatedButton(onPressed: () async {

                  await FirebaseAuth.instance.currentUser!.delete();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return const LoginScreen();
                  }));

                }, child: const Text('Delete Account')),
              ],
            ),
    );
  }
}
