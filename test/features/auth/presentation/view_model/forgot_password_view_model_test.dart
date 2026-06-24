import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/otp_challenge.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/forgot_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/forgot_password_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/forgot_password_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockForgotPasswordUseCase extends Mock
    implements ForgotPasswordUseCase {}

void main() {
  setUpAll(() async {
    await ensureTestBinding();
  });

  late MockForgotPasswordUseCase useCase;

  setUp(() {
    useCase = MockForgotPasswordUseCase();
  });

  ForgotPasswordViewModel build() =>
      ForgotPasswordViewModel(forgotPasswordUseCase: useCase);

  test('onPhoneChanged validates the (trimmed) phone', () async {
    final vm = build();
    vm.onPhoneChanged(' 0900000000 ');
    expect(vm.currentState.isPhoneValid, isTrue);
    expect(vm.currentState.canSubmit, isTrue);

    vm.onPhoneChanged('123');
    expect(vm.currentState.isPhoneValid, isFalse);
    await vm.close();
  });

  test('forgotPassword is a no-op when phone is invalid', () async {
    final vm = build();
    final states = <ForgotPasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.forgotPassword();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, isEmpty);
    verifyNever(() => useCase.execute(any()));
    await vm.close();
  });

  test('forgotPassword emits loading then sets otpChallenge on success',
      () async {
    const challenge = OtpChallenge(resendSecs: 60, enableResendSecs: 30);
    when(() => useCase.execute(any())).thenAnswer((_) async => challenge);
    final vm = build();
    vm.onPhoneChanged('0900000000');
    final states = <ForgotPasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.forgotPassword();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states.first.isLoading, isTrue);
    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.otpChallenge, same(challenge));
    verify(() => useCase.execute('0900000000')).called(1);
    await vm.close();
  });

  test('forgotPassword surfaces error on AppException', () async {
    when(() => useCase.execute(any()))
        .thenThrow(ServerException(message: 'no such phone'));
    final vm = build();
    vm.onPhoneChanged('0900000000');

    await vm.forgotPassword();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.otpChallenge, isNull);
    expect(vm.currentState.errorMessage, 'no such phone');
    await vm.close();
  });
}
