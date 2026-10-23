// lib/services/device_info_service.dart

// Сначала идет условный экспорт, который выберет нужный файл реализации
export 'device_info_service_web.dart'
    if (dart.library.io) 'device_info_service_native.dart';

// Абстрактный класс остается здесь же
abstract class DeviceInfoService {
  Future<String> getDeviceInfo();
}
