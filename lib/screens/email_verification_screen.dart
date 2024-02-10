import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:week6_firebase/screens/dashboard_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  bool emailVerified = false;
  Timer? timer;

  @override
  void initState() {

    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      verificationCheck();
    });

    super.initState();
  }


  verificationCheck() {

    FirebaseAuth.instance.currentUser!.reload();

    if( FirebaseAuth.instance.currentUser!.emailVerified){

      timer?.cancel();

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){

        return const DashboardScreen();
      }));
    }

  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),

      body: ListView(children: [
        const Gap(100),
        Text('Very Email\nAn email has been sent to ${FirebaseAuth.instance.currentUser!.email}'),
        Text('Please Verify It'),
        const Gap(20),
        SpinKitDualRing(color: Colors.blue),

        ElevatedButton(onPressed: (){
          FirebaseAuth.instance.currentUser!.sendEmailVerification();

        }, child: const Text('Resend Email'))
      ],),
    );
  }
}
