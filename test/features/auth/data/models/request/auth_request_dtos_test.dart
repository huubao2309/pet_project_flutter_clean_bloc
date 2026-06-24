import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/forgot_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/login_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/register_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/reset_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/sign_up_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/data/models/request/verify_otp_request_dto.dart';

void main() {
  group('ForgotPasswordRequestDto', () {
    test('fromJson parses phone', () {
      final dto = ForgotPasswordRequestDto.fromJson({'phone': '0900000000'});
      expect(dto.phone, '0900000000');
    });

    test('toJson outputs phone key', () {
      const dto = ForgotPasswordRequestDto(phone: '0911111111');
      expect(dto.toJson(), {'phone': '0911111111'});
    });
  });

  group('LoginRequestDto', () {
    test('fromJson parses phone and password', () {
      final dto = LoginRequestDto.fromJson({
        'phone': '0900000000',
        'password': 'secret',
      });
      expect(dto.phone, '0900000000');
      expect(dto.password, 'secret');
    });

    test('toJson outputs phone and password keys', () {
      const dto = LoginRequestDto(phone: '0900000000', password: 'secret');
      expect(dto.toJson(), {'phone': '0900000000', 'password': 'secret'});
    });
  });

  group('RegisterPasswordRequestDto', () {
    test('fromJson maps session_token snake_case to sessionToken', () {
      final dto = RegisterPasswordRequestDto.fromJson({
        'password': 'pw',
        'session_token': 'tok-1',
      });
      expect(dto.password, 'pw');
      expect(dto.sessionToken, 'tok-1');
    });

    test('toJson outputs password and session_token keys', () {
      const dto = RegisterPasswordRequestDto(
        password: 'pw',
        sessionToken: 'tok-1',
      );
      expect(dto.toJson(), {'password': 'pw', 'session_token': 'tok-1'});
    });
  });

  group('ResetPasswordRequestDto', () {
    test('fromJson maps password->newPassword and session_token', () {
      final dto = ResetPasswordRequestDto.fromJson({
        'password': 'newpw',
        'session_token': 'tok-2',
      });
      expect(dto.newPassword, 'newpw');
      expect(dto.sessionToken, 'tok-2');
    });

    test('toJson outputs password (from newPassword) and session_token', () {
      const dto = ResetPasswordRequestDto(
        newPassword: 'newpw',
        sessionToken: 'tok-2',
      );
      expect(dto.toJson(), {'password': 'newpw', 'session_token': 'tok-2'});
    });
  });

  group('SignUpRequestDto', () {
    test('fromJson parses all fields incl status_update snake_case', () {
      final dto = SignUpRequestDto.fromJson({
        'phone': '0900000000',
        'language': 'en',
        'verify': true,
        'status_update': false,
      });
      expect(dto.phone, '0900000000');
      expect(dto.language, 'en');
      expect(dto.verify, true);
      expect(dto.statusUpdate, false);
    });

    test('fromJson leaves optional verify/status_update null when absent', () {
      final dto = SignUpRequestDto.fromJson({
        'phone': '0900000000',
        'language': 'vi',
      });
      expect(dto.verify, isNull);
      expect(dto.statusUpdate, isNull);
    });

    test('toJson outputs all keys including nulls', () {
      const dto = SignUpRequestDto(phone: '0900000000', language: 'en');
      expect(dto.toJson(), {
        'phone': '0900000000',
        'language': 'en',
        'verify': null,
        'status_update': null,
      });
    });
  });

  group('VerifyOtpRequestDto', () {
    test('fromJson maps otp->code and session_token->sessionToken', () {
      final dto = VerifyOtpRequestDto.fromJson({
        'otp': '123456',
        'session_token': 'tok-3',
      });
      expect(dto.code, '123456');
      expect(dto.sessionToken, 'tok-3');
    });

    test('toJson outputs otp (from code) and session_token', () {
      const dto = VerifyOtpRequestDto(code: '123456', sessionToken: 'tok-3');
      expect(dto.toJson(), {'otp': '123456', 'session_token': 'tok-3'});
    });
  });
}
