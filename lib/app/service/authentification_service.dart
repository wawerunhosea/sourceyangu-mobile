import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sourceyangu/app/data/models/user.dart';
import 'package:sourceyangu/app/service/authentification_service.dart' as auth;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email & password
  Future<AuthResult> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;

      if (user == null) {
        return AuthResult(error: 'Failed to retrieve user');
      }

      final session = UserSession(
        uid: user.uid,
        email: user.email ?? email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        googleId: '', // Not applicable for email/password
      );

      return AuthResult(session: session);
    } catch (e) {
      return AuthResult(error: _handleFirebaseError(e));
    }
  }

  // Sign up with email & password
  Future<AuthResult> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await signIn(email, password); // success
    } catch (e) {
      return AuthResult(error: _handleFirebaseError(e));
    }
  }

  // Sign in with Google
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<AuthResult> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final event = await _googleSignIn.authenticate(scopeHint: ['email']);
      final auth = event.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken:
            (await event.authorizationClient.authorizationForScopes([
              'email',
            ]))?.accessToken,
        idToken: auth.idToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return AuthResult(error: 'Firebase sign-in failed');
      }

      final session = UserSession(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? event.email,
        displayName: firebaseUser.displayName ?? event.displayName,
        photoUrl: firebaseUser.photoURL ?? event.photoUrl,
        googleId: event.id,
      );

      return AuthResult(session: session);

      // success
    } catch (e) {
      if (e is GoogleSignInException) {
        switch (e.code) {
          case GoogleSignInExceptionCode.canceled:
            return AuthResult(error: 'Error: $e');
          default:
            return AuthResult(error: 'Google Sign-In error: ${e.code.name}');
        }
      }
      return AuthResult(error: 'Unexpected error: $e');
    }
  }

  // Sign in with Apple

  Future<String?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);
      return null;
    } catch (e) {
      return _handleFirebaseError(e);
    }
  }
}

Future<void> signOut() async {
  await auth.signOut();
}

String _handleFirebaseError(dynamic error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email format';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Authentication error';
    }
  }
  return error.toString(); // fallback
}
