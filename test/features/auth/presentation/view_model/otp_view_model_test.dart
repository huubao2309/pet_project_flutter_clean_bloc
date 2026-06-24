import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/verify_otp_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/otp_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/otp_timer_config.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/otp_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

const _config = OtpTimerConfig(
  validitySeconds: 5,
  resendCooldownSeconds: 3,
  maxAttempts: 3,
);

void main() {
  setUpAll(() async {
    await ensureTestBinding();
  });

  late MockVerifyOtpUseCase useCase;

  setUp(() {
    useCase = MockVerifyOtpUseCase();
  });

  OtpViewModel build() =>
      OtpViewModel(verifyOtpUseCase: useCase, config: _config);

  test('seeds timers from config on construction (via _restart)', () async {
    final vm = build();
    expect(vm.currentState.secondsLeft, 5);
    expect(vm.currentState.resendIn, 3);
    expect(vm.currentState.attempts, 0);
    await vm.close();
  });

  test('onCodeChanged updates code and clears a previous invalid error',
      () async {
    final vm = build();
    vm.onCodeChanged('123456');
    expect(vm.currentState.code, '123456');
    expect(vm.currentState.canVerify, isTrue);
    await vm.close();
  });

  test('canVerify is false for short codes', () async {
    final vm = build();
    vm.onCodeChanged('123');
    expect(vm.currentState.canVerify, isFalse);
    await vm.close();
  });

  group('verify', () {
    test('is a no-op when canVerify is false', () async {
      final vm = build();
      await vm.verify();
      expect(vm.currentState.isVerified, isFalse);
      verifyNever(() => useCase.execute(any()));
      await vm.close();
    });

    test('sets isVerified and verifyResult on success', () async {
      when(() => useCase.execute(any()))
          .thenAnswer((_) async => const VerifyOtpAuthenticated());
      final vm = build();
      vm.onCodeChanged('123456');

      await vm.verify();

      expect(vm.currentState.isVerified, isTrue);
      expect(vm.currentState.isVerifying, isFalse);
      expect(vm.currentState.verifyResult, isA<VerifyOtpAuthenticated>());
      await vm.close();
    });

    test('flags invalid error and bumps attempts on wrong code', () async {
      when(() => useCase.execute(any()))
          .thenThrow(ServerException(message: 'bad'));
      final vm = build();
      vm.onCodeChanged('000000');

      await vm.verify();

      expect(vm.currentState.error, OtpError.invalid);
      expect(vm.currentState.attempts, 1);
      expect(vm.currentState.isLocked, isFalse);
      await vm.close();
    });

    test('locks after maxAttempts wrong codes', () async {
      when(() => useCase.execute(any()))
          .thenThrow(ServerException(message: 'bad'));
      final vm = build();

      for (var i = 0; i < _config.maxAttempts; i++) {
        // A fresh non-error code keeps canVerify true between attempts.
        vm.onCodeChanged('00000$i');
        await vm.verify();
      }

      expect(vm.currentState.attempts, _config.maxAttempts);
      expect(vm.currentState.isLocked, isTrue);
      await vm.close();
    });
  });

  test('resend is a no-op while cooldown active', () async {
    final vm = build();
    // resendIn starts at 3 (> 0) so canResend is false.
    expect(vm.currentState.canResend, isFalse);
    await vm.resend();
    verifyNever(() => useCase.execute(any()));
    await vm.close();
  });

  group('timer (fakeAsync)', () {
    test('ticks down secondsLeft and resendIn each second', () {
      fakeAsync((async) {
        final vm = build();
        async.elapse(const Duration(seconds: 1));
        expect(vm.currentState.secondsLeft, 4);
        expect(vm.currentState.resendIn, 2);
        vm.close();
        async.flushTimers();
      });
    });

    test('flags expired when validity reaches zero', () {
      fakeAsync((async) {
        final vm = build();
        async.elapse(const Duration(seconds: 5));
        expect(vm.currentState.secondsLeft, 0);
        expect(vm.currentState.error, OtpError.expired);
        vm.close();
        async.flushTimers();
      });
    });

    test('resend becomes available once cooldown elapses', () {
      fakeAsync((async) {
        final vm = build();
        async.elapse(const Duration(seconds: 3));
        expect(vm.currentState.resendIn, 0);
        expect(vm.currentState.canResend, isTrue);
        vm.close();
        async.flushTimers();
      });
    });
  });
}
