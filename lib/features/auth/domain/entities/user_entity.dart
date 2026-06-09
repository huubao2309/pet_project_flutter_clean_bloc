class UserEntity {
  const UserEntity({
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
