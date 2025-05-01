class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String? chatGPTKey;
  final String? grokAIKey;
  final String? geminiAIKey;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.chatGPTKey,
    this.grokAIKey,
    this.geminiAIKey,
  });

  // Convert Firebase user data to UserModel
  factory UserModel.fromFirebaseUser(Map<String, dynamic> user) {
    return UserModel(
      uid: user['uid'] ?? '',
      name: user['displayName'] ?? '',
      email: user['email'] ?? '',
      photoUrl: user['photoUrl'] ?? '',
      chatGPTKey: user['chatGPTKey'],
      grokAIKey: user['grokAIKey'],
      geminiAIKey: user['geminiAIKey'],
    );
  }
}