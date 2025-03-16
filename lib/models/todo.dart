// Thêm các import cần thiết
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz; // Thêm package timezone
import 'package:timezone/data/latest.dart' as tz; // Thêm cho khởi tạo timezone

class Todo {
  String task;
  DateTime date;

  Todo({required this.task, required this.date});
}

class TodoState extends ChangeNotifier {
  List<Todo> todos;
  final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin; // Thêm plugin

  TodoState()
    : todos = [],
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin() {
    _initNotifications(); // Khởi tạo notifications
  }

  Future<void> _initNotifications() async {
    // Khởi tạo timezone
    tz.initializeTimeZones();

    // Cấu hình Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void add(String task, DateTime date) {
    todos.add(Todo(task: task, date: date));
    notifyListeners();

    _scheduleNotification(
      id: todos.length,
      title: 'Sắp đến hạn!',
      body: 'Công việc: $task',
      scheduledDate: date.subtract(const Duration(minutes: 10)),
    );
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'deadline_channel',
          'Deadline Notifications',
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void remove(int index) {
    todos.removeAt(index);
    notifyListeners();
  }
}
