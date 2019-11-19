import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_hooks/src/hooked_database_executor_mixin.dart';

class HookedBatch implements Batch {
  final Batch _batch;
  final HookedDatabaseExecutorMixin _database;

  HookedBatch(this._batch, this._database);

  @override
  Future<List> commit({bool exclusive, bool noResult, bool continueOnError}) =>
      this._batch.commit(
          exclusive: exclusive,
          noResult: noResult,
          continueOnError: continueOnError);

  @override
  void delete(String table, {String where, List whereArgs}) =>
      this._batch.delete(table, where: where, whereArgs: whereArgs);

  @override
  void execute(String sql, [List arguments]) =>
      this._batch.execute(sql, arguments);

  @override
  void insert(String table, Map<String, dynamic> values,
          {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) =>
      this._batch.insert(table, values,
          nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

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
          {String where,
          List whereArgs,
          ConflictAlgorithm conflictAlgorithm}) =>
      this._batch.update(table, values,
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm);
}
