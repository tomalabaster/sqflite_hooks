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
    var database = await openDatabase(path, version: 2,
        onCreate: (database, version) async {
      await database.execute(
          '''CREATE TABLE Users (Id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT NOT NULL UNIQUE);''');
    }, onUpgrade: (database, oldVersion, newVersion) async {
      if (oldVersion == 1) {
        if (newVersion == 2) {
          await database.execute('''DROP TABLE Users;''');
          await database.execute(
              '''CREATE TABLE Users (Id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT NOT NULL UNIQUE);''');
        }
      }
    });

    database.addHook(
        (event) =>
            event.table == 'Users' &&
            event.operation == DatabaseOperation.insert, (event) {
      print(event.values);
    }, 'NewUserHook');

    await Future.delayed(Duration(seconds: 1),
        () => database.insert('Users', {'Name': 'Mx Doe'}));

    await Future.delayed(Duration(seconds: 1), () async {
      var batch = database.batch();

      batch.insert('Users', {'Name': 'Mx Smith'});
      batch.insert('Users', {'Name': 'Mx Williams'});

      await batch.commit();
    });

    await Future.delayed(Duration(seconds: 1), () async {
      await database.transaction((transaction) async {
        await transaction.insert('Users', {'Name': 'Mx Brown'});
        await transaction.insert('Users', {'Name': 'Mx Wright'});

        var batch = transaction.batch();

        batch.insert('Users', {'Name': 'Mx Jones'});
        batch.insert('Users', {'Name': 'Mx Daniels'});

        await batch.commit();
      }, onRollBack: (events) {
        for (var event in events) {
          print(event);
        }
      });
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
