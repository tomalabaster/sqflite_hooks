import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_hooks/sqflite_hooks.dart';
import 'package:sqflite_hooks/src/hooked_database.dart';

import 'mocks/mock_some_service.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.tekartik.sqflite');

  MockSomeService mockSomeService;
  HookedDatabase sut;

  setUpAll(() {
    channel.setMockMethodCallHandler((call) {
      if (call.method == 'getDatabasesPath') {
        return Future.value('');
      } else if (call.method == 'insert' ||
          call.method == 'update' ||
          call.method == 'delete') {
        return Future.value(1);
      } else {
        return Future.value(Map());
      }
    });
  });

  tearDownAll(() {
    channel.setMockMethodCallHandler(null);
  });

  Future<void> sharedSetUp() async {
    mockSomeService = MockSomeService();
    sut = await openDatabase('path');
    sut.addHook(
        (event) => true, (event) => mockSomeService.doSomething(), 'Hook');
  }

  group('Given a sqflite hooked database', () {
    group('When there are registered hooks', () {
      group('And the database is queried', () {
        test('No hooks are ran', () async {
          await sharedSetUp();

          await sut.query('SomeTable');

          verifyZeroInteractions(mockSomeService);
        });
      });

      group('And a record is inserted', () {
        test('The hooks are ran', () async {
          await sharedSetUp();

          await sut.insert('SomeTable', {'SomeColumn': 'SomeValue'});

          verify(mockSomeService.doSomething());
        });
      });

      group('And a record is updated', () {
        test('The hooks are ran', () async {
          await sharedSetUp();

          await sut.update('SomeTable', {'SomeColumn': 'SomeValue'});

          verify(mockSomeService.doSomething());
        });
      });

      group('And a record is deleted', () {
        test('The hooks are ran', () async {
          await sharedSetUp();

          await sut.delete('SomeTable', where: '');

          verify(mockSomeService.doSomething());
        });
      });
    });
  });
}
