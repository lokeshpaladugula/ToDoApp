import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditEvent.dart';
import 'Model/TodoModel.dart';
import 'AddEvent.dart';
import 'dart:convert';

import 'main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  List<TodoModel> todoList = new List<TodoModel>();
  bool fromNotification = false;
  int navigateToId;

  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = prefs.getString('EncodedData') ?? null;
    print(encodedData);
    setState(() {
      if (encodedData != null) {
        todoList = TodoModel.decode(encodedData);
      }
      isLoading = false;
    });
  }

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = TodoModel.encode(todoList);
    prefs.setString('EncodedData', encodedData);
    print('saved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEvent(
                          index: todoList.length,
                        ))).then((value) => value != null
                ? {
                    setState(() {
                      print(value.id);
                      if (value.reminder == 1) {
                        scheduleNotification(data: value);
                      }
                      todoList.add(value);
                      saveData();
                    })
                  }
                : null);
          },
          tooltip: 'Add Note',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : todoListVIew());
  }

  Widget todoListVIew() {
    return Container(
      child: todoList.length == 0
          ? Center(
              child: Text(
                'Add an Event',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Container(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditEvent(
                                    event: todoList[index],
                                  ))).then((value) => value != null
                          ? {
                              if (value == "Delete")
                                {
                                  setState(() {
                                    if (todoList[index].reminder == 1) {
                                      cancleRemainder(
                                          index: todoList[index].id);
                                    }
                                    todoList.removeAt(index);
                                    saveData();
                                  })
                                }
                            }
                          : null);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          todoList[index].description,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
