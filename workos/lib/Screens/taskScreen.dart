import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/task_widget.dart';
import 'package:workos/constants/constant.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
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
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return TaskWidget();
      }),
    );
  }

  void _showTaskCategories(Size size) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Task Category',
              style: TextStyle(fontSize: 20, color: Constants.darkBlue),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.taskCategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.blueAccent,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.taskCategoryList[index],
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
                onPressed: () {},
                child: Text('Cancel Filter'),
              )
            ],
          );
        });
  }
}
