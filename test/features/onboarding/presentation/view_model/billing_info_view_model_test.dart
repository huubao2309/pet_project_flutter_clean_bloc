import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/onboarding/presentation/view_model/billing_info_view_model.dart';

void main() {
  test('starts empty and cannot submit', () {
    final vm = BillingInfoViewModel();
    expect(vm.currentState.canSubmit, isFalse);
    expect(vm.submit(), isFalse);
    vm.close();
  });

  test('field setters update state immutably', () async {
    final vm = BillingInfoViewModel();
    vm.onNameOnCardChanged('Bao Nguyen');
    vm.onCardNumberChanged('4111111111111111');
    vm.onCvcChanged('123');
    vm.onMonthChanged('12');
    vm.onYearChanged('2030');

    final s = vm.currentState;
    expect(s.nameOnCard, 'Bao Nguyen');
    expect(s.cardNumber, '4111111111111111');
    expect(s.cvc, '123');
    expect(s.month, '12');
    expect(s.year, '2030');
    await vm.close();
  });

  test('submit true once every field is filled', () async {
    final vm = BillingInfoViewModel();
    vm.onNameOnCardChanged('Bao');
    vm.onCardNumberChanged('4111');
    vm.onCvcChanged('123');
    vm.onMonthChanged('12');
    expect(vm.submit(), isFalse);

    vm.onYearChanged('2030');
    expect(vm.currentState.canSubmit, isTrue);
    expect(vm.submit(), isTrue);
    await vm.close();
  });
}
