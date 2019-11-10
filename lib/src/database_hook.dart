
import 'package:sqflite_hooks/src/database_event.dart';

class DatabaseHook {
  final String key;
  final Function(DatabaseEvent) hook;
  final bool Function(DatabaseEvent) predicate;

  DatabaseHook(this.key, this.hook, this.predicate);
}
