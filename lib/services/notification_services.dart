import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart'as tz;
import 'package:timezone/timezone.dart'as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:to_do_app_with_changing_theme/screens/notify_page.dart';

import '../models/task.dart';
class NotifyHelper {
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  initializeNotification() async {
    _configureLocalTimeZone();
    print('initialized');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");

      const InitializationSettings initializationSettings =
      InitializationSettings(
      android:initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);

  }
  void selectNotification(NotificationResponse payload) async {
    if (payload != null) {
      print('notification payload: ${payload.toString()}');
    } else {
      print("Notification Done");
    }
    Get.to(()=> NotifyPage(label : payload));
  }
  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);//battery

    var platformChannelSpecifics =  NotificationDetails(
        android: androidPlatformChannelSpecifics,);
    await flutterLocalNotificationsPlugin.show(
      0,//id
      title,
      body,
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }

  scheduledNotification(int hour , int minutes , Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _convertTime(hour , minutes),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      payload: "${task.title!} |" "${task.note!} |"
    );

  }
  //to convert time and use it as a variable not constant values
  tz.TZDateTime _convertTime(int hour , int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, now.year,now.month,now.day,hour,minutes);
    if(scheduleDate.isBefore(now)){
      scheduleDate=scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  //to know time based on location
  Future<void> _configureLocalTimeZone()async{
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    //get and set location and time zone
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    
  }
}
