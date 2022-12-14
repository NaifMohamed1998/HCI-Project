import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workos/constants/constant.dart';

class TaskWidget extends StatefulWidget {
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListTile(
          onTap: (() {}),
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
              child: Image.network(
                  "https://i.im.ge/2022/10/01/1gJKpX.check-mark.png"),
            ),
          ),
          title: Text(
            "Title",
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
                  "subtitle /task description subtitle /task description subtitle /task description subtitle /task description subtitle /task description",
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
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {},
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
