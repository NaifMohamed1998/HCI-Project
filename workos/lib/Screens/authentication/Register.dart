import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workos/services/global_methods.dart';
import 'login.dart';
import 'package:workos/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _fullNametextTextController =
      TextEditingController(text: '');
  late TextEditingController _emailtextTextController =
      TextEditingController(text: '');
  late TextEditingController _passtextTextController =
      TextEditingController(text: '');
  late TextEditingController _positiontextTextController =
      TextEditingController(text: '');
  late TextEditingController __phoneNumberTextController =
      TextEditingController(text: '');
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _positionFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  final _loginFormkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _emailtextTextController.dispose();
    _passtextTextController.dispose();
    _fullNametextTextController.dispose();
    _positiontextTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _positionFocusNode.dispose();
    __phoneNumberTextController.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void _submitFormLogin() async {
    final isValid = _loginFormkey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
            error: 'Please pick an image', ctx: context);
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
        try {
          await _auth.createUserWithEmailAndPassword(
              email: _emailtextTextController.text.trim().toLowerCase(),
              password: _passtextTextController.text.trim());
          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          final ref = FirebaseStorage.instance
              .ref()
              .child('userImages')
              .child(_uid + '.jpg');
          await ref.putFile(imageFile!);
          imageUrl = await ref.getDownloadURL();
          FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullNametextTextController.text,
            'email': _emailtextTextController.text,
            'userImage': imageUrl,
            'phoneNumber': __phoneNumberTextController.text,
            'positionInCompany': _positiontextTextController.text,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        } catch (errorrr) {
          setState(() {
            _isLoading = false;
          });
          GlobalMethod.showErrorDialog(error: errorrr.toString(), ctx: context);
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "https://i.im.ge/2022/12/20/qT5Lb4.BG2.jpg",
//                'https://i.im.ge/2022/09/15/1lWDgp.window-office-at-night-1508827.jpg',
            placeholder: (context, url) => Image.asset(
              'assets/images/pexels-josh-hild-3573433.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  'Signup',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-1.5, -1.5),
                            color: Colors.black),
                        Shadow(
                            // bottomRight
                            offset: Offset(1.5, -1.5),
                            color: Colors.black),
                        Shadow(
                            // topRight
                            offset: Offset(1.5, 1.5),
                            color: Colors.black),
                        Shadow(
                            // topLeft
                            offset: Offset(-1.5, 1.5),
                            color: Colors.black),
                      ]),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: " Already have an account?",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(-1.5, -1.5),
                                color: Colors.black),
                            Shadow(
                                // bottomRight
                                offset: Offset(1.5, -1.5),
                                color: Colors.black),
                            Shadow(
                                // topRight
                                offset: Offset(1.5, 1.5),
                                color: Colors.black),
                            Shadow(
                                // topLeft
                                offset: Offset(-1.5, 1.5),
                                color: Colors.black),
                          ])),
                  TextSpan(text: "   "),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login())),
                      text: "Login",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Constants.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                                // bottomLeft
                                offset: Offset(-1.5, -1.5),
                                color: Colors.black),
                            Shadow(
                                // bottomRight
                                offset: Offset(1.5, -1.5),
                                color: Colors.black),
                            Shadow(
                                // topRight
                                offset: Offset(1.5, 1.5),
                                color: Colors.black),
                            Shadow(
                                // topLeft
                                offset: Offset(-1.5, 1.5),
                                color: Colors.black),
                          ]))
                ])),
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _loginFormkey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),
                              keyboardType: TextInputType.emailAddress,
                              controller: _fullNametextTextController,
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return "This field cannot be empty";
                                } else {
                                  return null;
                                }
                              }),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  hintStyle: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white70)),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromRGBO(192, 192, 192, 1)),
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width * 0.24,
                                  height: size.width * 0.24,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFile == null
                                        ? Image.network(
                                            'https://i.im.ge/2022/12/20/qTwbn6.istockphoto-1337144146-170667a.jpg',
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
                                            imageFile!,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    _showImageDialog();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constants.darkBlue,
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      imageFile == null
                                          ? Icons.add_a_photo
                                          : Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_passwordFocusNode),
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailtextTextController,
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please enter a valid Email addres";
                          } else {
                            return null;
                          }
                        }),
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(192, 192, 192, 1)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_positionFocusNode),
                        focusNode: _passwordFocusNode,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passtextTextController,
                        validator: ((value) {
                          if (value!.isEmpty || value.length < 8) {
                            return "Please enter a valid password";
                          } else {
                            return null;
                          }
                        }),
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (() {
                                _obscureText = !_obscureText;
                              }),
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black54,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(192, 192, 192, 1)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: (() {
                          _showJobs(size);
                        }),
                        child: TextFormField(
                          enabled: false,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionFocusNode),
                          focusNode: _positionFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          controller: _positiontextTextController,
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return "This field cannot be empty";
                            } else {
                              return null;
                            }
                          }),
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              hintText: 'Company Position',
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white70)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white70)),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(192, 192, 192, 1)),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        focusNode: _phoneNumberFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => _submitFormLogin(),
                        keyboardType: TextInputType.phone,
                        controller: __phoneNumberTextController,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "This field cannot be empty";
                          } else {
                            return null;
                          }
                        }),
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(192, 192, 192, 1)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                _isLoading
                    ? Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : MaterialButton(
                        onPressed: _submitFormLogin,
                        color: Constants.darkBlue,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Signup",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Icon(
                                Icons.person_add,
                                color: Colors.white70,
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showJobs(Size size) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Choose Your Job',
              style: TextStyle(fontSize: 20, color: Constants.darkBlue),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.jobList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _positiontextTextController.text =
                              Constants.jobList[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.lightBlue,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.jobList[index],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.lightBlue),
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

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    _cropImage(pickedFile!.path);

    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper.platform.cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        File imgTemp = File(croppedImage.path);
        imageFile = imgTemp;
      });
    }
  }
}
