import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_hooks/src/database_event.dart';
import 'package:sqflite_hooks/src/database_operation.dart';
import 'package:sqflite_hooks/src/hooked_database_executor_mixin.dart';

class HookedTransaction implements Transaction {
  final Transaction _transaction;
  final HookedDatabaseExecutorMixin _database;

  HookedTransaction(this._transaction, this._database);

  @override
  Batch batch() => this._transaction.batch();

  @override
  Future<int> delete(String table, {String where, List whereArgs}) async {
    var result = await this
        ._transaction
        .delete(table, where: where, whereArgs: whereArgs);

    this._database.processHooks(
        DatabaseEvent(DatabaseOperation.delete, table, null, where, whereArgs));

    return result;
  }

  @override
  Future<void> execute(String sql, [List arguments]) =>
      this._transaction.execute(sql, arguments);

  @override
  Future<int> insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) async {
    var result = await this._transaction.insert(table, values,
        nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

    this._database.processHooks(
        DatabaseEvent(DatabaseOperation.insert, table, values, null, null));

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
          int offset}) =>
      this._transaction.query(table,
          distinct: distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset);

  @override
  Future<int> rawDelete(String sql, [List arguments]) =>
      this._transaction.rawDelete(sql, arguments);

  @override
  Future<int> rawInsert(String sql, [List arguments]) =>
      this._transaction.rawInsert(sql, arguments);

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List arguments]) =>
      this._transaction.rawQuery(sql, arguments);

  @override
  Future<int> rawUpdate(String sql, [List arguments]) =>
      this._transaction.rawUpdate(sql, arguments);

  @override
  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    var result = await this._transaction.update(table, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);

    this._database.processHooks(DatabaseEvent(
        DatabaseOperation.update, table, values, where, whereArgs));

    return result;
  }
}
