import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mnemosyne.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    dev.log('Initializing database at $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    dev.log('Creating database tables...');
    try {
      await db.execute('''
        CREATE TABLE messages (
          id TEXT PRIMARY KEY,
          content TEXT NOT NULL,
          role TEXT NOT NULL,
          timestamp TEXT NOT NULL,
          attachments TEXT
        )
      ''');
      
      await db.execute('''
        CREATE TABLE instructions (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
      dev.log('Tables created successfully.');
    } catch (e) {
      dev.log('Error creating database tables: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
