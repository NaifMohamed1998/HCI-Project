import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workos/Screens/AllWorkers.dart';
import 'package:workos/Screens/taskScreen.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/inner_screens/OthersProfile.dart';
import 'package:workos/inner_screens/profile.dart';
import 'package:workos/inner_screens/upload_task.dart';
import 'package:workos/user_state.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
            decoration: BoxDecoration(color: Color.fromRGBO(36, 74, 140, 0.9)),
            child: Column(
              children: [
                Flexible(
                  flex: 4,
                  child: Image.network(
                      'https://i.im.ge/2022/12/20/qTvP9L.Pngtreework-from-home-with-girl-5392465.png'),
                ),
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
          _navigateToAllTasksScreen(context);
        }, Icons.task_outlined),
        _ListTiles("My Account", () {
          _navigateToProfileScreen(context);
        }, Icons.settings_outlined),
        _ListTiles("Registerd Workers", () {
          _navigateToAllWorkersScreen(context);
        }, Icons.workspaces_outline),
        _ListTiles("Add Tasks", () {
          _navigateToAddTaskScreen(context);
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
    final FirebaseAuth _auth = FirebaseAuth.instance;
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
                onPressed: () {
                  _auth.signOut();
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserState(),
                    ),
                  );
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  void _navigateToProfileScreen(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OthersProfile(
          userID: uid,
        ),
      ),
    );
  }

  void _navigateToAllWorkersScreen(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllWorkers(),
      ),
    );
  }

  void _navigateToAllTasksScreen(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TaskScreen(),
      ),
    );
  }

  void _navigateToAddTaskScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadTask(),
      ),
    );
  }
}
