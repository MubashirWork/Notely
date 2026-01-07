import 'dart:core';
import 'package:notely/core/data/database/constants/user/user.dart';

class UserTable {

  static const String createTable = '''
    CREATE TABLE ${User.tableName} (
      ${User.tableId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${User.colUsername} TEXT UNIQUE,
      ${User.colFullName} TEXT,
      ${User.colPassword} TEXT
    )
  ''';
}