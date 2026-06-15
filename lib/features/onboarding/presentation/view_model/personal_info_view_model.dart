import '../../../../core/presentation/view_model.dart';
import '../../domain/entities/plan_type.dart';
import 'personal_info_state.dart';

/// View model for the personal-info onboarding step. Pure form state for now;
/// when a backend exists, [submit] should delegate to a use case.
class PersonalInfoViewModel extends ViewModel<PersonalInfoState> {
  PersonalInfoViewModel() : super(const PersonalInfoState());

  void onFirstNameChanged(String value) =>
      setState(currentState.copyWith(firstName: value));

  void onLastNameChanged(String value) =>
      setState(currentState.copyWith(lastName: value));

  void onPhoneChanged(String value) =>
      setState(currentState.copyWith(phoneNumber: value));

  void onDialCodeChanged(String value) =>
      setState(currentState.copyWith(dialCode: value));

  void onAddressChanged(String value) =>
      setState(currentState.copyWith(address: value));

  void onBoxChanged(String value) =>
      setState(currentState.copyWith(box: value));

  void onCreateSelfContactChanged({required bool value}) =>
      setState(currentState.copyWith(createSelfContact: value));

  void onPlanChanged(PlanType plan) =>
      setState(currentState.copyWith(plan: plan));

  /// Returns whether the step is valid and can advance. No backend call yet.
  bool submit() => currentState.canSubmit;
}
