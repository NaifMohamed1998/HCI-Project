import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/inner_screens/OthersProfile.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userID;
  final String userName;
  final String userEmail;
  final String positionInCompany;
  final String phoneNumber;
  final String userImageUrl;

  const AllWorkersWidget(
      {required this.userID,
      required this.userName,
      required this.userEmail,
      required this.positionInCompany,
      required this.phoneNumber,
      required this.userImageUrl});
  @override
  _AllWorkersWidgetState createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color.fromRGBO(255, 255, 255, 0.75),
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: ListTile(
          onTap: (() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OthersProfile(
                    userID: widget.userID,
                  ),
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
              child: Image.network(widget.userImageUrl == null
                  ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                  : widget.userImageUrl),
            ),
          ),
          title: Text(
            widget.userName,
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
                  '${widget.positionInCompany}/${widget.phoneNumber}',
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
            onPressed: _mailTo,
          ),
        ));
  }

  void _mailTo() async {
    var mailUrl = 'mailto:${widget.userEmail}';
    // print('widget.userEmail ${widget.userEmail}');
    await launchUrlString(mailUrl);
    // if (await canLaunchUrlString(mailUrl)) {
    //   await launchUrlString(mailUrl);
    // } else {
    //   print('Erorr');
    //   throw 'Error occured';
    // }
  }
}
