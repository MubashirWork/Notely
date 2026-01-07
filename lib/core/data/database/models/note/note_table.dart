import 'package:notely/core/data/database/constants/note/note.dart';

class NoteTable {
  static const String createTable = '''
    CREATE TABLE ${Note.tableName} (
      ${Note.tableId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Note.username} TEXT, 
      ${Note.colTitle} TEXT, 
      ${Note.colDesc} TEXT, 
      ${Note.colDate} TEXT 
    )
  ''';
}