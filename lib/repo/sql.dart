import 'package:sqflite/sqflite.dart';

class DataBaseRepository {
  static late Database database;

   void init() async {

      database = await openDatabase(
        "history.db",
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''CREATE TABLE history (
                      "id"	INTEGER,
                      "cap"	INTEGER,
                      "esp"	INTEGER,
                      "latte"	INTEGER,
                      "payment"	TEXT,
                      "orderdate" TEXT,
                      "personname" TEXT,
                PRIMARY KEY("id" AUTOINCREMENT)
                );''');
        },
      );

      // bool newNotification =
      //     (await database.query("history", where: "seen=0")).isNotEmpty;
      // bool newUpdate = (await database.query("history",
      //         where: "data like '%\"type\": \"update\"%' and seen=0"))
      //     .isNotEmpty;
      

  }

  static void dispose() async {
    database.delete("history");
  }

  void insertUpdate(Map<String, dynamic> data) {
    database.delete("history",
        where: "data like '%\"type\": \"update\"%' AND seen=0");
    database.insert("history", {"seen": 0, "data": data.toString()});
  }

  void insertRow(Map<String, dynamic> data) {
    database.insert("history", {
      "personname":"ahmed",
      // "orderdate":"date.toString()",
      "payment":"payment",
      "cap":5,
      "latte":6,
      "esp":1,
    });
  }

  Future<List<Map<String, dynamic>>> readData() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query("history");
      return maps;
    } catch (err) {
      return [];
    }
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

  Future<void> removeAll() async {
    await database.delete("history",
        where: "data NOT like '%\"type\":\"update\"%' AND seen=1");
  }

  void updateSeen(int id) {
    database.update("history", {"seen": 1}, where: "id=$id");
  }

  void updateUpdateSeen() {
    database.update("history", {"seen": 1},
        where: "data like '%\"type\": \"update\"%'");
  }
}

