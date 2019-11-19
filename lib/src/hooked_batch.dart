import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_hooks/src/database_event.dart';
import 'package:sqflite_hooks/src/database_operation.dart';
import 'package:sqflite_hooks/src/hooked_database_executor_mixin.dart';

class HookedBatch implements Batch {
  final Batch _batch;
  final HookedDatabaseExecutorMixin _database;

  final List<DatabaseEvent> _events = [];

  HookedBatch(this._batch, this._database);

  @override
  Future<List> commit(
      {bool exclusive, bool noResult, bool continueOnError}) async {
    var result = await this._batch.commit(
        exclusive: exclusive,
        noResult: noResult,
        continueOnError: continueOnError);

    for (var event in this._events) {
      this._database.processHooks(event);
    }

    return result;
  }

  @override
  void delete(String table, {String where, List whereArgs}) {
    this._batch.delete(table, where: where, whereArgs: whereArgs);

    this._events.add(
        DatabaseEvent(DatabaseOperation.delete, table, null, where, whereArgs));
  }

  @override
  void execute(String sql, [List arguments]) =>
      this._batch.execute(sql, arguments);

  @override
  void insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) {
    this._batch.insert(table, values,
        nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

    this._events.add(
        DatabaseEvent(DatabaseOperation.insert, table, values, null, null));
  }

  @override
  void query(String table,
          {bool distinct,
          List<String> columns,
          String where,
          List whereArgs,
          String groupBy,
          String having,
          String orderBy,
          int limit,
          int offset}) =>
      this._batch.query(table,
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
  void rawDelete(String sql, [List arguments]) =>
      this._batch.rawDelete(sql, arguments);

  @override
  void rawInsert(String sql, [List arguments]) =>
      this._batch.rawInsert(sql, arguments);

  @override
  void rawQuery(String sql, [List arguments]) =>
      this._batch.rawQuery(sql, arguments);

  @override
  void rawUpdate(String sql, [List arguments]) =>
      this._batch.rawUpdate(sql, arguments);

  @override
  void update(String table, Map<String, dynamic> values,
      {String where, List whereArgs, ConflictAlgorithm conflictAlgorithm}) {
    this._batch.update(table, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);

    this._events.add(DatabaseEvent(
        DatabaseOperation.update, table, values, where, whereArgs));
  }
}
