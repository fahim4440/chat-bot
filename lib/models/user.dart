class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  // Convert Firebase user data to UserModel
  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }
}