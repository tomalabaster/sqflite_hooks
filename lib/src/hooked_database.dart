import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_hooks/src/base_hooked_database.dart';
import 'package:sqflite_hooks/src/hooked_database_executor_mixin.dart';
import 'package:sqflite_hooks/src/hooked_database_factory_mixin.dart';
import 'package:sqflite_hooks/src/hooked_database_mixin.dart';

class HookedDatabase extends BaseHookedDatabase
    with
        sqflite.Database,
        sqflite.DatabaseExecutor,
        sqflite.DatabaseFactory,
        HookedDatabaseMixin,
        HookedDatabaseExecutorMixin,
        HookedDatabaseFactoryMixin {}
