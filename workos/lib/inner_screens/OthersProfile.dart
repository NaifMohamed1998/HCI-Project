import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workos/constants/constant.dart';

import '../widgets/drawer_widget.dart';

class OthersProfile extends StatefulWidget {
  const OthersProfile({super.key});

  @override
  State<OthersProfile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OthersProfile> {
  var _titleTextStyle = TextStyle(
      fontSize: 22, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
  var _contentTextstyle = TextStyle(
      color: Constants.darkBlue,
      fontSize: 18,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.darkBlue),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Stack(
            children: [
              Card(
                margin: EdgeInsets.all(30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Name',
                            style: _titleTextStyle,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'job since joined date 2022-02-22',
                            style: TextStyle(
                                color: Constants.darkBlue,
                                fontSize: 18,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Contact Info',
                          style: _titleTextStyle,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: userInfo(
                              title: 'Email:', content: 'email@gmail.com'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: userInfo(
                              title: 'Phone Number:', content: '+94771234567'),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _contactBy(
                                color: Colors.green,
                                fct: () {
                                  _openWhatsAppChat();
                                },
                                icon: Icons.whatsapp),
                            _contactBy(
                                color: Colors.red,
                                fct: () {
                                  _mailTo();
                                },
                                icon: Icons.mail_outline),
                            _contactBy(
                                color: Colors.purple,
                                fct: () {
                                  _callPhoneNumber();
                                },
                                icon: Icons.call_outlined),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.26,
                    height: size.width * 0.26,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 8,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://i.im.ge/2022/09/15/1lWDgp.window-office-at-night-1508827.jpg'),
                          fit: BoxFit.fill),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfo({required String title, required String content}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: _titleTextStyle,
          ),
        ),
        Text(
          content,
          style: _contentTextstyle,
        ),
      ],
    );
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
          onPressed: () {
            fct();
          },
          icon: Icon(
            icon,
            color: color,
          ),
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/+94776671820?text=HelloWorld';
    await launchUrlString(url);
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   print('Erorr');
    //   throw 'Error occured';
    // }
  }

  void _mailTo() async {
    var mailUrl = 'mailto:naif07121998@gmail.com';
    await launch(mailUrl);
    // if (await canLaunch(mailUrl)) {
    //   await launch(mailUrl);
    // } else {
    //   print('Erorr');
    //   throw 'Error occured';
    // }
  }

  void _callPhoneNumber() async {
    var url = 'tel://+94776671820';
    await launchUrlString(url);
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Error occured';
    // }
  }
}
