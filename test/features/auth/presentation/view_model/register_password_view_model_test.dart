import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/use_cases/register_password_use_case.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/register_password_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/register_password_view_model.dart';

import '../../../../helpers/test_setup.dart';

class MockRegisterPasswordUseCase extends Mock
    implements RegisterPasswordUseCase {}

void main() {
  setUpAll(() async {
    await ensureTestBinding();
  });

  late MockRegisterPasswordUseCase useCase;

  setUp(() {
    useCase = MockRegisterPasswordUseCase();
  });

  RegisterPasswordViewModel build() =>
      RegisterPasswordViewModel(registerPasswordUseCase: useCase);

  void fillValid(RegisterPasswordViewModel vm) {
    vm.onPasswordChanged('NewPass1!');
    vm.onConfirmPasswordChanged('NewPass1!');
  }

  test('onPasswordChanged recomputes strength', () async {
    final vm = build();
    vm.onPasswordChanged('NewPass1!');
    expect(vm.currentState.strength.isAllValid, isTrue);
    await vm.close();
  });

  test('canSubmit requires valid strength and matching confirmation', () async {
    final vm = build();
    fillValid(vm);
    expect(vm.currentState.canSubmit, isTrue);

    vm.onConfirmPasswordChanged('Different1!');
    expect(vm.currentState.canSubmit, isFalse);
    expect(vm.currentState.hasConfirmMismatch, isTrue);
    await vm.close();
  });

  test('submit is a no-op when cannot submit', () async {
    final vm = build();
    final states = <RegisterPasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.submit();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, isEmpty);
    verifyNever(() => useCase.execute(any()));
    await vm.close();
  });

  test('submit emits loading then success', () async {
    when(() => useCase.execute(any())).thenAnswer((_) async {});
    final vm = build();
    fillValid(vm);
    final states = <RegisterPasswordState>[];
    final sub = vm.stream.listen(states.add);

    await vm.submit();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states.first.isLoading, isTrue);
    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isSuccess, isTrue);
    verify(() => useCase.execute('NewPass1!')).called(1);
    await vm.close();
  });

  test('submit surfaces error on AppException', () async {
    when(() => useCase.execute(any()))
        .thenThrow(ServerException(message: 'failed'));
    final vm = build();
    fillValid(vm);

    await vm.submit();

    expect(vm.currentState.isLoading, isFalse);
    expect(vm.currentState.isSuccess, isFalse);
    expect(vm.currentState.errorMessage, 'failed');
    await vm.close();
  });
}
