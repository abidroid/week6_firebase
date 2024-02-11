import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:week6_firebase/screens/dashboard_screen.dart';
import 'package:week6_firebase/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyACxlGlrwqzI1pOsFgWBknIIlfkjlZSOaI',
    appId: '1:130494177003:android:9bf0f90d0bb13f83dae8ae',
    messagingSenderId: '130494177003',
    projectId: 'decode-6d85c',
    storageBucket: 'decode-6d85c.appspot.com',
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        )
      ),

      home:
      (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified)

          ? const DashboardScreen()

        : const LoginScreen(),
    );
  }
}
