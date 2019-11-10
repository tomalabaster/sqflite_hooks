import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_hooks/src/hooked_database.dart';

export 'package:sqflite/sqflite.dart';
export 'package:sqflite_hooks/src/database_operation.dart';

Future<HookedDatabase> openDatabase(String path,
    {int version,
    sqflite.OnDatabaseConfigureFn onConfigure,
    sqflite.OnDatabaseCreateFn onCreate,
    sqflite.OnDatabaseVersionChangeFn onUpgrade,
    sqflite.OnDatabaseVersionChangeFn onDowngrade,
    sqflite.OnDatabaseOpenFn onOpen,
    bool readOnly = false,
    bool singleInstance = true}) async {
  final sqflite.OpenDatabaseOptions options = sqflite.OpenDatabaseOptions(
      version: version,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
      readOnly: readOnly,
      singleInstance: singleInstance);
  var hookedDatabase = HookedDatabase();
  await hookedDatabase.openDatabase(path, options: options);
  return hookedDatabase;
}
