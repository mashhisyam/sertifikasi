import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'login_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
    );
  }

  Future<void> createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE pemasukan(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tanggal TEXT NOT NULL,
      nominal INTEGER NOT NULL,
      keterangan TEXT
    )
    ''');

    await db.insert('users', {'username': 'user', 'password': 'user'});
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert('users', user);
  }

  Future<int> insertPemasukan(Map<String, dynamic> pemasukan) async {
    Database db = await instance.database;
    return await db.insert('pemasukan', pemasukan);
  }

  Future<List<Map<String, dynamic>>> getPemasukan() async {
    Database db = await instance.database;
    return await db.query('pemasukan');
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }
}
