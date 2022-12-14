import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:workos/constants/constant.dart';
import 'package:workos/widgets/drawer_widget.dart';

class UploadTask extends StatefulWidget {
  const UploadTask({super.key});

  @override
  State<UploadTask> createState() => _UploadTaskState();
}

class _UploadTaskState extends State<UploadTask> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _taskCategoryController =
      TextEditingController(text: "Select Category");
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _deadlineDateController =
      TextEditingController(text: "Select Deadline Date");

  DateTime? picked;

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
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Card(
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
                          _textFormFields(
                              "TaskCategory", _taskCategoryController, false,
                              () {
                            _showTaskCategories(size);
                          }, 100),
                          _textTiles("Task Title*"),
                          _textFormFields("TaskTitle", _taskTitleController,
                              true, () {}, 100),
                          _textTiles("Task Description*"),
                          _textFormFields("TaskDescription",
                              _taskDescriptionController, true, () {}, 1000),
                          _textTiles("Task Deadline Date*"),
                          _textFormFields(
                              "TaskDeadline", _deadlineDateController, false,
                              () {
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
              fillColor: Color.fromARGB(255, 122, 115, 115),
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

  void _uploadTask() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      print("it is valid");
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
      });
    }
  }
}
