import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';

class UserProvider {
  static const String _usersTable = 'Users';
  static const String _databaseName = 'users.db';
  static const int _databaseVersion = 1;

  late Database _database;

  Future<void> open() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_usersTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> close() async => _database.close();

  Future<void> addUser(User user) async {
    await _database.insert(_usersTable, user.toMap());
  }

  Future<void> updateUser(User user) async {
    await _database.update(
      _usersTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    await _database.delete(
      _usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<User>> getUsers() async {
    final List<Map<String, dynamic>> maps = await _database.query(_usersTable);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        password: maps[i]['password'],
      );
    });
  }
}
