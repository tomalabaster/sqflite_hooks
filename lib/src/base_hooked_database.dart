import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseHookedDatabase {
  @protected
  Database database;
}
