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
  HookedDatabase _database;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    this._database = await openDatabase(path, version: 2,
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

    this._database.addHook(
        (event) =>
            event.table == 'Users' &&
            event.operation == DatabaseOperation.insert, (event) {
      print(event.values);
    }, 'NewUserHook');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sqflite hooks example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Database insert'),
                onPressed: () =>
                    this._database.insert('Users', {'Name': 'Mx Doe'}),
              ),
              RaisedButton(
                child: Text('Database batch'),
                onPressed: () async {
                  var batch = this._database.batch();

                  batch.insert('Users', {'Name': 'Mx Smith'});
                  batch.insert('Users', {'Name': 'Mx Williams'});

                  await batch.commit();
                },
              ),
              RaisedButton(
                child: Text('Database transaction'),
                onPressed: () async {
                  await this._database.transaction((transaction) async {
                    var batch = transaction.batch();

                    batch.insert('Users', {'Name': 'Mx Jones'});
                    batch.insert('Users', {'Name': 'Mx Daniels'});

                    await batch.commit();

                    await transaction.insert('Users', {'Name': 'Mx Brown'});
                    await transaction.insert('Users', {'Name': 'Mx Wright'});
                  }, onRollBack: (events) {
                    for (var event in events) {
                      print(event);
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
