import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workos/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workos/user_state.dart';

import '../widgets/drawer_widget.dart';

class OthersProfile extends StatefulWidget {
  final String userID;

  const OthersProfile({required this.userID});

  @override
  State<OthersProfile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<OthersProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _titleTextStyle = TextStyle(
      fontSize: 22, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold);
  var _contentTextstyle = TextStyle(
      color: Constants.darkBlue,
      fontSize: 18,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool _isLoading = false;
  String phoneNumber = "";
  String email = "";
  String? name;
  String job = '';
  String imageUrl = "";
  String joinedAt = " ";
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          job = userDoc.get('positionInCompany');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    } catch (eror) {
    } finally {
      _isLoading = false;
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Constants.darkBlue)),
        iconTheme: IconThemeData(color: Constants.darkBlue),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.black26,
      drawer: DrawerWidget(),
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "https://i.im.ge/2022/12/20/qTWknq.BG3.jpg",
//                'https://i.im.ge/2022/09/15/1lWDgp.window-office-at-night-1508827.jpg',
            placeholder: (context, url) => Image.asset(
              'assets/images/pexels-josh-hild-3573433.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Stack(
                children: [
                  Card(
                    color: Color.fromRGBO(255, 255, 255, 0.75),
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
                              child: Text(name == null ? 'Name here' : name!,
                                  style: _titleTextStyle)),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '$job Since joined $joinedAt',
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
                            child: userInfo(title: 'Email:', content: email),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: userInfo(
                                title: 'Phone Number:', content: phoneNumber),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          _isSameUser
                              ? Container()
                              : Divider(
                                  thickness: 1,
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          _isSameUser
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _contactBy(
                                      color: Colors.green,
                                      fct: () {
                                        _openWhatsAppChat();
                                      },
                                      icon: Icons.whatsapp,
                                    ),
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
                            height: 25,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          !_isSameUser
                              ? Container()
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: MaterialButton(
                                      onPressed: () {
                                        _auth.signOut();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserState(),
                                          ),
                                        );
                                      },
                                      color: Constants.darkBlue,
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Logout',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
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
                              image: NetworkImage(imageUrl == null
                                  ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                  : imageUrl),
                              fit: BoxFit.fill),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
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
    var url = 'https://wa.me/$phoneNumber&text=HelloWorld';
    await launchUrlString(url);

    // if (await canLaunchUrlString(url)) {
    //   await launchUrlString(url);
    // } else {
    //   throw 'Error occured';
    // }
  }

  void _mailTo() async {
    var mailUrl = 'mailto:$email';
    await launchUrlString(mailUrl);
    // if (await canLaunchUrlString(mailUrl)) {
    //   await launchUrlString(mailUrl);
    // } else {
    //   throw 'Error occured';
    // }
  }

  void _callPhoneNumber() async {
    var url = 'tel://$phoneNumber';
    await launchUrlString(url);
    // if (await canLaunchUrlString(url)) {
    //   await launchUrlString(url);
    // } else {
    //   throw 'Error occured';
    // }
  }
}
