class UserSession {
  final String uid; // Firebase UID
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String googleId; // Google account ID

  UserSession({
    required this.uid,
    required this.email,
    required this.googleId,
    this.displayName,
    this.photoUrl,
  });
}

// For google sign-in
class AuthResult {
  final UserSession? session;
  final String? error;

  AuthResult({this.session, this.error});

  bool get isSuccess => session != null;
}
