import 'sqflite_platform_init_stub.dart'
    if (dart.library.html) 'sqflite_platform_init_web.dart'
    if (dart.library.io) 'sqflite_platform_init_io.dart';

/// Инициализация backend'а sqflite для разных платформ.
///
/// - Web: IndexedDB через `sqflite_common_ffi_web`
/// - Windows/Linux: FFI через `sqflite_common_ffi`
/// - iOS/Android/macOS: нативный `sqflite` (ничего делать не нужно)
Future<void> initSqflitePlatform() => initSqflitePlatformImpl();

