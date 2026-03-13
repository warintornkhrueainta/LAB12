import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('community_shop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT
      )
    ''');

    await db.insert('products', {
      'name': 'ข้าวหอมมะลิ (1 กก.)',
      'price': 50.0,
      'description': 'ข้าวปลูกเอง ปลอดสารพิษ',
    });
    await db.insert('products', {
      'name': 'ไข่เป็ดอารมณ์ดี (10 ฟอง)',
      'price': 45.0,
      'description': 'ไข่สดใหม่จากฟาร์มชุมชน',
    });
    await db.insert('products', {
      'name': 'น้ำพริกตาแดง',
      'price': 35.0,
      'description': 'สูตรคุณยาย รสชาติจัดจ้าน',
    });
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((json) => Product.fromMap(json)).toList();
  }

  // --- 1. ฟังก์ชันเพิ่มสินค้า (Create) ---
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  // --- 2. ฟังก์ชันแก้ไขสินค้า (Update) ---
  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // --- 3. ฟังก์ชันลบสินค้า (Delete) ---
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
