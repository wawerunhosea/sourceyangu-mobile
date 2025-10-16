import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App Permisions
class AppPermission {
  //getting api level
  static Future<int> getApiLevel() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt;
  }

  //camera permission
  static Future<bool> accessCamera() async {
    return await PermissionManager.ensure(
      Permission.camera,
      'camera_permission',
    );
  }

  // Gallery permision
  static Future<bool> accessGallery() async {
    final apiLevel = await getApiLevel();
    if (apiLevel >= 33) {
      return await PermissionManager.ensure(
        Permission.photos,
        'READ_MEDIA_IMAGES',
      );
    } else {
      return await PermissionManager.ensure(
        Permission.storage,
        'READ_EXTERNAL_STORAGE',
      );
    }
  }

  // Add other methods for fetching permissions here.
}

// The Abstract class for requesting device permissions
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
