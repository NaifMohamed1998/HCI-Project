import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/task_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? taskCategoryFilter;
  String? sortId;
  bool? isManaging;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage("https://i.im.ge/2022/12/20/qTWknq.BG3.jpg"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
          drawer: DrawerWidget(),
          backgroundColor: Color.fromARGB(31, 52, 51, 51),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),

            // leading: Builder(
            //   builder: (ctx) {
            //     return IconButton(
            //         onPressed: () {
            //           Scaffold.of(ctx).openDrawer();
            //         },
            //         icon: Icon(
            //           Icons.menu,
            //           color: Colors.black,
            //         ));
            //   },
            // ),
            title: Text("Tasks", style: TextStyle(color: Constants.darkBlue)),
            actions: [
              IconButton(
                  onPressed: () {
                    _showTaskCategories(size);
                  },
                  icon: Icon(
                    Icons.filter_list_outlined,
                    color: Colors.black,
                  ))
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            //there was a null error just add those lines
            stream: taskCategoryFilter == null
                ? FirebaseFirestore.instance
                    .collection('tasks')
                    .orderBy('createdAt', descending: true)
                    .snapshots()
                : isManaging == true
                    ? FirebaseFirestore.instance
                        .collection('tasks')
                        .where('uploadedBy', isEqualTo: _auth.currentUser!.uid)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('tasks')
                        .where('assignTo', isEqualTo: _auth.currentUser!.uid)
                        .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskWidget(
                          taskTitle: snapshot.data!.docs[index]['taskTitle'],
                          taskDescription: snapshot.data!.docs[index]
                              ['taskDescription'],
                          taskId: snapshot.data!.docs[index]['taskId'],
                          uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                          isDone: snapshot.data!.docs[index]['isDone'],
                          assignedId: snapshot.data!.docs[index]['assignTo'],
                        );
                      });
                } else {
                  return Center(
                    child: Text(
                      'There is no tasks',
                      style: TextStyle(
                        fontSize: 40,
                        color: Constants.darkBlue,
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              }
              return Center(
                  child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ));
            },
          )),
    );
  }

  void _showTaskCategories(Size size) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.7),
            title: Text(
              'Filter By',
              style: TextStyle(fontSize: 20, color: Constants.darkBlue),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.filterList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          taskCategoryFilter = Constants.filterList[index];
                          if (taskCategoryFilter == 'Managing Tasks') {
                            isManaging = true;
                          } else {
                            isManaging = false;
                          }
                        });
                        Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                        print(
                            'filterList[index], ${Constants.filterList[index]}');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.blueAccent,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.filterList[index],
                              style: TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    taskCategoryFilter = null;
                  });
                  Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                },
                child: Text('Cancel Filter'),
              )
            ],
          );
        });
  }
}
