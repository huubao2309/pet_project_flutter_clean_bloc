import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/pre_auth_session.dart';

void main() {
  late PreAuthSession session;

  setUp(() {
    session = PreAuthSession();
  });

  group('initial state', () {
    test('token is null before any save', () {
      expect(session.token, isNull);
    });

    test('require() throws StateError when no flow is active', () {
      expect(session.require, throwsStateError);
    });
  });

  group('save', () {
    test('stores the token and exposes it via token', () {
      session.save('abc');
      expect(session.token, 'abc');
    });

    test('require() returns the saved token', () {
      session.save('abc');
      expect(session.require(), 'abc');
    });

    test('a later save overwrites the earlier token', () {
      session.save('first');
      session.save('second');
      expect(session.token, 'second');
      expect(session.require(), 'second');
    });

    test('an empty string is a valid (non-null) token', () {
      session.save('');
      expect(session.token, '');
      // require() only throws on null, not on empty.
      expect(session.require(), '');
    });
  });

  group('clear', () {
    test('resets token back to null', () {
      session.save('abc');
      session.clear();
      expect(session.token, isNull);
    });

    test('require() throws again after clear', () {
      session.save('abc');
      session.clear();
      expect(session.require, throwsStateError);
    });

    test('clear is idempotent', () {
      session.clear();
      session.clear();
      expect(session.token, isNull);
    });
  });
}
