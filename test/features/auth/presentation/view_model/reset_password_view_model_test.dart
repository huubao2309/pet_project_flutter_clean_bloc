import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/reset_password_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/reset_password_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockResetPasswordUseCase extends Mock
    implements ResetPasswordUseCase {}

void main() {
  setUpAll(() async {
    await ensureTestBinding();
  });

  late MockResetPasswordUseCase useCase;

  setUp(() {
    useCase = MockResetPasswordUseCase();
  });

  ResetPasswordViewModel build() =>
      ResetPasswordViewModel(resetPasswordUseCase: useCase);

  void fillValid(ResetPasswordViewModel vm) {
    vm.onPasswordChanged('NewPass1!');
    vm.onConfirmPasswordChanged('NewPass1!');
  }

  test('canSubmit requires valid strength and matching confirmation',
      () async {
    final vm = build();
    fillValid(vm);
    expect(vm.currentState.canSubmit, isTrue);
    await vm.close();
  });

  test('resetPassword is a no-op when cannot submit', () async {
    final vm = build();
    final states = <ResetPasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.resetPassword();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, isEmpty);
    verifyNever(() => useCase.execute(any()));
    await vm.close();
  });

  test('resetPassword emits loading then isResetSuccess', () async {
    when(() => useCase.execute(any())).thenAnswer((_) async {});
    final vm = build();
    fillValid(vm);
    final states = <ResetPasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.resetPassword();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states.first.isLoading, isTrue);
    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isResetSuccess, isTrue);
    verify(() => useCase.execute('NewPass1!')).called(1);
    await vm.close();
  });

  test('resetPassword surfaces error on AppException', () async {
    when(() => useCase.execute(any()))
        .thenThrow(ServerException(message: 'expired session'));
    final vm = build();
    fillValid(vm);

    await vm.resetPassword();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isResetSuccess, isFalse);
    expect(vm.currentState.errorMessage, 'expired session');
    await vm.close();
  });
}
