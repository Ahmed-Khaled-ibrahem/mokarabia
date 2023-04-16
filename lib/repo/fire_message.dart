import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';


class FireNotificationHelper {

  FireNotificationHelper() {
    // print('')
    FirebaseMessaging.instance.subscribeToTopic("alert").catchError((err) {});

    FirebaseMessaging.onMessage
        .listen(_firebaseMessagingForegroundHandler)
        .onError((err) {});

    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler)
        .onError((err) {});

    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundCloseHandler);
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    // Vibrate.vibrate();
    redirectPage(message.data);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    redirectPage(message.data);
  }

  Future<void> redirectPage(Map<String, dynamic> data) async {
    // cubit("Notification come", type: ToastType.info);

    // DataBaseRepository dataBaseRepository = DataBaseRepository();

    if (data['"type"'] == '"update"') {
      // dataBaseRepository.insertUpdate(data);
      // navigateAndPush(
      //     navigatorKey.currentState!.context, const UpdateScreen(true));
    } else {
      // dataBaseRepository.insertNotification(data);
      // _callback(data);
    }
  }
}

Future<void> _firebaseMessagingBackgroundCloseHandler(RemoteMessage message) async {
  // Database database = await openDatabase(
  //   "notifications.db",
  //   version: 1,
  //   onCreate: (Database db, int version) async {
  //     // When creating the db, create the table
  //     await db.execute('''CREATE TABLE "notification" (
  //                     "id"	INTEGER,
  //                     "seen"	INTEGER,
  //                 "data"	TEXT,
  //               PRIMARY KEY("id" AUTOINCREMENT)
  //               );''');
  //   },
  // );

  if (message.data['"type"'] == '"update"') {
    // database.delete("notification",
    //     where: "data like '%\"type\": \"update\"%' AND seen=0");
  }
  // database.insert("notification", {"seen": 0, "data": message.data.toString()});
}
