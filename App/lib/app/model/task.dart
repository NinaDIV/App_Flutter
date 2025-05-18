import 'package:hive/hive.dart';

part 'task.g.dart'; // <- este archivo se genera automáticamente

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  Task({required this.title, this.isDone = false});
}
