import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Model/TodoModel.dart';
import 'strings.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  int index;
  AddEvent({Key key, this.index}) : super(key: key);
  @override
  _AddEvent createState() => _AddEvent();
}

class _AddEvent extends State<AddEvent> {
  bool isLoading = false;
  bool notifyMe = false;

  List<TodoModel> todoList = new List<TodoModel>();
  TodoModel data = new TodoModel();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TimeOfDay notifyTime = TimeOfDay.now();
  DateTime notifyDate = DateTime.now();
  final formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    print(widget.index);
  }

  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: notifyTime,
    );
    if (picked != null)
      setState(() {
        notifyTime = picked;
        _timeController.text = picked.format(context).toString();
      });
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: notifyDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        notifyDate = picked;
        _dateController.text = DateFormat.yMd().format(notifyDate);
      });
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text('Add Event'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (validateAndSave()) {
              if (notifyMe) {
                notifyDate = DateTime(notifyDate.year, notifyDate.month,
                    notifyDate.day, notifyTime.hour, notifyTime.minute);
                if (notifyDate.isBefore(DateTime.now())) {
                  Fluttertoast.showToast(
                      msg: "Invalid Date and Time",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1);
                  print("invalid");
                } else {
                  data.reminder = 1;
                  data.date = notifyDate.toString();
                  data.id = widget.index;
                  data.description = _descriptionController.text;
                  Navigator.pop(context, data);
                }
              } else {
                data.reminder = 0;
                data.id = widget.index;
                data.description = _descriptionController.text;
                Navigator.pop(context, data);
              }
            }
          },
          tooltip: 'Save',
          child: Icon(Icons.done),
        ),
        body:
            isLoading ? Center(child: CircularProgressIndicator()) : inputs());
  }

  Widget inputs() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(fontSize: 15),
                    enabled: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 3,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide notes';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Notes',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reminder',
                        style: new TextStyle(fontSize: 15.0),
                      ),
                      Switch(
                          value: notifyMe,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              notifyMe = value;
                              if (notifyMe == true) {
                                _dateController.text =
                                    DateFormat.yMd().format(notifyDate);
                                _timeController.text =
                                    notifyTime.format(context).toString();
                              }
                            });
                          }),
                    ],
                  ),
                  Visibility(
                      visible: notifyMe,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date',
                            style: new TextStyle(fontSize: 15.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: 150,
                              alignment: Alignment.center,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.end,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _dateController,
                                decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.all(5)),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Visibility(
                      visible: notifyMe,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time',
                            style: new TextStyle(fontSize: 15.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              _selectTime(context);
                            },
                            child: Container(
                              width: 150,
                              alignment: Alignment.center,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.end,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _timeController,
                                decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.all(5)),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              )),
        ));
  }
}
