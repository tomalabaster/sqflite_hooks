import 'package:sqflite_hooks/src/database_operation.dart';

class DatabaseEvent {
  final DatabaseOperation operation;
  final String table;
  final Map<String, dynamic> values;
  final String where;
  final List whereArgs;

  DatabaseEvent(
      this.operation, this.table, this.values, this.where, this.whereArgs);
}
