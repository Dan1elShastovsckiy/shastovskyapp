// lib/services/device_info_service_native.dart
import 'package:device_info_plus/device_info_plus.dart';
import 'device_info_service.dart';

class DeviceInfoServiceImpl implements DeviceInfoService {
  @override
  Future<String> getDeviceInfo() async {
    // Здесь ваш код, который использует device_info_plus
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // Пример для Android
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return 'Running on ${androidInfo.model}';
  }
}
