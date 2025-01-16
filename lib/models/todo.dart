import 'package:hive_flutter/hive_flutter.dart';
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final DateTime notificationTime;
  Todo ({required this.title,required this.description,required this.notificationTime});

  
}