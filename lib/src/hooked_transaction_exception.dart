import 'package:sqflite_hooks/src/database_event.dart';

class HookedTransactionException implements Exception {
  final Exception exception;
  final List<DatabaseEvent> executedDatabaseEvents;

  HookedTransactionException(this.exception, this.executedDatabaseEvents);
}
