import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pet_app/model/adoption_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'pet_adoption.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE simple_adoptions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            gender TEXT,
            petCount INTEGER,
            petName TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE adoptions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            petName TEXT,
            petImage TEXT,
            ownerName TEXT,
            adopterName TEXT,
            phone TEXT,
            address TEXT,
            reason TEXT,
            adoptionDate TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            petName TEXT,
            petImage TEXT,
            userName TEXT,
            isFriendly INTEGER,
            category TEXT,
            adopted INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  static Future<void> insertAdoption(Adoption adoption) async {
    final dbClient = await db;
    await dbClient.insert('simple_adoptions', adoption.toMap());
  }

  static Future<void> insertDetailedAdoption(Map<String, dynamic> data) async {
    final dbClient = await db;
    await dbClient.insert('adoptions', data);
  }

  static Future<void> markPetAdopted(int petId) async {
    final dbClient = await db;
    await dbClient.update(
      'pets',
      {'adopted': 1},
      where: 'id = ?',
      whereArgs: [petId],
    );
  }

  static Future<List<Map<String, dynamic>>> getAdoptions() async {
    final dbClient = await db;
    return await dbClient.query('adoptions', orderBy: 'adoptionDate DESC');
  }

  static Future<List<Map<String, dynamic>>> getSimpleAdoptions() async {
    final dbClient = await db;
    return await dbClient.query('simple_adoptions');
  }

  static Future<void> deleteAdoption(int id) async {
    final dbClient = await db;
    await dbClient.delete('adoptions', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteSimpleAdoption(int id) async {
    final dbClient = await db;
    await dbClient.delete('simple_adoptions', where: 'id = ?', whereArgs: [id]);
  }
}
