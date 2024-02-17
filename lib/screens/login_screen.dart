import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:week6_firebase/screens/dashboard_screen.dart';
import 'package:week6_firebase/screens/email_verification_screen.dart';
import 'package:week6_firebase/screens/forgot_password_screen.dart';
import 'package:week6_firebase/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailC, passC;

  @override
  void initState() {
    emailC = TextEditingController();
    passC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {

    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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


            Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return const ForgotPasswordScreen();
                  }));
                }, child: const Text('Forgot Password?'))),
            


            ElevatedButton(onPressed: () async {

              try{
                FirebaseAuth auth = FirebaseAuth.instance;

                UserCredential userC = await auth.signInWithEmailAndPassword(email: emailC.text.trim(), password: passC.text.trim());

                if( userC.user!.emailVerified){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){

                    return const DashboardScreen();
                  }));
                }else {

                  Navigator.of(context).push(MaterialPageRoute(builder: (context){

                    return const EmailVerificationScreen();
                  }));
                }




              }
              on FirebaseAuthException catch (e ){

                // you can display custom messages
                if( e.code == 'user-not-found'){

                }

                Fluttertoast.showToast(msg: e.message!, fontSize: 30);
              }


            }, child: const Text('Login')),

            const Gap(16),
            TextButton(onPressed: (){

              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return const RegisterScreen();
              }));
            }, child: const Text('Not Register Yet? Sign UP'))
          ],
        ),
      ),
    );
  }
}
