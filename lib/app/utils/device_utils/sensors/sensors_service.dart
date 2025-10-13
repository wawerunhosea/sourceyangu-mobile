// Access accelerometer, gyroscope, etc.S

import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  Stream<AccelerometerEvent> get accelerometerStream =>
      accelerometerEventStream();
  Stream<GyroscopeEvent> get gyroscopeStream => gyroscopeEventStream();
}
