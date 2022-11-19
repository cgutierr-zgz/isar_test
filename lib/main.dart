import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_test/file.dart';

void main() async {
  final isar = await Isar.open(
    [
      UserSchema,
    ],
    inspector: true,
  );

  final newUser = User()
    ..name = 'Jane Doe'
    ..age = 36;

  await isar.writeTxn(() async {
    await isar.users.put(newUser); // insert & update
  });

  final existingUser = await isar.users.get(newUser.id); // get

  await isar.writeTxn(() async {
    await isar.users.delete(existingUser!.id); // delete
  });

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: FutureBuilder(
              future: isar.users.where().findAll(),
              builder: (context, AsyncSnapshot<List<User>> users) {
                if (users.hasData) {
                  return ListView.builder(
                    itemCount: users.requireData.length,
                    itemBuilder: (context, index) {
                      final user = users.requireData[index];
                      return ListTile(
                        title: Text(user.name.toString()),
                        subtitle: Text(user.age.toString()),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}
