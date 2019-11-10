import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_hooks/src/database_event.dart';
import 'package:sqflite_hooks/src/database_operation.dart';
import 'package:sqflite_hooks/src/hooked_database_mixin.dart';

mixin HookedDatabaseExecutorMixin on HookedDatabaseMixin, DatabaseExecutor {
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
      this.database.query(table,
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
  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    var result = await this
        .database
        .update(table, values, where: where, whereArgs: whereArgs);

    await this.processHooks(DatabaseEvent(
        DatabaseOperation.update, table, values, where, whereArgs));

    return result;
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) async {
    var result = await this.database.insert(table, values,
        nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

    await this.processHooks(
        DatabaseEvent(DatabaseOperation.insert, table, values, null, null));

    return result;
  }

  @override
  Batch batch() => this.database.batch();

  @override
  Future<int> delete(String table, {String where, List whereArgs}) async {
    var result =
        await this.database.delete(table, where: where, whereArgs: whereArgs);

    await this.processHooks(
        DatabaseEvent(DatabaseOperation.delete, table, null, where, whereArgs));

    return result;
  }

  @override
  Future<void> execute(String sql, [List arguments]) =>
      this.database.execute(sql, arguments);

  @override
  Future<int> rawDelete(String sql, [List arguments]) =>
      this.database.rawDelete(sql, arguments);

  @override
  Future<int> rawInsert(String sql, [List arguments]) =>
      this.database.rawInsert(sql, arguments);

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List arguments]) =>
      this.database.rawQuery(sql, arguments);

  @override
  Future<int> rawUpdate(String sql, [List arguments]) =>
      this.database.rawUpdate(sql, arguments);
}
