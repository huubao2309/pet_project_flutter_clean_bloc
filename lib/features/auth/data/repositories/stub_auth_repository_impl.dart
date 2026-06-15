import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/mock_assets.dart';
import '../../domain/entities/user_entity.dart';
import '../models/request/login_request_dto.dart';
import '../models/response/login_response_dto.dart';
import 'auth_repository.dart';

/// Hardcoded implementation of [AuthRepository] for UI development.
///
/// Use this while the real data layer is not yet implemented.
/// Replace with the GetIt-registered [AuthRepositoryImpl] when ready.
///
/// ── Stub vs Mock ──────────────────────────────────────────────────────────
/// This is a *stub* (fixed return values, no interaction verification).
/// A *mock* (e.g. from mockito/mocktail) belongs only in test files.
class StubAuthRepositoryImpl implements AuthRepository {
  const StubAuthRepositoryImpl();

  @override
  Future<UserEntity> login(LoginRequestDto request) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final raw = await rootBundle.loadString(MockAssets.loginSuccess);
    final response = LoginResponseDto.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    return response.data.userInfo.toEntity();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<UserEntity?> getCurrentUser() async => null;
}
