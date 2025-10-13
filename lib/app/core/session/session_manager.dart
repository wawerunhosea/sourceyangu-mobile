import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sourceyangu/app/data/models/user.dart';

class SessionManager {
  static final _storage = FlutterSecureStorage();

  static Future<void> save(UserSession session) async {
    await _storage.write(key: 'uid', value: session.uid);
    await _storage.write(key: 'email', value: session.email);
    await _storage.write(key: 'displayName', value: session.displayName);
    await _storage.write(key: 'photoUrl', value: session.photoUrl);
    await _storage.write(key: 'googleId', value: session.googleId);
  }

  static Future<UserSession?> load() async {
    final uid = await _storage.read(key: 'uid');
    if (uid == null) return null;

    return UserSession(
      uid: uid,
      email: await _storage.read(key: 'email') ?? '',
      displayName: await _storage.read(key: 'displayName'),
      photoUrl: await _storage.read(key: 'photoUrl'),
      googleId: await _storage.read(key: 'googleId') ?? '',
    );
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
    return;
  }
}
