import 'dart:io';
import 'package:notely/core/data/database/models/note/note_table.dart';
import 'package:notely/core/data/database/models/user/user_table.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  // Private constructor
  DBHelper._();

  // Singleton for DBHelper
  static final DBHelper instance = DBHelper._();

  // Database object
  static Database? myDB;

  // Initializing database for first time
  Future<Database> getDB() async {
    myDB ??= await createDB();
    return myDB!;
  }

  // Creating database
  Future<Database> createDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = join(appDir.path, 'notely.db');
    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute(UserTable.createTable);
      await db.execute(NoteTable.createTable);
    }, version: 1);
  }
}