import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mokarabia/model/order.dart';
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


  void setState() {
    emit(AppSetState());
  }

  void initialSetup(){
    // DatabaseReference ref = FirebaseDatabase.instance.ref();
  }

  Future<void> sendOrder(context) async {



    // DateTime.now().millisecond.toString()
    // await ref.child('afterinternetback').set(
    //   'val'
    // ).onError((error, stackTrace) => (){ showError(context, 'error'); }).
    // whenComplete(() => print('*****************')).
    // timeout(const Duration(seconds: 2),onTimeout: (){ showError(context, 'error'); });
    //

  }

  void showError(context,message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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



