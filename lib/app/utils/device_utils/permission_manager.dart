import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionManager {
  static Future<bool> ensure(Permission permission, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(key);

    if (stored == true) {
      final status = await permission.status;
      return status.isGranted;
    }

    final result = await permission.request();
    final granted = result.isGranted;

    await prefs.setBool(key, granted);
    return granted;
  }

  static Future<void> clearStoredPermission(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
