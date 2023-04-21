import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';
import 'package:mokarabia/model/login_states.dart';
import 'package:mokarabia/model/order.dart';
import 'package:mokarabia/model/order_sent_state.dart';
import 'package:mokarabia/model/product.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
import 'package:mokarabia/view/layout/user/history_screen.dart';
import 'package:mokarabia/view/resources/componets/confirmation_dialog.dart';
import 'package:mokarabia/view/resources/componets/navigator.dart';
import 'package:mokarabia/view/resources/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                 style: ButtonStyle(
                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                       RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),
                           // side: BorderSide(color: Colors.red)
                       )),
                 ),
                      onPressed: () async {
                  makeOrderDialog(context);
                },
                icon: const Icon(Icons.coffee),
                label: const Text("Make an order")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // side: BorderSide(color: Colors.red)
                      )),
                ),
                onPressed: (){navigateTo(context, const HistoryScreen());},
                icon: const Icon(Icons.history),
                label: const Text("History")),
          )],),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 140,
        leading: Container(),
        title: Image.asset('assets/images/logo.png',height: 140,
        // color: AppColors.red,
        //     colorBlendMode: BlendMode.screen
        ),

        actions: [
          Column(
            children: [
              IconButton(
                  onPressed: (){
                showConfirmDialog(context,(){
                  Navigator.of(context).pop();
                  PreferenceHelper.putDataInSharedPreference(value: LoginState.none, key: PreferenceKey.loginState);
                  navigateReplacementTo(context,  LoginScreen());
                },'Logout','Are you sure that you want to Logout');

                },
                  icon: const Icon(Icons.logout)),
            ],
          )
        ],
      ),

      body: BlocBuilder<AppCubit, AppStates>(
  builder: (context, state) {
    AppCubit cubit = AppCubit.get(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to Exit?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: SingleChildScrollView(
          child: Center(
            child: Wrap(
                children: [...List.generate(3, (index) => Card(
                  color: Theme.of(context).colorScheme.onBackground,
                    child: InkWell(
                      onTap: (){
                        addCup(cubit,index);
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: SizedBox.square(
                                  dimension: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      allProducts[index].image!,
                                    fit: BoxFit.cover,),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: cubit.myOrder.products[allProducts[index].name] != 0,
                                child: InkWell(
                                  onTap: (){makeZero(cubit,index);},
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                       Container(
                                           decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(20),
                                           color: Theme.of(context).colorScheme.onBackground
                                         ),
                                           child: Icon(Icons.circle,color: Theme.of(context).colorScheme.background,size: 40,),

                                       ),
                                      Text(cubit.myOrder.products[allProducts[index].name].toString(),
                                        style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                  bottom: 0,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                                        child: Text('${allProducts[index].price!.round()} LE',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                      ))),
                            ],
                          ),
                          Text(allProducts[index].name!,
                            style: TextStyle(
                                color:Theme.of(context).colorScheme.background,
                                fontSize: 22,fontWeight: FontWeight.bold),),
                          RawMaterialButton(
                            // style: ButtonStyle(
                            //   fixedSize: MaterialStateProperty.all(const Size(20, 20)),
                            // ),
                            onPressed: (){
                              removeCup(cubit, index);
                              },

                            child: const Icon(Icons.remove_rounded,color: Colors.deepOrange,size: 40,),
                          ),
                        ],
                      ),
                    )
                ),
                ),

                  FutureBuilder<bool>(
                      future: cubit.checkCancelation(),
                      initialData: false,
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                        if(snapshot.hasData){
                          return Visibility(
                            visible: snapshot.data ?? false,
                            child: InkWell(
                              onTap: (){
                                showConfirmDialog(context,() async {
                                  Navigator.of(context).pop();
                                  cubit.sendCancelation(cubit.myOrder.personName);
                                  cubit.removeOrderClient(cubit.myOrder.personName);
                                },'Order Cancellation','Are you sure that you want to send cancellation notification');

                              },
                              child: Card(
                                color: Theme.of(context).colorScheme.onBackground,
                                child: SizedBox(
                                  width: 160,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cancel,size: 80,
                                          color: Theme.of(context).colorScheme.background,),
                                        Text('Click here if you want to send notification to cancel the order',
                                          style: TextStyle(
                                            color:Theme.of(context).colorScheme.background,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        else{
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })
                ]
            ),
          ),
        ),
    );
  },
),
    );
  }

  Future makeOrderDialog(context) async {
    final randomNumberGenerator = Random();
    final randomBoolean = randomNumberGenerator.nextBool();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BlocBuilder<AppCubit, AppStates>(
  builder: (context, state) {
    AppCubit cubit = AppCubit.get(context);
    return AlertDialog(
          title: cubit.orderSentState == OrderSentState.notSent? const Text('Review'):Container(),
          content: SizedBox(
            height: 250,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.bounceInOut,
              switchOutCurve: Curves.easeOutCirc,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: cubit.orderSentState == OrderSentState.sent?
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  randomBoolean?
                  Transform.scale(scale:7, child: Lottie.asset('assets/lottie/coffee.zip', height: 150)):
                  Transform.scale(scale:2.8, child: Lottie.asset('assets/lottie/coffee-time.zip',height: 200)),
                  const Text('Your order is sent successfully'),
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
                  :
              cubit.orderSentState == OrderSentState.notSent?
              SingleChildScrollView(
                child: Column(
                  children:  <Widget>[
                    const SizedBox(height: 10,),
                    Row(
                      children: const [
                        Text('Order:',style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    ...getListOrder(cubit.myOrder),
                    Row(
                      children: const [
                        Text('Cost:',style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Text("${cubit.myOrder.getCost().round().toString()} LE"),
                    const SizedBox(height: 30,),
                    TextButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        cubit.sendOrder(context);
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ):

                  Wrap(
                    runSpacing: 20,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    alignment: WrapAlignment.center,
                    children: const [
                    CircularProgressIndicator(),
                    Text('Loading')
                  ],),

            ),
          ),
        );
  },
);
      },
    );
  }

  void addCup(AppCubit cubit, int index){
    cubit.myOrder.products[allProducts[index].name!] = cubit.myOrder.products[allProducts[index].name!]! + 1;
    cubit.setState();
    cubit.orderSentState = OrderSentState.notSent;
}

  void removeCup(AppCubit cubit, int index){
  int val = cubit.myOrder.products[allProducts[index].name!]!;
    if(val>0){
      cubit.myOrder.products[allProducts[index].name!] = val - 1;
      cubit.setState();
      cubit.orderSentState = OrderSentState.notSent;
    }
  }

  void makeZero(AppCubit cubit, int index) {
    int val = cubit.myOrder.products[allProducts[index].name!]!;
    if(val>0){
      cubit.myOrder.products[allProducts[index].name!] = 0;
      cubit.setState();
      cubit.orderSentState = OrderSentState.notSent;
    }
  }

  List<Widget>getListOrder(Order myOrder){
    List<Widget> val = List.empty(growable: true);

    myOrder.products.forEach((key, value) {
      if(value != 0){
        val.add(Text('$value X  $key '));
      }
    });
    return val;
  }
}
