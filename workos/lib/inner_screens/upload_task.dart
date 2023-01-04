import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/inner_screens/OthersProfile.dart';
import 'package:workos/services/global_methods.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadTask extends StatefulWidget {
  const UploadTask({super.key});

  @override
  State<UploadTask> createState() => _UploadTaskState();
}

class _UploadTaskState extends State<UploadTask> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _assignToController =
      TextEditingController(text: "Assign Worker");
  TextEditingController _taskCategoryController =
      TextEditingController(text: "Select Category");
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _deadlineDateController =
      TextEditingController(text: "Select Deadline Date");

  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isLoading = false;
  String? assignedID;

  void dispose() {
    _deadlineDateController.dispose();
    _taskCategoryController.dispose();
    _taskDescriptionController.dispose();
    _taskTitleController.dispose();
    super.dispose();
  }

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
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "All Field Are Required",
                          style: TextStyle(
                              color: Constants.darkBlue,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textTiles("Task Category*"),
                              _textFormFields("TaskCategory",
                                  _taskCategoryController, false, () {
                                _showTaskCategories(size);
                              }, 100),
                              _textTiles("Task Title*"),
                              _textFormFields("TaskTitle", _taskTitleController,
                                  true, () {}, 100),
                              _textTiles("Task Description*"),
                              _textFormFields(
                                  "TaskDescription",
                                  _taskDescriptionController,
                                  true,
                                  () {},
                                  1000),
                              _textTiles("Assign to*"),
                              _textFormFields(
                                  "Assign To", _assignToController, false, () {
                                _showMembers(size);
                              }, 100),
                              _textTiles("Task Deadline Date*"),
                              _textFormFields("TaskDeadline",
                                  _deadlineDateController, false, () {
                                _pickDateDialog();
                              }, 100),
                            ],
                          )),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: MaterialButton(
                          onPressed: _uploadTask,
                          color: Constants.darkBlue,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Upload Task",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.white70,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFormFields(
    String valueKey,
    TextEditingController controller,
    bool enabled,
    Function fct,
    int length,
  ) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: (() {
          fct();
        }),
        child: TextFormField(
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
            color: Constants.darkBlue,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "value is missing";
            }
          },
          maxLines: valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: length,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(192, 192, 192, 0.9),
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 241, 210))),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink))),
        ),
      ),
    );
  }

  Widget _textTiles(String label) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
            color: Constants.darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void _uploadTask() async {
    final isValid = _formKey.currentState!.validate();
    final taskID = Uuid().v4();
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    //final _assignUid=
    if (isValid) {
      if (_deadlineDateController.text == 'Choose task Deadline date' ||
          _taskCategoryController.text == 'Choose task category' ||
          _assignToController.text == 'Assign Worker') {
        GlobalMethod.showErrorDialog(
            error: 'Please pick everything', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('tasks').doc(taskID).set({
          'taskId': taskID,
          'uploadedBy': _uid,
          'assignTo': assignedID,
          'taskTitle': _taskTitleController.text,
          'taskDescription': _taskDescriptionController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'taskCategory': _taskCategoryController.text,
          'taskComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        await Fluttertoast.showToast(
            msg: "The task has been uploaded",
            toastLength: Toast.LENGTH_LONG,
            // gravity: ToastGravity.,
            backgroundColor: Colors.grey,
            fontSize: 18.0);
        _taskTitleController.clear();
        _taskDescriptionController.clear();
        setState(() {
          _taskCategoryController.text = 'Choose task category';
          _deadlineDateController.text = 'Choose task Deadline date';
          _assignToController.text = 'Assign Worker';
        });
      } catch (error) {
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("it is not valid");
    }
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
                      onTap: () {
                        setState(() {
                          _taskCategoryController.text =
                              Constants.taskCategoryList[index];
                        });
                        Navigator.pop(context);
                      },
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
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _deadlineDateController.text =
            "${picked!.year}-${picked!.month}-${picked!.day}";
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _showMembers(Size size) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Workers',
              style: TextStyle(fontSize: 20, color: Constants.darkBlue),
            ),
            content: Container(
              width: size.width * 0.9,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                color: Color.fromRGBO(255, 255, 255, 0.75),
                                elevation: 8,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: ListTile(
                                    onTap: (() {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OthersProfile(
                                              userID: snapshot.data!.docs[index]
                                                  ['id'],
                                            ),
                                          ));
                                    }),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    leading: Container(
                                      padding: EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        border:
                                            Border(right: BorderSide(width: 1)),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius:
                                            20, //https://i.im.ge/2022/10/01/1gnxvp.wall-clock.png
                                        child: Image.network(snapshot.data!
                                                    .docs[index]['userImage'] ==
                                                null
                                            ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                            : snapshot.data!.docs[index]
                                                ['userImage']),
                                      ),
                                    ),
                                    title: Text(
                                      snapshot.data!.docs[index]['name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Constants.darkBlue,
                                      ),
                                    ),
                                    subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.linear_scale_outlined,
                                            color: Constants.darkBlue,
                                          ),
                                          Text(
                                            '${snapshot.data!.docs[index]['positionInCompany']}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ]),
                                    trailing: TextButton(
                                      child: Text(
                                        'Assign',
                                        style: TextStyle(
                                            color: Colors.white,
                                            backgroundColor:
                                                Constants.darkBlue),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _assignToController.text = snapshot
                                              .data!.docs[index]['name'];
                                          assignedID =
                                              snapshot.data!.docs[index]['id'];
                                        });
                                        Navigator.pop(context);
                                      },
                                    )
                                    // IconButton(
                                    //   icon: Icon(
                                    //     Icons.mail_outline,
                                    //     color: Colors.red,
                                    //   ),
                                    //   onPressed: _mailTo,
                                    // ),
                                    ));
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
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }
}
