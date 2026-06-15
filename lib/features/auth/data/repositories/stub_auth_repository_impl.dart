import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/mock_assets.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/response/login_response_dto.dart';

/// Hardcoded implementation of [AuthRepository] for UI development.
///
/// Use this while the real backend is not wired up. Swap it for the
/// GetIt-registered [AuthRepositoryImpl] (see core/di/injection.dart) when the
/// API is ready — nothing else in the app changes.
///
/// ── Stub vs Mock ──────────────────────────────────────────────────────────
/// This is a *stub* (fixed return values, no interaction verification).
/// A *mock* (e.g. from mockito/mocktail) belongs only in test files.
class StubAuthRepositoryImpl implements AuthRepository {
  const StubAuthRepositoryImpl();

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final raw = await rootBundle.loadString(MockAssets.loginSuccess);
    final response = LoginResponseDto.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    return response.data.userInfo.toEntity();
  }

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    bool? receiveUpdates,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<UserEntity?> getCurrentUser() async => null;
}
