import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseLocal {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initalDb();
      return _db;
    } else {
      return _db;
    }
  }

  initalDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'nara.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);

    return mydb;
  }

  /*_onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE "products" 
(
  "id_product" INTEGER NOT NULL,"id_product_type" INTEGER NOT NULL,"name_product" TEXT NOT NULL,"name_product_en" TEXT NOT NULL,"body_product_en" TEXT NOT NULL, 
  "body_product" TEXT NOT NULL,"price_product" INTEGER NOT NULL,"image_product" TexT NOT NULL,
)
''');


    print(
        "onCreate ====================================================================================");
  }*/
  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE "products" 
(
  "id_product" INTEGER  NOT NULL PRIMARY KEY , 
 "id_product_type" INTEGER  NOT NULL, "name_product" TEXT NOT NULL, "name_product_en" TEXT NOT NULL, "body_product_en" TEXT NOT NULL, "body_product" TEXT NOT NULL,
  "price_product" INTEGER  NOT NULL, "image_product" TEXT NOT NULL
)
''');

    print(
        "onCreate ==========================================================");

    await db.execute('''
CREATE TABLE "Celebs" 
(
  "id_celeb" INTEGER  NOT NULL PRIMARY KEY , 
 "name_celeb_ar" TEXT NOT NULL , "name_celeb_en" TEXT NOT NULL, 
   "image_celebrities" TEXT NOT NULL
)
''');

    print(
        "onCreate One==========================================================");
  }

  _onUpgrade(Database db, int oldversion, int newversion) {}
  readDataTypeOne() async {
    Database? mydb = await db;

    List<Map> response = await mydb!.rawQuery('''
SELECT * FROM "products" order by  id_product desc
''');

    return response;
  }

  readDataCelebs() async {
    Database? mydb = await db;

    List<Map> response = await mydb!.rawQuery('''
SELECT * FROM "Celebs" 
''');

    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawInsert(sql);

    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;

    int response = await mydb!.rawDelete(sql);

    return response;
  }
}
