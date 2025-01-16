import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final TextEditingController _taskController = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin(
        
      );
      

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(String task, DateTime time) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('todo_channel', 'To-Do Notifications',
            channelDescription: 'Channel for To-Do app notifications',
            importance: Importance.high,
            priority: Priority.high);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    //     await _notificationsPlugin.zonedSchedule(
    //   0,
    //   'Reminder: ${TodoApp.title}',
    //   TodoApp.channelDescription,
    //    tzDateTime,
    //   notificationDetails,
    //    androidScheduleMode: AndroidScheduleMode.alarmClock,
    //   uiLocalNotificationDateInterpretation:
    //        UILocalNotificationDateInterpretation.absoluteTime,
    // );

    // await _notificationsPlugin.zonedSchedule(
    //   0, // Notification ID (unique for each notification)
    //   'Task Reminder',
    //   task,
    //   ,
    //   notificationDetails,
    // );
  }

  void _addTask(String task, DateTime time) {
    setState(() {
      _tasks.add({'task': task, 'time': time});
    });
    _scheduleNotification(task, time);
  }

  void _showAddTaskDialog() {
    DateTime? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(labelText: 'Task Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  selectedTime = await showDateTimePicker(context);
                },
                child: Text('Select Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty && selectedTime != null) {
                  _addTask(_taskController.text, selectedTime!);
                  _taskController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Add Task'),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 74, 155, 220) ,
      appBar: AppBar(
        title: Text('To-Do App'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task['task']),
            subtitle: Text(task['time'].toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
