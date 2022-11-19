import 'package:isar/isar.dart';

part 'todo.g.dart';

@collection
class TODO {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  late String title;
  late String description;
  late bool done;
  late DateTime createdAt;
}
