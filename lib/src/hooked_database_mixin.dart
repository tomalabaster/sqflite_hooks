import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_hooks/src/base_hooked_database.dart';
import 'package:sqflite_hooks/src/database_event.dart';
import 'package:sqflite_hooks/src/database_hook.dart';
import 'package:sqflite_hooks/src/hooked_transaction.dart';
import 'package:sqflite_hooks/src/hooked_transaction_exception.dart';

mixin HookedDatabaseMixin on BaseHookedDatabase, Database {
  List<DatabaseHook> _hooks;

  @override
  Future<void> close() => this.database.close();

  /// testing only
  @deprecated
  @override
  Future<T> devInvokeMethod<T>(String method, [arguments]) =>
      this.database.devInvokeMethod(method);

  /// testing only
  @deprecated
  @override
  Future<T> devInvokeSqlMethod<T>(String method, String sql,
          [List arguments]) =>
      this.database.devInvokeSqlMethod(method, sql);

  @override
  Future<int> getVersion() => this.database.getVersion();

  @override
  bool get isOpen => this.database?.isOpen ?? false;

  @override
  String get path => this.database?.path;

  @override
  Future<void> setVersion(int version) => this.database.setVersion(version);

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action,
          {bool exclusive, Function(List<DatabaseEvent>) onRollBack}) =>
      this.database.transaction((transaction) async {
        var result;

        try {
          result = await action(HookedTransaction(transaction, this));
        } on HookedTransactionException catch (e) {
          if (onRollBack != null) {
            await onRollBack(e.executedDatabaseEvents);
          }

          throw e.exception;
        }

        return result;
      }, exclusive: exclusive);

  void addHook(bool Function(DatabaseEvent) predicate,
      Function(DatabaseEvent) hook, String key) {
    if (this._hooks == null) {
      this._hooks = [];
    }

    this._hooks.add(DatabaseHook(key, hook, predicate));
  }

  void removeHook(String key) {
    if (this._hooks == null || this._hooks.isEmpty) {
      return;
    }

    this._hooks.removeWhere((hook) => hook.key == key);
  }

  Future<void> processHooks(DatabaseEvent event) async {
    if (this._hooks == null) {
      return;
    }

    for (var hook in this._hooks) {
      if (hook.predicate(event)) {
        await hook.hook(event);
      }
    }
  }
}
