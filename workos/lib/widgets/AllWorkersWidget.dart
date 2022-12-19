import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/inner_screens/OthersProfile.dart';

class AllWorkersWidget extends StatefulWidget {
  @override
  _AllWorkersWidgetState createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListTile(
          onTap: (() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OthersProfile(),
                ));
          }),
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
            "Worker Name",
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
                  "Position /071111111",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ]),
          trailing: IconButton(
            icon: Icon(
              Icons.mail_outline,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ));
  }
}
