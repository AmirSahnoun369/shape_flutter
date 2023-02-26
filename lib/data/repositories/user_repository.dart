import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';

class UserRepository {
  static final UserRepository _userRepository = UserRepository._internal();

  late Database _db;

  UserRepository._internal();

  factory UserRepository(Type userProvider) {
    return _userRepository;
  }

  Future<void> init() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'user_database.db');
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE Users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT)',
      );
    });
  }

  Future<User> createUser(User user) async {
    await _db.insert('Users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return user;
  }

  Future<List<User>> getUsers() async {
    final List<Map<String, dynamic>> maps = await _db.query('Users');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        password: maps[i]['password'],
      );
    });
  }

  Future<void> addUser(User user) async {
    await _db.insert('Users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User> updateUser(User user) async {
    await _db
        .update('Users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    return user;
  }

  Future<void> deleteUser(int id) async {
    await _db.delete('Users', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<User>> getAllUsers() async {
    return await getUsers();
  }
}
