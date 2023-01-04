import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/widgets/AllWorkersWidget.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/task_widget.dart';
import 'package:workos/constants/constant.dart';

class AllWorkers extends StatefulWidget {
  @override
  State<AllWorkers> createState() => _AllWorkerState();
}

class _AllWorkerState extends State<AllWorkers> {
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
          title:
              Text("All Workers", style: TextStyle(color: Constants.darkBlue)),
        ),
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
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AllWorkersWidget(
                            userID: snapshot.data!.docs[index]['id'],
                            userName: snapshot.data!.docs[index]['name'],
                            userEmail: snapshot.data!.docs[index]['email'],
                            phoneNumber: snapshot.data!.docs[index]
                                ['phoneNumber'],
                            positionInCompany: snapshot.data!.docs[index]
                                ['positionInCompany'],
                            userImageUrl: snapshot.data!.docs[index]
                                ['userImage'],
                          );
                        });
                  } else {
                    return Center(
                      child: Text('There is no users'),
                    );
                  }
                }
                return Center(
                    child: Text(
                  'Something went wrong',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ));
              },
            ),
          ],
        ));
  }
}
