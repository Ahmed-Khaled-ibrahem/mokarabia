// import 'package:sqflite/sqflite.dart';
//
// class DataBaseRepository {
//   static late Database database;
//
//   static Future<DataBaseInfo> init() async {
//     try {
//       database = await openDatabase(
//         "notifications.db",
//         version: 1,
//         onCreate: (Database db, int version) async {
//           await db.execute('''CREATE TABLE "notification" (
//                       "id"	INTEGER,
//                       "seen"	INTEGER,
//                       "data"	TEXT,
//                 PRIMARY KEY("id" AUTOINCREMENT)
//                 );''');
//         },
//       );
//
//       bool newNotification =
//           (await database.query("notification", where: "seen=0")).isNotEmpty;
//       bool newUpdate = (await database.query("notification",
//               where: "data like '%\"type\": \"update\"%' and seen=0"))
//           .isNotEmpty;
//       return DataBaseInfo(newNotification, newUpdate);
//     } catch (err) {
//       return DataBaseInfo(false, false);
//     }
//   }
//
//   static void dispose() async {
//     database.delete("notification");
//   }
//
//   void insertUpdate(Map<String, dynamic> data) {
//     database.delete("notification",
//         where: "data like '%\"type\": \"update\"%' AND seen=0");
//     database.insert("notification", {"seen": 0, "data": data.toString()});
//   }
//
//   void insertNotification(Map<String, dynamic> data) {
//     database.insert("notification", {"seen": 0, "data": data.toString()});
//   }
//
//   Future<List<Map<String, dynamic>>> readData() async {
//     try {
//       return await database.query("notification");
//     } catch (err) {
//       return [];
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> readNewData() async {
//     try {
//       return await database.query("notification", where: "seen = 0");
//     } catch (err) {
//       return [];
//     }
//   }
//
//   void removeNotification(int id) {
//     database.delete("notification", where: "id=$id");
//   }
//
//   Future<void> removeAll() async {
//     await database.delete("notification",
//         where: "data NOT like '%\"type\":\"update\"%' AND seen=1");
//   }
//
//   void updateSeen(int id) {
//     database.update("notification", {"seen": 1}, where: "id=$id");
//   }
//
//   void updateUpdateSeen() {
//     database.update("notification", {"seen": 1},
//         where: "data like '%\"type\": \"update\"%'");
//   }
// }
//
// class DataBaseInfo {
//   bool newNotification;
//   bool newUpdate;
//   DataBaseInfo(this.newNotification, this.newUpdate);
// }
