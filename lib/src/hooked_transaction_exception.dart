import 'package:sqflite_hooks/src/database_event.dart';

/// An exception thrown when an exception is thrown during a [Transaction].
///
/// [exception] is the original sqflite [DatabaseException] thrown as part
/// of the transaction.
///
/// [executedDatabaseEvents] is a [List] of [DatabaseEvent]s fired up until
/// the transaction threw an exception.
class HookedTransactionException implements Exception {
  final Exception exception;
  final List<DatabaseEvent> executedDatabaseEvents;

  HookedTransactionException(this.exception, this.executedDatabaseEvents);
}
