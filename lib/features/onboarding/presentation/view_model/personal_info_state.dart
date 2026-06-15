import '../../domain/entities/plan_type.dart';

/// Immutable form state for the personal-info onboarding step.
class PersonalInfoState {
  const PersonalInfoState({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.dialCode = '+32',
    this.address = '',
    this.box = '',
    this.createSelfContact = true,
    this.plan = PlanType.personally,
  });

  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String dialCode;
  final String address;
  final String box;
  final bool createSelfContact;
  final PlanType plan;

  bool get canSubmit =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      address.isNotEmpty;

  PersonalInfoState copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? dialCode,
    String? address,
    String? box,
    bool? createSelfContact,
    PlanType? plan,
  }) {
    return PersonalInfoState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dialCode: dialCode ?? this.dialCode,
      address: address ?? this.address,
      box: box ?? this.box,
      createSelfContact: createSelfContact ?? this.createSelfContact,
      plan: plan ?? this.plan,
    );
  }
}
