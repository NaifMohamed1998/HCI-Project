import 'package:flutter/material.dart';
import 'package:workos/Screens/authentication/login.dart';
import 'package:workos/Screens/taskScreen.dart';
import 'package:workos/inner_screens/OthersProfile.dart';

void main() {
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
        scaffoldBackgroundColor: Color.fromARGB(255, 22, 27, 31),
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
