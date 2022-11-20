import 'package:bloc/bloc.dart';
import 'package:isar/isar.dart';
import 'package:isar_test/todo.dart';

class TodosCubit extends Cubit<List<TODO>> {
  TodosCubit(this._isar) : super([]) {
    _collection = _isar.tODOs;
    _collection.where().findAll().asStream().listen(
      (event) {
        print(event);
        emit(event);
      },
    );
  }

  final Isar _isar;
  late IsarCollection<TODO> _collection;
/*
  Future<void> loadData() async {
    final list = await _collection.where().findAll();
    emit(list);
  }*/

  Future<void> getData() async {
    final data = await _collection.where().findAll();
    emit(data);
  }

  Future<void> addTodo()async {
    await _isar.writeTxn(() {
      return _collection.put(
        TODO()
          ..createdAt = DateTime.now()
          ..title = 'titl12e'
          ..done = false
          ..description = 'Desc1',
      );
    });
    await getData();
  }

  Future<void> deleteTodo(int id) async {
    await _isar.writeTxn(() {
      return _collection.delete(id);
    });
    await getData();
  }
}
