// ignore_for_file: unnecessary_import

import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> initSqflitePlatformImpl() async {
  // На iOS/Android/macOS используется нативный sqflite — инициализация не нужна.
  // На Windows/Linux требуется FFI.
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
