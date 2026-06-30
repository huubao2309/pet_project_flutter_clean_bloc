import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/change_password_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/change_password_view_model.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/use_cases/change_password_use_case.dart';

import '../../../../helpers/test_setup.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

void main() {
  setUpAll(() async {
    await ensureTestBinding();
    registerFallbackValue(
      const ChangePasswordParams(currentPassword: '', newPassword: ''),
    );
  });

  late MockChangePasswordUseCase useCase;

  setUp(() {
    useCase = MockChangePasswordUseCase();
  });

  ChangePasswordViewModel build() =>
      ChangePasswordViewModel(changePasswordUseCase: useCase);

  /// Drives the VM into a submittable state.
  void fillValid(ChangePasswordViewModel vm) {
    vm.onCurrentPasswordChanged('OldPass1!');
    vm.onNewPasswordChanged('NewPass1!');
    vm.onConfirmPasswordChanged('NewPass1!');
  }

  test('starts with default ChangePasswordState', () {
    final vm = build();
    expect(vm.currentState.currentPassword, '');
    expect(vm.currentState.canSubmit, isFalse);
    vm.close();
  });

  test('onNewPasswordChanged recomputes strength', () async {
    final vm = build();
    vm.onNewPasswordChanged('Ab1!aaaa');
    final s = vm.currentState.strength;
    expect(s.isAllValid, isTrue);
    await vm.close();
  });

  test('canSubmit true only when all fields valid and new != current',
      () async {
    final vm = build();
    fillValid(vm);
    expect(vm.currentState.canSubmit, isTrue);

    vm.onConfirmPasswordChanged('OldPass1!');
    expect(vm.currentState.canSubmit, isFalse);
    expect(vm.currentState.hasConfirmMismatch, isTrue);
    await vm.close();
  });

  test('changePassword is a no-op when cannot submit', () async {
    final vm = build();
    final states = <ChangePasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.changePassword();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, isEmpty);
    verifyNever(() => useCase.execute(any()));
    await vm.close();
  });

  test('changePassword emits loading then success on completion', () async {
    when(() => useCase.execute(any())).thenAnswer((_) async {});
    final vm = build();
    fillValid(vm);
    final states = <ChangePasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.changePassword();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states.first.isLoading, isTrue);
    expect(states.last.isLoading, isFalse);
    expect(states.last.isSuccess, isTrue);
    await vm.close();
  });

  test('changePassword surfaces error message on AppException', () async {
    when(() => useCase.execute(any()))
        .thenThrow(ServerException(message: 'wrong current password'));
    final vm = build();
    fillValid(vm);
    final states = <ChangePasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.changePassword();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isSuccess, isFalse);
    expect(vm.currentState.errorMessage, 'wrong current password');
    await vm.close();
  });
}
