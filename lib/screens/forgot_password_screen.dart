import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailC;

  @override
  void initState() {
    emailC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Please provide your email\nWe will send password reset instructions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            const Gap(16),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            ElevatedButton(onPressed: () async{

              String email = emailC.text.trim();

              if( email.isNotEmpty){


                try{
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

                  Fluttertoast.showToast(msg: 'Email Sent', fontSize: 30);
                }on FirebaseAuthException catch (e){
                    Fluttertoast.showToast(msg: e.message!, fontSize: 30);
                }
              }else{
                Fluttertoast.showToast(msg: "please provide email");
              }

            }, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
