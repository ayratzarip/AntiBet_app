import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<void> initSqflitePlatformImpl() async {
  // Важно: задаём factory ДО первого вызова getDatabasesPath/openDatabase.
  databaseFactory = databaseFactoryFfiWeb;
}

