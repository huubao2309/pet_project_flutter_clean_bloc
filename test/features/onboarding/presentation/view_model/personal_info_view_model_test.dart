import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/domain/entities/plan_type.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/presentation/view_model/personal_info_view_model.dart';

void main() {
  test('starts with sensible defaults and cannot submit', () {
    final vm = PersonalInfoViewModel();
    final s = vm.currentState;
    expect(s.dialCode, '+32');
    expect(s.createSelfContact, isTrue);
    expect(s.plan, PlanType.personally);
    expect(s.canSubmit, isFalse);
    expect(vm.submit(), isFalse);
    vm.close();
  });

  test('field setters update state', () async {
    final vm = PersonalInfoViewModel();
    vm.onFirstNameChanged('Bao');
    vm.onLastNameChanged('Nguyen');
    vm.onPhoneChanged('0900000000');
    vm.onDialCodeChanged('+84');
    vm.onAddressChanged('123 Street');
    vm.onBoxChanged('B1');
    vm.onCreateSelfContactChanged(value: false);
    vm.onPlanChanged(PlanType.professionally);

    final s = vm.currentState;
    expect(s.firstName, 'Bao');
    expect(s.lastName, 'Nguyen');
    expect(s.phoneNumber, '0900000000');
    expect(s.dialCode, '+84');
    expect(s.address, '123 Street');
    expect(s.box, 'B1');
    expect(s.createSelfContact, isFalse);
    expect(s.plan, PlanType.professionally);
    await vm.close();
  });

  test('canSubmit requires name, valid phone and address', () async {
    final vm = PersonalInfoViewModel();
    vm.onFirstNameChanged('Bao');
    vm.onLastNameChanged('Nguyen');
    vm.onAddressChanged('123 Street');
    // Invalid phone keeps submit disabled.
    vm.onPhoneChanged('123');
    expect(vm.submit(), isFalse);

    vm.onPhoneChanged('0900000000');
    expect(vm.currentState.canSubmit, isTrue);
    expect(vm.submit(), isTrue);
    await vm.close();
  });
}
