import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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

  Order myOrder = Order(
    personName: PreferenceHelper.getDataFromSharedPreference(key: PreferenceKey.userName),
    payment: PaymentType.paid,
    products: {
      Product.cappuccino:0,
      Product.espresso:0,
      Product.latte:0,
    },
  );

  String orderSentState = OrderSentState.notSent;
  String adminPass = 'ffdfhoa4g56hdgh';


  void setState() {
    emit(AppSetState());
  }

  Future<void> initialSetup() async {

    final snapshot = await ref.get();
    if (snapshot.exists) {
      allProducts[0].price = double.parse(snapshot.child('const/cap').value.toString());
      allProducts[1].price = double.parse(snapshot.child('const/esp').value.toString());
      allProducts[2].price = double.parse(snapshot.child('const/latte').value.toString());

      allProductsMap['latte']!.price = double.parse(snapshot.child('const/latte').value.toString());
      allProductsMap['esp']!.price = double.parse(snapshot.child('const/esp').value.toString());
      allProductsMap['cap']!.price = double.parse(snapshot.child('const/cap').value.toString());

    } else {}

    adminPass = await readPassword();
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
      print( snapshot.value );
      snapshot.children;

    } else {
      print('No data available.');
    }


  }

  void readTable() async {
    // DataBaseRepository.dispose();

    historyTable.insertRow(myOrder.export());

    var map = await historyTable.readData();
    print(map);
    print(map.length);
  }

}



