import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:sqflite_hooks/sqflite_hooks.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    var database = await openDatabase(path, version: 1,
        onCreate: (database, version) async {
      await database.execute(
          '''CREATE TABLE Users (Id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT NOT NULL);''');
    });

    database.addHook(
        (event) =>
            event.table == 'Users' &&
            event.operation == DatabaseOperation.insert, (event) {
      print(event.values);
    }, 'NewUserHook');

    await Future.delayed(Duration(seconds: 5),
        () => database.insert('Users', {'Name': 'Mx Doe'}));

    await Future.delayed(Duration(seconds: 5), () async {
      var batch = database.batch();

      batch.insert('Users', {'Name': 'Mx Smith'});
      batch.insert('Users', {'Name': 'Mx Williams'});

      await batch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sqflite hooks example app'),
        ),
        body: Center(
          child: const Text('Sqflite hooks example app'),
        ),
      ),
    );
  }
}
