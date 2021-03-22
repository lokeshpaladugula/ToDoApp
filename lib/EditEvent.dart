import 'package:flutter/material.dart';
import 'Model/TodoModel.dart';
import 'strings.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';

class EditEvent extends StatefulWidget {
  TodoModel event;
  EditEvent({Key key, this.event}) : super(key: key);

  @override
  _EditEvent createState() => _EditEvent();
}

class _EditEvent extends State<EditEvent> {
  bool isLoading = true;
  bool notifyMe = false;

  List<TodoModel> todoList = new List<TodoModel>();
  TodoModel data = new TodoModel();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TimeOfDay notifyTime = TimeOfDay.now();
  DateTime notifyDate = DateTime.now();

  void initState() {
    super.initState();
    fillData();
  }

  fillData() {
    if (widget.event != null) {
      setState(() {
        _descriptionController.text = widget.event.description;
        notifyMe = widget.event.reminder == 1 ? true : false;
        if (notifyMe && widget.event.date != null) {
          DateTime temp = DateTime.parse(widget.event.date);
          notifyDate = temp;
          notifyTime = TimeOfDay.fromDateTime(temp);
          _dateController.text = DateFormat.yMd().format(notifyDate);
          _timeController.text = formatTimeOfDay(notifyTime);
        }
        isLoading = false;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
  }

  _onShareData(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    {
      await Share.share(widget.event.description,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text('Event'),
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  _onShareData(context);
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, 'Delete');
          },
          tooltip: 'Delete',
          child: Icon(Icons.delete),
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
                        onChanged: null,
                      )
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
                              // _selectDate(context);
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
                              // _selectTime(context);
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
