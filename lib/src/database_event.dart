import 'package:sqflite_hooks/src/database_operation.dart';

/// An object containing information about an action on the [Database].
///
/// [operation] is a [DatabaseOperation] enum which can be one of `insert`, `update` or `delete`.
///
/// [table] is the name of table the [operation] occured on.
///
/// [values] is the values used in an `insert` or `update` [operation]. It will be `null` when the [operation] is `delete`.
///
/// [where] is the [String] used in `update` or `delete` [operation]s.
///
/// [whereArgs] is the [List] of arguments provided for the [where] of a `update` or `delete` [operation].
class DatabaseEvent {
  final DatabaseOperation operation;
  final String table;
  final Map<String, dynamic> values;
  final String where;
  final List whereArgs;

  DatabaseEvent(
      this.operation, this.table, this.values, this.where, this.whereArgs);
}
