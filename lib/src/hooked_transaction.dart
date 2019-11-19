import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_hooks/src/database_event.dart';
import 'package:sqflite_hooks/src/database_operation.dart';
import 'package:sqflite_hooks/src/hooked_batch.dart';
import 'package:sqflite_hooks/src/hooked_database_executor_mixin.dart';

class HookedTransaction implements Transaction {
  final Transaction _transaction;
  final HookedDatabaseExecutorMixin _database;

  final List<DatabaseEvent> _events = [];

  HookedTransaction(this._transaction, this._database);

  @override
  Batch batch() => HookedBatch(this._transaction.batch(), this._database);

  @override
  Future<int> delete(String table, {String where, List whereArgs}) async {
    var result;

    try {
      result = await this
          ._transaction
          .delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      rethrow;
    }

    var event =
        DatabaseEvent(DatabaseOperation.delete, table, null, where, whereArgs);

    this._events.add(event);
    this._database.processHooks(event);

    return result;
  }

  @override
  Future<void> execute(String sql, [List arguments]) {
    try {
      return this._transaction.execute(sql, arguments);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) async {
    var result;

    try {
      result = await this._transaction.insert(table, values,
          nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
    } catch (e) {
      rethrow;
    }

    var event =
        DatabaseEvent(DatabaseOperation.insert, table, values, null, null);

    this._events.add(event);
    this._database.processHooks(event);

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct,
      List<String> columns,
      String where,
      List whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) {
    var result;

    try {
      result = this._transaction.query(table,
          distinct: distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset);
    } catch (e) {
      rethrow;
    }

    return result;
  }

  @override
  Future<int> rawDelete(String sql, [List arguments]) {
    var result;

    try {
      result = this._transaction.rawDelete(sql, arguments);
    } catch (e) {
      rethrow;
    }

    return result;
  }

  @override
  Future<int> rawInsert(String sql, [List arguments]) {
    var result;

    try {
      this._transaction.rawInsert(sql, arguments);
    } catch (e) {
      rethrow;
    }

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List arguments]) {
    var result;

    try {
      result = this._transaction.rawQuery(sql, arguments);
    } catch (e) {
      rethrow;
    }

    return result;
  }

  @override
  Future<int> rawUpdate(String sql, [List arguments]) {
    var result;

    try {
      result = this._transaction.rawUpdate(sql, arguments);
    } catch (e) {
      rethrow;
    }

    return result;
  }

  @override
  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    var result = await this._transaction.update(table, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);

    var event = DatabaseEvent(
        DatabaseOperation.update, table, values, where, whereArgs);

    this._events.add(event);
    this._database.processHooks(event);

    return result;
  }
}
