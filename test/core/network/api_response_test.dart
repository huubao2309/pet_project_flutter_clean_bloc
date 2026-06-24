import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/api_response.dart';

void main() {
  group('ApiResponse.fromJson', () {
    test('parses a full success envelope and maps data via fromJsonT', () {
      final json = <String, dynamic>{
        'success': true,
        'data': {'id': 7},
        'message': 'ok',
        'verdict': 'success',
        'status_code': 200,
        'meta': {'page': 1},
      };

      final response = ApiResponse<int>.fromJson(
        json,
        (raw) => (raw as Map<String, dynamic>)['id'] as int,
      );

      expect(response.success, isTrue);
      expect(response.data, 7);
      expect(response.message, 'ok');
      expect(response.verdict, 'success');
      expect(response.statusCode, 200);
      expect(response.meta, {'page': 1});
    });

    test('defaults success to false when absent', () {
      final response = ApiResponse<String>.fromJson(
        <String, dynamic>{},
        (raw) => raw as String,
      );
      expect(response.success, isFalse);
      expect(response.data, isNull);
      expect(response.message, isNull);
      expect(response.verdict, isNull);
      expect(response.statusCode, isNull);
      expect(response.meta, isNull);
    });

    test('does not invoke fromJsonT when data is null', () {
      var called = false;
      final response = ApiResponse<String>.fromJson(
        <String, dynamic>{'success': false, 'data': null},
        (raw) {
          called = true;
          return raw as String;
        },
      );
      expect(called, isFalse);
      expect(response.data, isNull);
    });

    test('reads failure message and verdict', () {
      final response = ApiResponse<Object>.fromJson(
        <String, dynamic>{
          'success': false,
          'message': 'login failed',
          'verdict': 'login_failed',
          'status_code': 401,
        },
        (raw) => raw as Object,
      );
      expect(response.success, isFalse);
      expect(response.message, 'login failed');
      expect(response.verdict, 'login_failed');
      expect(response.statusCode, 401);
    });
  });

  group('ApiResponse default constructor', () {
    test('exposes provided fields', () {
      const response = ApiResponse<int>(success: true, data: 42);
      expect(response.success, isTrue);
      expect(response.data, 42);
      expect(response.message, isNull);
    });
  });
}
