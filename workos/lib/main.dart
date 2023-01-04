import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workos/Screens/authentication/login.dart';
import 'package:workos/Screens/taskScreen.dart';
import 'package:workos/inner_screens/OthersProfile.dart';
import 'package:workos/user_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('App is being initialized'),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('An error has been occured'),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter workos',
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xFFEDE7DC),
            primarySwatch: Colors.blue,
          ),
          
          home: UserState(),
        );
      },
    );
  }
}

