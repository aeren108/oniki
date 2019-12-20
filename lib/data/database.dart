import 'package:oniki/model/item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ItemDatabase {
  static final ItemDatabase _instance = ItemDatabase._();
  Database _database;

  ItemDatabase._();

  factory ItemDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    String dbPath = join(await getDatabasesPath(), 'itemdatabase.db');
    Database database = await openDatabase(dbPath, version: 1, onCreate: _onCreate);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        insta TEXT,
        rate INTEGER,
        rate_type TEXT)
      ''');
  }

  Future<List<Item>> fetchItems() async {
    var client = await db;
    var res = await client.query('items'); //returns List<Map<String, dynamic>>

    if (res.length > 0) {
      var items = res.map((item) => Item.fromMap(item)).toList();
      return items;
    }
    return [];
  }

  Future<void> createItem(Item i) async {
    Database client = await db;
    await client.insert('items', i.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Item> readItem(int id) async {
    final client = await db;

    final List<Map<String, dynamic>> maps = await client.query('items', where: 'id = ?', whereArgs: [id]);

    if (maps.length > 0)
      return Item.fromMap(maps.first);
    return null;
  }

  Future<void> updateItem(Item i) async {
    final client = await db;
    await client.update('items', i.toMap(), where: 'id = ?', whereArgs: [i.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteItem(int id) async {
    final client = await db;
    return await client.delete('items', where: 'id = ?', whereArgs: [id]);
  }


}