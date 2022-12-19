import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workos/Screens/AllWorkers.dart';
import 'package:workos/Screens/taskScreen.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/inner_screens/profile.dart';
import 'package:workos/inner_screens/upload_task.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              children: [
                Flexible(
                    flex: 1,
                    child: Image.network(
                        'https://i.im.ge/2022/10/01/1gnxvp.wall-clock.png')),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                    child: Text(
                  'TASK MANAGER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            )),
        SizedBox(
          height: 30,
        ),
        _ListTiles("All Tasks", () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TaskScreen(),
              ));
        }, Icons.task_outlined),
        _ListTiles("My Account", () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ));
        }, Icons.settings_outlined),
        _ListTiles("Registerd Workers", () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AllWorkers(),
              ));
        }, Icons.workspaces_outline),
        _ListTiles("Add Tasks", () {
          _addTaskFunction(context);
        }, Icons.add_task),
        Divider(
          thickness: 1,
        ),
        _ListTiles("Logout", () {
          _logout(context);
        }, Icons.logout_outlined),
      ]),
    );
  }

  Widget _ListTiles(String label, Function fct, IconData icon) {
    return ListTile(
      onTap: () {
        fct();
      },
      leading: Icon(
        icon,
        color: Constants.darkBlue,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Constants.darkBlue,
          fontSize: 20,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  void _logout(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Constants.darkBlue,
                    size: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Signout',
                  ),
                )
              ],
            ),
            content: Text(
              'Do you want to Sign Out?',
              style: TextStyle(
                  color: Constants.darkBlue,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  void _addTaskFunction(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UploadTask()));
  }
}
