# sqflite_hooks

An extension to [sqflite](https://pub.dev/packages/sqflite) for adding hooks to database actions.

## Getting Started

In your flutter project add the dependency:

```yaml
dependencies:
  ...
  sqflite_hooks: ^1.0.0
```

[sqflite](https://pub.dev/packages/sqflite) is included as part of this package but if you require a specific version, make sure this is added to your `pubspec.yaml`.

For help getting started with Flutter, view the online documentation.

## Usage example

The usage is no different to [sqflite](https://pub.dev/packages/sqflite). Just be sure to import `sqflite_hooks` instead of `sqflite`:

```dart
import 'package:sqflite_hooks/sqflite_hooks.dart';
```

Then you can open and create your database like so:

```dart
var databasesPath = await getDatabasesPath();
var path = join(databasesPath, 'demo.db');
var database = await openDatabase(path, version: 1,
    onCreate: (database, version) async {
    await database.execute(
        '''CREATE TABLE Users (Id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT NOT NULL);''');
});
```

### Using hooks

The main difference when using `sqflite_hooks` is that you can add hooks to a database object. This allows you to easily run Dart code when actions occur on your database.

```dart
database.addHook(
    (event) => event.table == 'Users' && event.operation == DatabaseOperation.insert,
    (event) {
        // do something when a new record is inserted on the Users table
    },
    'NewUserHook');
```

The `addHook` method is as follows:

```dart
void addHook(bool Function(DatabaseEvent) predicate, Function(DatabaseEvent) hook, String key)
```

- The `predicate` parameter is a `Function` which should return `true` if the `hook` should run. A `predicate` should **not** be marked as `async`.
- The `hook` parameter is a `Function` which will run should the `predicate` return true. A `hook` can be `async`.
- The `key` parameter is a `String` used for keeping track of hooks and removing them later.

The `DatabaseEvent` class contains the following properties:

```dart
final DatabaseOperation operation;
final String table;
final Map<String, dynamic> values;
final String where;
final List whereArgs;
```

The `operation` property is a `DatabaseOperation` enum which has the following values:

```dart
enum DatabaseOperation { insert, update, delete }
```

Hooks can be removed like so:

```dart
database.removeHook('NewUserHook');
```

**Please note:** all hooks for a `predicate` returning `true` will run and be `await`-ed before the database operation completes.

### Transactions

Hooks on a `HookedDatabase` will also be fired when using a `HookedTransaction`. You can get a `HookedTransaction` object as you would usually get a `Transaction`:

```dart
await database.transaction((transaction) async {
    // this gives you a HookedTransaction object but the type exposed is a Transaction

    // use the transaction object as normal
});
```

Hooks get fired for each `operation` performed on a `HookedTransaction`

### Batches

Hooks on a `HookedDatabase` will also be fired when using a `HookedBatch`. You can get a `HookedBatch` object as you would usually get a `Batch`:

```dart
var batch = database.batch(); // this returns a HookedBatch object but the type exposed is a Batch
```

Hooks get fired once the `commit` method has been called on the `HookedBatch`, but after **all database operations for the batch has completed**.

A `HookedBatch` is also provided when using `transaction.batch()` and has its hooks fired once the `commit` method is called.
