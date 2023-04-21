import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mokarabia/model/order.dart';
import 'package:mokarabia/model/order_sent_state.dart';
import 'package:mokarabia/model/product.dart';
import 'package:mokarabia/repo/sql.dart';
import '../repo/pref_helper.dart';
import 'app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  DatabaseReference ref = FirebaseDatabase.instance.ref();
  DataBaseRepository historyTable = DataBaseRepository()..init();
  late GlobalKey<ScaffoldMessengerState> scaffoldMessenger ;

  Order myOrder = Order(
    personName: PreferenceHelper.getDataFromSharedPreference(key: PreferenceKey.userName) ?? '',
    payment: PaymentType.paid,
    products: {
      Product.cappuccino:0,
      Product.espresso:0,
      Product.latte:0,
    },
  );

  String orderSentState = OrderSentState.notSent;
  String adminPass = 'ffdfhoa4g56hdgh';
  List activeOrders  = [];

  final String accessSecret = 'v>1.0.0';
  String accessSecretFirebase = '';

  void setState() {
    emit(AppSetState());
  }

  String allowAccess(){

    if(accessSecretFirebase == accessSecret){
      return 'allow';
    }
    if(accessSecretFirebase == ''){
      return 'noInternet';
    }
    else{
     return 'denied';
    }
  }

  Future<void> initialSetup(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {

    final snapshot = await ref.get();
    if (snapshot.exists) {
      allProducts[0].price = double.parse(snapshot.child('const/cap').value.toString());
      allProducts[1].price = double.parse(snapshot.child('const/esp').value.toString());
      allProducts[2].price = double.parse(snapshot.child('const/latte').value.toString());

      allProductsMap['latte']!.price = double.parse(snapshot.child('const/latte').value.toString());
      allProductsMap['esp']!.price = double.parse(snapshot.child('const/esp').value.toString());
      allProductsMap['cap']!.price = double.parse(snapshot.child('const/cap').value.toString());

      accessSecretFirebase = snapshot.child('const/access').value.toString();

    } else {}

    adminPass = await readPassword();
    readOrders();

    scaffoldMessenger = scaffoldMessengerKey;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if (message.notification != null) {

        String messageText ='New Order Arrived by ${message.data['name']} \nRefresh to see detail';

        scaffoldMessenger.currentState!.showSnackBar(
          SnackBar(
              content: Text(messageText),
            behavior: SnackBarBehavior.floating,
          ),
        );
        readOrders();
      }

    });

  }

  Future<void> sendOrder(context) async {
    if(myOrder.getCost().round()==0){
      Navigator.of(context).pop();
      showError(context, 'please select order first');
      return;
    }

    orderSentState = OrderSentState.loading;
    setState();

    myOrder.date = DateTime.now();

    await ref.child('${myOrder.personName}${myOrder.date.hour}:${myOrder.date.minute}:${myOrder.date.second}').set(
      myOrder.export()

    ).onError((error, stackTrace) => (){
      orderSentState = OrderSentState.notSent;
      showError(context, 'there is error happened');
      setState();
    }).

    whenComplete(() async {
      orderSentState = OrderSentState.sent;
      setState();

      historyTable.insertRow(myOrder.export());

      sendNotification(myOrder.personName);
      // var map = await historyTable.readData();

    }).

    timeout(const Duration(seconds: 5),onTimeout: (){
      showError(context, 'seems takes a lot of time \n please check your internet connection');
    });

  }

  void showError(context,message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<String> readPassword() async{

    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.child('const/pass').value.toString();
    } else {
      return 'Ahmedqqnfaffsdsa';
    }
  }

  Future<void> readOrders() async {

    final snapshot = await ref.get();
    if (snapshot.exists) {

      activeOrders = snapshot.children.toList();

      activeOrders.removeWhere((element) => element.key == 'const');

      activeOrders.forEach((element) {
        print(element.value);
      });

    } else {
      print('No data available.');
    }
    setState();
  }

  Future<void> removeOrder(index, String freeOrPaid) async {

    if(freeOrPaid != 'delete'){

      await ref.child(activeOrders[index].key.toString()).remove().
      whenComplete((){

        Order newOrder = Order(personName: activeOrders[index].value['person'],
            products: {
          Product.cappuccino : activeOrders[index].value['cap'],
          Product.espresso : activeOrders[index].value['esp'],
          Product.latte : activeOrders[index].value['latte'],
            },
            payment: freeOrPaid);

        historyTable.insertRow(newOrder.export());
        activeOrders.removeAt(index);

        setState();
      });
    }

    else{
      await ref.child(activeOrders[index].key.toString()).remove().
      whenComplete((){
        activeOrders.removeAt(index);
        setState();
      });
    }
  }

  Future<void> removeOrderClient(name) async {
    final snapshot = await ref.get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) async {
        if(element.key!.contains(myOrder.personName)){
          await ref.child(element.key!).remove().
          whenComplete((){
            setState();
          });
        }
      });
    } else {
    }
  }

  Future<void> testSQL() async {

    print ('************ all data ********');
    List<Map<String, dynamic>> allData = await historyTable.readData();
    allData.forEach((element) { print(element) ;});

    print ('************ data filtered ********');
    List<Map<String, dynamic>> data = await historyTable.readNewData('');
    data.forEach((element) { print(element) ;});

  }

  Future<List<Map<String, dynamic>>> readSummary(String type, {String paidOrFree='' ,String name=''}){
      return historyTable.getSummary(type, paidOrFree: paidOrFree, name: name);
  }

  Future<void> sendNotification(String name) async {

    const String serverKey = 'AAAA0D7H_XQ:APA91bGu2eXPk11JH9oMx-f-fpTgDCXwqsaNQq7lTqUOEmnQM0u2rDpF5RyJyAboQqoP2gqpQJNDwW0MnjTe-m1YXL2ivZtIu1WgOG17sy1whpRsD95OMM2u4WyHFqxOkvmKQlF4uRSE';
    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map<String, dynamic> body = {
      "data": {'name': name},
      // 'topic':'alert',
      "to": "/topics/alert",
      "notification": {
        "title": 'New Order by $name',
        "body": "open to see more detail",
        "sound": "default"},

      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      }
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    print(statusCode);
    print(responseBody);

  }

  Future<void> sendCancelation(String name) async {

    const String serverKey = 'AAAA0D7H_XQ:APA91bGu2eXPk11JH9oMx-f-fpTgDCXwqsaNQq7lTqUOEmnQM0u2rDpF5RyJyAboQqoP2gqpQJNDwW0MnjTe-m1YXL2ivZtIu1WgOG17sy1whpRsD95OMM2u4WyHFqxOkvmKQlF4uRSE';
    final uri = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map<String, dynamic> body = {
      "data": {'name': name},
      // 'topic':'alert',
      "to": "/topics/alert",
      "notification": {
        "title": '$name canceling the order',
        "body": "please delete the order",
        "sound": "default"},

      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      }
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    print(statusCode);
    print(responseBody);

  }

  Future<bool> checkCancelation() async {
    final snapshot = await ref.get();
    if (snapshot.exists) {
      bool exist = false;
      snapshot.children.forEach((element) {
        if(element.key!.contains(myOrder.personName)){
          exist = true;
        }
      });
      return exist;
    } else {
      return false;
    }
  }
}



