import 'dart:convert';

class TodoModel {
  int id;
  String title;
  String description;
  int reminder;
  String date;

  TodoModel({this.id, this.title, this.description, this.reminder, this.date});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    description = json['Description'];
    reminder = json['Reminder'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Reminder'] = this.reminder;
    data['Date'] = this.date;
    return data;
  }

  static Map<String, dynamic> toMap(TodoModel todo) => {
        'Id': todo.id,
        'Title': todo.title,
        'Description': todo.description,
        'Reminder': todo.reminder,
        'Date': todo.date,
      };

  static String encode(List<TodoModel> todoList) => json.encode(
        todoList
            .map<Map<String, dynamic>>((todo) => TodoModel.toMap(todo))
            .toList(),
      );

  static List<TodoModel> decode(String todoList) =>
      (json.decode(todoList) as List<dynamic>)
          .map<TodoModel>((item) => TodoModel.fromJson(item))
          .toList();
}
