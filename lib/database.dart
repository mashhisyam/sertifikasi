import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  static const int _databaseVersion = 4; // Ganti versi ke 3/final

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(),
        'sertifikasi.db');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pemasukan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        nominal INTEGER NOT NULL,
        keterangan TEXT
      )
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
  // if (oldVersion < 2) {
  //   await db.execute('''
  //     CREATE TABLE pengeluaran(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       tanggal TEXT NOT NULL,
  //       nominal INTEGER NOT NULL,
  //       keterangan TEXT
  //     ) 
  //   ''');
  // }

  // if (oldVersion < 4) {
  //   await db.execute('''
  //     CREATE TABLE users(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       username TEXT NOT NULL,
  //       password TEXT NOT NULL
  //     )
  //   ''');
    // Insert data pengguna default jika diperlukan
    // await db.insert('users', {'username': 'user', 'password': 'user'});
  // }
}
  

  Future<int> insertPemasukan(Map<String, dynamic> pemasukan) async {
    Database db = await instance.database;
    return await db.insert('pemasukan', pemasukan);
  }

  Future<List<Map<String, dynamic>>> getPemasukan() async {
    Database db = await instance.database;
    return await db.query('pemasukan');
  }

  Future<int> insertPengeluaran(Map<String, dynamic> pengeluaran) async {
    Database db = await instance.database;
    return await db.insert('pengeluaran', pengeluaran);
  }

  Future<List<Map<String, dynamic>>> getPengeluaran() async {
    Database db = await instance.database;
    return await db.query('pengeluaran');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert('users', user);
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

  Future<int> updateUser(String username, String newPassword) async {
    Database db = await instance.database;
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}
