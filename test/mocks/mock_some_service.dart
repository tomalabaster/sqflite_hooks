import 'package:mockito/mockito.dart';

abstract class SomeService {
  void doSomething();
}

class MockSomeService extends Mock implements SomeService {}
