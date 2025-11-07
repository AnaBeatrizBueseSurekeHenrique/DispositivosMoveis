import 'package:apk_trabalho2/database/model/flower_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FlowerHelper {
  static final FlowerHelper _instace = FlowerHelper.internal();
  factory FlowerHelper() => _instace;
  FlowerHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "flowerDB.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute(
          "CREATE TABLE $flowerTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $scientificNameColumn TEXT, $pictureColumn TEXT, $priceColumn DOUBLE, $colorColumn TINYTEXT, $typeColumn CHAR, $meaningColumn TEXT)",
        );
      },
    );
  }

  Future<Flower> saveFlower(Flower flower) async {
    Database dbFlower = await db;
    flower.id = await dbFlower.insert(flowerTable, flower.toMap());
    return flower;
  }

  Future<Flower?> getFlower(int id) async {
    Database dbFlower = await db;
    List<Map<String, dynamic>> maps = await dbFlower.query(
      flowerTable,
      columns: [
        idColumn,
        nameColumn,
        scientificNameColumn,
        pictureColumn,
        priceColumn,
        colorColumn,
        typeColumn,
        meaningColumn,
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Flower.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Flower>> getAllFlowers() async {
    Database dbFlower = await db;
    List<Map<String, dynamic>> listMap = await dbFlower.query(flowerTable);
    List<Flower> listFlower = [];
    for (Map<String, dynamic> m in listMap) {
      listFlower.add(Flower.fromMap(m));
    }
    return listFlower;
  }

  Future<int> deleteFlower(int id) async {
    Database dbFlower = await db;
    return await dbFlower.delete(
      flowerTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateFlower(Flower flower) async {
    Database dbFlower = await db;
    return await dbFlower.update(
      flowerTable,
      flower.toMap(),
      where: "$idColumn = ?",
      whereArgs: [flower.id],
    );
  }
}
