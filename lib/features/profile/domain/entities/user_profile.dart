/// The signed-in user's profile, shown on the Profile tab.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
  });

  final String id;
  final String fullName;
  final String phone;
  final String? email;
}
