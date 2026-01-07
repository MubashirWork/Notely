import 'package:notely/core/data/database/constants/note/note.dart';
import 'package:notely/core/data/database/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDao {
  // Private constructor
  NoteDao._();

  // Singleton
  static final NoteDao instance = NoteDao._();

  Future<Database> get db async => DBHelper.instance.getDB();

  /// Performing crud operations

  // Adding note
  Future<bool> addNote({
    required String username,
    required String title,
    required String description,
    required String date,
  }) async {
    final db = await NoteDao.instance.db;
    int addNote = await db.insert(Note.tableName, {
      Note.username: username,
      Note.colTitle: title,
      Note.colDesc: description,
      Note.colDate: date,
    });
    return addNote > 0;
  }

  // Updating note
  Future<bool> updateNote({
    required int id,
    required String title,
    required String description,
    required String date,
  }) async {
    final db = await NoteDao.instance.db;
    int updateNote = await db.update(
      Note.tableName,
      {Note.colTitle: title, Note.colDesc: description, Note.colDate: date},
      where: "${Note.tableId} = ?",
      whereArgs: [id],
    );
    return updateNote > 0;
  }

  // Delete note
  Future<bool> deleteNote({required int id}) async {
    final db = await NoteDao.instance.db;
    int deleteNote = await db.delete(
      Note.tableName,
      where: '${Note.tableId} = ?',
      whereArgs: [id],
    );
    return deleteNote > 0;
  }

  // Get all notes based on username
  Future<List<Map<String, dynamic>>> getUsernameNote({
    required String username,
  }) async {
    final db = await NoteDao.instance.db;
    final getNote = await db.query(
      Note.tableName,
      where: '${Note.username} = ?',
      whereArgs: [username],
      orderBy: '${Note.tableId} DESC'
    );
    return getNote;
  }
}
