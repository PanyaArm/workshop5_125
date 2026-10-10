import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';

// ข้อ 21, 25, 27, 29, 33, 34: ส่วนจัดการฐานข้อมูล (Back-end)
class NoteRepository {
  static const _dbName = 'notes_database.db';
  static const _tableName = 'notes';

  // ข้อ 25: เปิดฐานข้อมูล ถ้ายังไม่มีจะสร้างฐานข้อมูลและตารางให้
  static Future<Database> _database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title TEXT, description TEXT, createdAt TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  // ข้อ 27: เพิ่มข้อมูล
  static Future<void> insert({required Note note}) async {
    final db = await _database();
    await db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ข้อ 29: อ่านข้อมูลทั้งหมด
  static Future<List<Note>> getNotes() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  // ข้อ 33: แก้ไขข้อมูล
  static Future<void> update({required Note note}) async {
    final db = await _database();
    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // ข้อ 34: ลบข้อมูล
  static Future<void> delete({required Note note}) async {
    final db = await _database();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}