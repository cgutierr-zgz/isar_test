import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:isar_test/cubit/todos_cubit.dart';
import 'package:isar_test/todo.dart';

void main() async {
  final isar = await Isar.open([TODOSchema]);

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
