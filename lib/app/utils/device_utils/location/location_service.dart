// Get coordinates, reverse geocoding

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sourceyangu/app/utils/device_utils/permission_manager.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    final granted = await PermissionManager.ensure(
      Permission.location,
      'location_permission',
    );
    if (!granted) return null;
    return await Geolocator.getCurrentPosition();
  }
}
