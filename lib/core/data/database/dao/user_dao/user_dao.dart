import 'package:notely/core/data/database/constants/user/user.dart';
import 'package:notely/core/data/database/helper/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  // Private constructor
  UserDao._();

  // Singleton
  static final UserDao instance = UserDao._();

  Future<Database> get db async => await DBHelper.instance.getDB();

  /// Performing crud operations

  // User registration
  Future<bool> register({
    required String fullName,
    required String username,
    required String password,
  }) async {
    final db = await UserDao.instance.db;
    final registerUser = await db.insert(User.tableName, {
      User.colFullName: fullName,
      User.colUsername: username,
      User.colPassword: password,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    return registerUser > 0;
  }

  // User login
  Future<List<Map<String, dynamic>>> loginUser({
    required String username,
    required String password,
  }) async {
    final db = await UserDao.instance.db;
    final loginUser = await db.query(
      User.tableName,
      where: '${User.colUsername} = ? AND ${User.colPassword} = ?',
      whereArgs: [username, password],
    );
    return loginUser;
  }

  // User login in based on username only
  Future<List<Map<String, dynamic>>> loginWithUsername({
    required String username,
  }) async {
    final db = await UserDao.instance.db;
    final loginUser = await db.query(
      User.tableName,
      where: '${User.colUsername} = ?',
      whereArgs: [username],
    );
    return loginUser;
  }

  // Updating password
  Future<bool> updatePassword({
    required String username,
    required String newPassword,
  }) async {
    final db = await UserDao.instance.db;
    int passwordUpdate = await db.update(
      User.tableName,
      {User.colPassword: newPassword},
      where: '${User.colUsername} = ?',
      whereArgs: [username],
    );
    return passwordUpdate > 0;
  }

  Future<bool> updateFullName({
    required String username,
    required newFullName,
  }) async {
    final db = await UserDao.instance.db;
    int fullNameChanged = await db.update(
      User.tableName,
      {User.colFullName: newFullName},
      where: '${User.colUsername} = ?',
      whereArgs: [username],
    );
    return fullNameChanged > 0;
  }

  // Getting fullName based on username
  Future<String?> getFullName({required String username}) async {
    final db = await UserDao.instance.db;
    List<Map<String, dynamic>> rowEffected = await db.query(
      User.tableName,
      where: '${User.colUsername} = ?',
      whereArgs: [username],
      columns: [User.colFullName],
    );
    return rowEffected.isNotEmpty
        ? rowEffected.first[User.colFullName] as String
        : null;
  }
}
