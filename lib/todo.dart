import 'package:isar/isar.dart';

part 'todo.g.dart';

@collection
class TODO {
  TODO({
    required this.title,
    required this.description,
    required this.done,
    required this.createdAt,
  });

  Id id = Isar.autoIncrement; // you can also use id = null to auto increment
  final String title;
  final String description;
  final bool done;
  final DateTime createdAt;
}
