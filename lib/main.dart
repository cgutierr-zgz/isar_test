import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:isar_test/cubit/todos_cubit.dart';
import 'package:isar_test/todo.dart';

void main() async {
  final isar = await Isar.open([
    TODOSchema,
  ]);
/*
  runApp(
    fb.RepositoryProvider<Isar>(
      create: (_) => isar,
      child: const MyApp(),
    ),
  );*/

  runApp(
    BlocProvider(
      create: (context) => TodosCubit(isar),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocBuilder<TodosCubit, List<TODO>>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.isNotEmpty)
                      TextButton(
                        child: const Text('deelete all'),
                        onPressed: () => context.read<TodosCubit>().deleteAll(),
                      ),
                    ...List.generate(state.length, (index) {
                      final item = state[index];

                      return Row(
                        children: [
                          Text('${item.title}\n${item.id}'),
                          IconButton(
                            onPressed: () => context.read<TodosCubit>().deleteTodo(item.id),
                            icon: const Icon(Icons.delete),
                          )
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Text('add'),
          onPressed: () => context.read<TodosCubit>().addTodo(),
        ),
      ),
    );
  }
}









/*
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //final repo = RepositoryProvider.of<Isar>(context);
    final isar = context.watch<Isar>();

    final userChanged = isar.tODOs.where().findAll().asStream();

    return MaterialApp(
      title: 'TODO App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: StreamBuilder(
            stream: userChanged,
            //FutureBuilder(
            // future: isar.tODOs.where().findAll(),
            builder: (context, AsyncSnapshot<List<TODO>> users) {
              if (users.hasData) {
                return ListView.builder(
                  itemCount: users.requireData.length,
                  itemBuilder: (context, index) {
                    final user = users.requireData[index];
                    return ListTile(
                      title: Text(user.createdAt.toString()),
                      subtitle: Text(user.description.toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await isar.writeTxn(
                            () async => isar.tODOs.delete(user.id),
                          );
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newTodo = TODO()
              ..title = 'New TODO'
              ..description = 'New TODO Description'
              ..done = false
              ..createdAt = DateTime.now();

            await isar.writeTxn(() async {
              await isar.tODOs.put(newTodo); // insert & update
            });

            //final existingUser = await isar.users.get(newUser.id); // get

            //await isar.writeTxn(() async {
            //  await isar.users.delete(existingUser!.id); // delete
            //});
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
*/