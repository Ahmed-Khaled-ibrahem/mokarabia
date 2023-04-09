import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';
import 'package:mokarabia/model/login_states.dart';
import 'package:mokarabia/model/product.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
import 'package:mokarabia/view/layout/user/history_screen.dart';
import 'package:mokarabia/view/resources/componets/navigator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 140,
        title: Image.asset('assets/images/logo.png',height: 140,),
        actions: [
          Column(
            children: [
              IconButton(onPressed: (){
                PreferenceHelper.putDataInSharedPreference(value: LoginState.none, key: PreferenceKey.loginState);
                navigateReplacementTo(context,  LoginScreen());
                },
                  icon: const Icon(Icons.logout)),
            ],
          )
        ],
      ),

      body: BlocBuilder<AppCubit, AppStates>(
  builder: (context, state) {
    AppCubit cubit = AppCubit.get(context);
    return SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
                children: List.generate(3, (index) => Card(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox.square(
                                dimension: 150,
                                child: Image.asset(allProducts[index].image!,
                                fit: BoxFit.cover,),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: const [
                                Icon(Icons.circle,color: Colors.blue,size: 40,),
                                Text('10',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Positioned(
                              right: 0,
                                bottom: 0,
                                child: Card(
                                    color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text('${allProducts[index].price!.round()} LE',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                    ))),
                          ],
                        ),
                        Text(allProducts[index].name!,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                          IconButton(onPressed: (){}, icon: const Icon(Icons.add_circle,size: 40,color: Colors.green,), ),
                          IconButton(onPressed: (){}, icon: const Icon(Icons.remove_circle,color: Colors.deepOrange,), ),
                        ],),


                      ],
                    )
                ),
                ),
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [ ElevatedButton.icon(
               onPressed: () async {
                 // cubit.sendOrder(context);

                 cubit.readTable();



                 // makeOrderDialog(context);
                 },
               icon: const Icon(Icons.coffee),
               label: const Text("Make an order")),
             ElevatedButton.icon(
                 onPressed: (){navigateTo(context, const HistoryScreen());},
                 icon: const Icon(Icons.history),
                 label: const Text("History"))],)
          ],
        ),
      );
  },
),
    );
  }

  Future makeOrderDialog(context) async {
    bool done= true;
    final randomNumberGenerator = Random();
    final randomBoolean = randomNumberGenerator.nextBool();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: done? null:const Text('Review'),
          content: AnimatedSwitcher(
            duration: const Duration(seconds: 3),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: false? Wrap(
              alignment: WrapAlignment.center,
              children: [
                randomBoolean?
                Transform.scale(scale:5, child: Lottie.asset('assets/lottie/coffee.zip')):
                Transform.scale(scale:2, child: Lottie.asset('assets/lottie/coffee-time.zip')),
                const Text('Your order is sent successfully'),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ) : SingleChildScrollView(
              child: Column(
                children:  <Widget>[


                  TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



}
