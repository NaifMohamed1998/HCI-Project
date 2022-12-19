import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/widgets/AllWorkersWidget.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/task_widget.dart';
import 'package:workos/constants/constant.dart';

class AllWorkers extends StatefulWidget {
  @override
  State<AllWorkers> createState() => _AllWorkerState();
}

class _AllWorkerState extends State<AllWorkers> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      backgroundColor: Color.fromARGB(31, 52, 51, 51),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("All Workers", style: TextStyle(color: Constants.darkBlue)),
      ),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return AllWorkersWidget();
      }),
    );
  }
}
