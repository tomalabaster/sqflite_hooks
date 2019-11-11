import 'dart:async';

import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_hooks/src/hooked_database_mixin.dart';

mixin HookedDatabaseFactoryMixin on HookedDatabaseMixin, DatabaseFactory {
  @override
  Future<Database> openDatabase(String path,
      {OpenDatabaseOptions options}) async {
    var didRunOnOpen = false;

    FutureOr<void> onOpen(Database database) async {
      this.database = database;

      if (options?.onOpen != null) {
        await options.onOpen(database);
      }

      didRunOnOpen = true;
    }

    var result = await sqflite.openDatabase(path,
        version: options?.version,
        onConfigure: options?.onConfigure,
        onCreate: options?.onCreate,
        onUpgrade: options?.onUpgrade,
        onDowngrade: options?.onDowngrade,
        onOpen: onOpen,
        readOnly: options?.readOnly,
        singleInstance: options?.singleInstance);

    if (!didRunOnOpen) {
      onOpen(result);
    }

    return result;
  }

  @override
  Future<String> getDatabasesPath() => sqflite.getDatabasesPath();

  @override
  Future<void> deleteDatabase(String path) => sqflite.deleteDatabase(path);

  @override
  Future<bool> databaseExists(String path) => sqflite.databaseExists(path);
}
