import 'package:bloc/bloc.dart';
import 'package:isar/isar.dart';
import 'package:isar_test/todo.dart';

class TodosCubit extends Cubit<List<TODO>> {
  TodosCubit(this._isar) : super([]) {
    _collection = _isar.tODOs;

    _collection.watchLazy(fireImmediately: true).listen(
      (event) async {
        final data = await _collection.where().findAll();
        emit(data);
      },
    );
  }
  final Isar _isar;
  late IsarCollection<TODO> _collection;

  Future<void> addTodo() async {
    await _isar.writeTxn(() {
      return _collection.put(
        TODO(
          title: 'Title',
          description: 'Desc',
          done: false,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  Future<void> deleteAll() async {
    final items = List.generate(state.length, (index) => state[index].id);

    await _isar.writeTxn(() {
      return _collection.deleteAll(items);
    });
  }

  Future<void> deleteTodo(int id) async {
    await _isar.writeTxn(() {
      return _collection.delete(id);
    });
  }
}
