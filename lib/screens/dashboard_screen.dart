import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:week6_firebase/screens/login_screen.dart';
import 'package:week6_firebase/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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

                Navigator.of(context).push(MaterialPageRoute(builder: (context){
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
                    context: context, builder: (context){

                  return AlertDialog(

                    title: const Text('Confirmation'),
                    content: const Row(children: [
                      Icon(Icons.logout),
                      Text('Are you sure to logout')
                    ],),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text('No')),
                      TextButton(onPressed: (){
                        Navigator.pop(context);

                        FirebaseAuth.instance.signOut();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return const LoginScreen();
                        }));


                      }, child: const Text('Yes')),

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
    );
  }
}
