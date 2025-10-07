class UserState {
  final String uid;
  final String name;
  final String email;
  final String phone;

  UserState({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  UserState copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
  }) {
    return UserState(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
