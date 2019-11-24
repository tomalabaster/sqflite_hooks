import 'package:sqflite_hooks/src/database_event.dart';

/// An object representing a hook on a [HookedDatabase].
///
/// [key] is a [String] used to make sure hooks can be unregistered.
///
/// [hook] is the [Function] invoked if the appropriate criteria is met. It takes
/// a [DatabaseEvent] argument containing information about the action on the [Database].
///
/// [predicate] is the [Function] which is used to determine of the [hook] should be
/// fired. [predicate] takes a [DatabaseEvent] which can be used to check criteria for
/// if the [hook] should be fired or not.
class DatabaseHook {
  final String key;
  final Function(DatabaseEvent) hook;
  final bool Function(DatabaseEvent) predicate;

  DatabaseHook(this.key, this.hook, this.predicate);
}
