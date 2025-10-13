// Monitor battery percentage
import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final _battery = Battery();

  Future<int> getBatteryLevel() async {
    return await _battery.batteryLevel;
  }
}
