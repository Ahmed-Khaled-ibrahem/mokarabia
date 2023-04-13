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
                PRIMARY KEY("id" AUTOINCREMENT)
                );''');
        },
      );

  }

  static void dispose() async {
    database.delete(dataBaseName);
  }

  Future<List<Map<String, dynamic>>> readData() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(dataBaseName);
      return maps;
    } catch (err) {
      return [];
    }
  }

  void insertRow(Map<String, dynamic> data) {
    database.insert(dataBaseName, data);
  }



  void insertUpdate(Map<String, dynamic> data) {
    database.delete("history",
        where: "data like '%\"type\": \"update\"%' AND seen=0");
    database.insert("history", {"seen": 0, "data": data.toString()});
  }

  Future<List<Map<String, dynamic>>> readNewData() async {
    try {
      return await database.query("history", where: "seen = 0");
    } catch (err) {
      return [];
    }
  }

  void removeNotification(int id) {
    database.delete("history", where: "id=$id");
  }

  void updateUpdateSeen() {
    database.update("history", {"seen": 1},
        where: "data like '%\"type\": \"update\"%'");
  }
}

