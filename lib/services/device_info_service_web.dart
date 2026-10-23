// lib/services/device_info_service_web.dart
import 'device_info_service.dart';

class DeviceInfoServiceImpl implements DeviceInfoService {
  @override
  Future<String> getDeviceInfo() async {
    // Для веба мы не можем получить много информации, возвращаем заглушку.
    return "Это веб-браузер";
  }
}
