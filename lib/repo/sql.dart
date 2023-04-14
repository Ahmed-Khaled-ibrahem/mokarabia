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

  Future<List<Map<String, dynamic>>> readNewData(String filter) async {
    try {
      // return await database.query(dataBaseName, where: '');
      // return await database.query(dataBaseName, distinct: true, columns: ['person']);
      // return await database.rawQuery("SELECT SUM(cost) as Total FROM $dataBaseName");
      // return await database.rawQuery("SELECT SUM(cost) as Total FROM $dataBaseName WHERE cap = 2");
      // return await database.rawQuery("SELECT SUM(cost) as Total FROM $dataBaseName WHERE cap = 2");
      return await database.rawQuery("SELECT SUM(cost) as Total FROM $dataBaseName WHERE payment = 'paid' AND person = 'ahmed khaled'");

    } catch (err) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSummary(String type,{String paidOrFree = '', String name = ''}) async {
    try {
      if(type == 'totalCost'){
        return await database.rawQuery("SELECT SUM(cost) as Total FROM $dataBaseName WHERE payment = '$paidOrFree'");
      }
      if(type == 'customers'){
        return await database.query(dataBaseName, distinct: true, columns: ['person']);
      }
      if(type == 'customerCost'){
        return await database.rawQuery("SELECT SUM(cost) as Total FROM $dataBaseName WHERE payment = '$paidOrFree' AND person = '$name'");
      }
      if(type == 'count'){
        return await database.query(dataBaseName, where: "person = '$name'");
      }


      return [];
    } catch (err) {
      return [];
    }
  }

}

