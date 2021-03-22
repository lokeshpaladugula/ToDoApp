import 'package:ToDoApp/Model/TodoModel.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'HomePage.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> scheduleNotification({TodoModel data}) async {
  print("\n\n\n inside \n\n\n");
  print(data.date);
  tz.TZDateTime time = tz.TZDateTime.parse(tz.local, data.date);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel id',
    'channel name',
    'channel description',
    icon: 'app_icon',
    playSound: true,
    enableVibration: true,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin
      .zonedSchedule(
        data.id,
        Strings.appName,
        data.description,
        time,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        payload: data.id.toString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      )
      .then((value) => print('done'));
}

Future<void> onSelectNotification(String payload) async {
  print("\n\nonSelect\n\n");
  // print(payload);
  print('done');
}

Future<Null> cancleRemainder({int index}) async {
  await flutterLocalNotificationsPlugin.cancel(index);
  print('cancelled $index');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOs = IOSInitializationSettings();
  var initSetttings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

  flutterLocalNotificationsPlugin.initialize(initSetttings,
      onSelectNotification: onSelectNotification);

  return runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: new MaterialApp(
          title: Strings.appName,
          theme: new ThemeData(
              primarySwatch: Colors.deepOrange, accentColor: Colors.deepOrange),
          home: new MyHomePage(title: Strings.appName),
        ));
  }
}
