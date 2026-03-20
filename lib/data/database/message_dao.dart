import 'package:sqflite/sqflite.dart';
import '../models/message_model.dart';
import 'database_helper.dart';

class MessageDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertMessage(MessageModel message) async {
    final db = await _dbHelper.database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MessageModel>> getAllMessages() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) {
      return MessageModel.fromMap(maps[i]);
    });
  }

  /// Loads the last [limit] messages to be used as chat history.
  Future<List<MessageModel>> getLastMessages(int limit) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    // Return in ascending order for chat sessions
    return List.generate(maps.length, (i) {
      return MessageModel.fromMap(maps[i]);
    }).reversed.toList();
  }

  Future<void> deleteMessage(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearHistory() async {
    final db = await _dbHelper.database;
    await db.delete('messages');
  }
}
