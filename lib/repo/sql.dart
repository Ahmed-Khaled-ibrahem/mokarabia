import 'package:sqflite/sqflite.dart';

class DataBaseRepository {
  static late Database database;
  static String dataBaseName = 'historyBase';

   void init() async {

      database = await openDatabase(
        "$dataBaseName.db",
        version: 5,
        onCreate: (Database db, int version) async {
          await db.execute('''CREATE TABLE $dataBaseName (
                      "id"	INTEGER, 
                      "cap"	INTEGER, 
                      "esp"	INTEGER, 
                      "latte"	INTEGER, 
                      "payment"	TEXT, 
                      "orderdate" TEXT, 
                      "person" TEXT, 
                      "cost" INTEGER, 
                PRIMARY KEY("id" AUTOINCREMENT)
                );''');
        },
      );

  }

  static void dispose() async {
    database.delete(dataBaseName);
    // databaseFactory.deleteDatabase('$dataBaseName.db');
  }

  Future<List<Map<String, dynamic>>> readData() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(dataBaseName);
      return maps.reversed.toList();
    } catch (err) {
      return [];
    }
  }

  void insertRow(Map<String, dynamic> data) {
    database.insert(dataBaseName, data);
  }



  Future<List<Map<String, dynamic>>> readNewData(filter) async {
    try {
      return await database.query("history", where: "seen = 0");
    } catch (err) {
      return [];
    }
  }

}

