// /lib/components/route_generator.dart

export 'route_generator_debug.dart' // По умолчанию (для отладки) используем простой роутер
    if (dart.library.release) 'route_generator_release.dart'; // Если сборка релизная, используем роутер с отложенной загрузкой
