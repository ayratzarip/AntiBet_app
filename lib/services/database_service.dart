import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:antibet/models/diary_entry.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static final DateFormat _ruDateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat _legacyDashDateTimeFormat =
      DateFormat('yyyy-MM-dd HH:mm');

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'antibet.db');
      debugPrint('Database path: $path');

      return await openDatabase(
        path,
        version: 4,
        onCreate: (db, version) async {
          debugPrint('Creating database tables...');
          await db.execute('''
            CREATE TABLE diary_entries (
              id TEXT PRIMARY KEY,
              dateMs INTEGER NOT NULL,
              date TEXT NOT NULL,
              place TEXT NOT NULL,
              company TEXT NOT NULL,
              circumstances TEXT NOT NULL,
              trigger TEXT NOT NULL,
              thoughts TEXT NOT NULL,
              sensations TEXT NOT NULL,
              intensity TEXT NOT NULL,
              actions TEXT NOT NULL,
              consequences TEXT NOT NULL DEFAULT ''
            )
          ''');
          await db.execute(
              'CREATE INDEX IF NOT EXISTS idx_diary_entries_dateMs ON diary_entries(dateMs)');
          debugPrint('Database tables created successfully');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            debugPrint('Migrating database to version 2...');
            await db.execute('ALTER TABLE diary_entries ADD COLUMN dateMs INTEGER');

            final rows = await db.query(
              'diary_entries',
              columns: const ['id', 'date'],
            );

            for (final row in rows) {
              final id = row['id'] as String;
              final raw = (row['date'] ?? '').toString();
              final parsed = _parseLegacyDate(raw);
              await db.update(
                'diary_entries',
                {
                  'dateMs': parsed.millisecondsSinceEpoch,
                  'date': _ruDateTimeFormat.format(parsed),
                },
                where: 'id = ?',
                whereArgs: [id],
              );
            }

            await db.execute(
                'CREATE INDEX IF NOT EXISTS idx_diary_entries_dateMs ON diary_entries(dateMs)');
            debugPrint('Migration to version 2 completed');
          }
          if (oldVersion < 3) {
            debugPrint('Migrating database to version 3...');
            await db.execute('ALTER TABLE diary_entries ADD COLUMN intensity TEXT NOT NULL DEFAULT ""');
            debugPrint('Migration to version 3 completed');
          }
          if (oldVersion < 4) {
            debugPrint('Migrating database to version 4...');
            await db.execute(
                'ALTER TABLE diary_entries ADD COLUMN consequences TEXT NOT NULL DEFAULT ""');
            debugPrint('Migration to version 4 completed');
          }
        },
        onOpen: (db) {
          debugPrint('Database opened successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Error initializing database: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Проверяет подключение к базе данных
  Future<bool> checkConnection() async {
    try {
      final db = await database;
      await db.rawQuery('SELECT 1');
      debugPrint('Database connection check: OK');
      return true;
    } catch (e) {
      debugPrint('Database connection check failed: $e');
      return false;
    }
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'diary_entries',
        orderBy: 'dateMs DESC',
      );
      return maps.map((map) => DiaryEntry.fromJson(map)).toList();
    } catch (e) {
      debugPrint('Error getting all entries: $e');
      return [];
    }
  }

  Future<List<DiaryEntry>> searchEntries(String query) async {
    try {
      final db = await database;
      final searchPattern = '%$query%';
      final List<Map<String, dynamic>> maps = await db.query(
        'diary_entries',
        where: '''
          place LIKE ? OR 
          company LIKE ? OR 
          circumstances LIKE ? OR 
          trigger LIKE ? OR 
          thoughts LIKE ? OR 
          sensations LIKE ? OR 
          intensity LIKE ? OR 
          actions LIKE ? OR 
          consequences LIKE ?
        ''',
        whereArgs: List.filled(9, searchPattern),
        orderBy: 'dateMs DESC',
      );
      return maps.map((map) => DiaryEntry.fromJson(map)).toList();
    } catch (e) {
      debugPrint('Error searching entries: $e');
      return [];
    }
  }

  static DateTime _parseLegacyDate(String raw) {
    if (raw.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    try {
      if (raw.contains('T')) return DateTime.parse(raw);
      if (raw.contains('-')) return _legacyDashDateTimeFormat.parseStrict(raw);
      return _ruDateTimeFormat.parseStrict(raw);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  Future<void> insertEntry(DiaryEntry entry) async {
    try {
      final db = await database;
      await db.insert(
        'diary_entries',
        entry.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error inserting entry: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    try {
      final db = await database;
      await db.update(
        'diary_entries',
        entry.toJson(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    } catch (e) {
      debugPrint('Error updating entry: $e');
      rethrow;
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      final db = await database;
      await db.delete(
        'diary_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error deleting entry: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
        debugPrint('Database closed successfully');
      }
    } catch (e) {
      debugPrint('Error closing database: $e');
      rethrow;
    }
  }
}
