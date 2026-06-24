import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/sign_up_result.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/sign_up_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/sign_up_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  setUpAll(() async {
    await ensureTestBinding();
    registerFallbackValue(const SignUpParams(phone: ''));
  });

  late MockSignUpUseCase useCase;

  setUp(() {
    useCase = MockSignUpUseCase();
  });

  SignUpViewModel build() => SignUpViewModel(signUpUseCase: useCase);

  test('onPhoneChanged validates the phone', () async {
    final vm = build();
    vm.onPhoneChanged('0900000000');
    expect(vm.currentState.isPhoneValid, isTrue);
    expect(vm.currentState.canSubmit, isTrue);

    vm.onPhoneChanged('bad');
    expect(vm.currentState.isPhoneValid, isFalse);
    await vm.close();
  });

  test('signUp is a no-op when phone invalid', () async {
    final vm = build();
    final states = <SignUpState>[];
    final sub = vm.stream.listen(states.add);

    await vm.signUp();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, isEmpty);
    verifyNever(() => useCase.execute(any()));
    await vm.close();
  });

  test('signUp surfaces otpChallenge when OTP required', () async {
    const challenge = OtpChallenge(resendSecs: 60, enableResendSecs: 30);
    when(() => useCase.execute(any()))
        .thenAnswer((_) async => const SignUpOtpRequired(challenge));
    final vm = build();
    vm.onPhoneChanged('0900000000');

    await vm.signUp();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.otpChallenge, same(challenge));
    await vm.close();
  });

  test('signUp sets isSuccess when completed outright', () async {
    when(() => useCase.execute(any()))
        .thenAnswer((_) async => const SignUpCompleted());
    final vm = build();
    vm.onPhoneChanged('0900000000');

    await vm.signUp();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isSuccess, isTrue);
    await vm.close();
  });

  test('signUp sets isBlocked on PhoneBlockedException', () async {
    when(() => useCase.execute(any()))
        .thenThrow(PhoneBlockedException('blocked'));
    final vm = build();
    vm.onPhoneChanged('0900000000');

    await vm.signUp();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isBlocked, isTrue);
    await vm.close();
  });

  test('signUp surfaces error on generic AppException', () async {
    when(() => useCase.execute(any()))
        .thenThrow(ServerException(message: 'server down'));
    final vm = build();
    vm.onPhoneChanged('0900000000');

    await vm.signUp();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isBlocked, isFalse);
    expect(vm.currentState.errorMessage, 'server down');
    await vm.close();
  });
}
