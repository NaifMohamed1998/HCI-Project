import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/inner_screens/TaskDetails.dart';
import 'package:workos/services/global_methods.dart';

class TaskWidget extends StatefulWidget {
  final String taskTitle;
  final String taskDescription;
  final String taskId;
  final String uploadedBy;
  final bool isDone;
  final String assignedId;

  const TaskWidget(
      {required this.taskTitle,
      required this.taskDescription,
      required this.taskId,
      required this.uploadedBy,
      required this.isDone,
      required this.assignedId});
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        color: Color.fromRGBO(255, 255, 255, 0.7),
        child: ListTile(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(
                    taskID: widget.taskId,
                    uploadedBy: widget.uploadedBy,
                    assignedID: widget.assignedId,
                  ),
                ));
          }),
          onLongPress: _deleteFunction,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(width: 1)),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20, //https://i.im.ge/2022/10/01/1gnxvp.wall-clock.png
              child: Image.network(widget.isDone
                  ? 'https://i.im.ge/2022/10/01/1gJKpX.check-mark.png'
                  : 'https://i.im.ge/2022/10/01/1gnxvp.wall-clock.png'),
            ),
          ),
          title: Text(
            widget.taskTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Constants.darkBlue,
            ),
          ),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.linear_scale_outlined,
                  color: Constants.darkBlue,
                ),
                Text(
                  widget.taskDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ]),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Constants.darkBlue,
          ),
        ));
  }

  void _deleteFunction() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      if (widget.uploadedBy == _uid) {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.taskId)
                            .delete();
                        await Fluttertoast.showToast(
                            msg: "Task has been deleted",
                            toastLength: Toast.LENGTH_LONG,
                            // gravity: ToastGravity.,
                            backgroundColor: Colors.grey,
                            fontSize: 18.0);
                        Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                      } else {
                        GlobalMethod.showErrorDialog(
                            error: 'You cannot perfom this action', ctx: ctx);
                      }
                    } catch (error) {
                      GlobalMethod.showErrorDialog(
                          error: 'this task can\'t be deleted', ctx: context);
                    } finally {}
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ))
            ],
          );
        });
  }
}
