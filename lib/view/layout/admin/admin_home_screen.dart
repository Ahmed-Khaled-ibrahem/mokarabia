import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/model/login_states.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import 'package:mokarabia/view/layout/admin/active_orders.dart';
import 'package:mokarabia/view/layout/admin/history_screen.dart';
import 'package:mokarabia/view/layout/admin/summury_screen.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
import 'package:mokarabia/view/resources/componets/confirmation_dialog.dart';
import 'package:mokarabia/view/resources/componets/navigator.dart';
import '../../../cubit/app_cubit.dart';
import '../../../cubit/app_states.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({Key? key}) : super(key: key);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    const List<Widget> screens = <Widget>[
      ActiveOrdersScreen(),AdminHistoryScreen(),SummaryScreen(),
    ];

    return  BlocBuilder<AppCubit, AppStates>(builder: ((context, state) {
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
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            toolbarHeight: 140,
            title: Image.asset('assets/images/logo.png',height: 140,),
            actions: [
              Column(
                children: [
                  IconButton(onPressed: (){

                    showConfirmDialog(context,(){

                      Navigator.of(context).pop();
                      PreferenceHelper.putDataInSharedPreference(value: LoginState.none, key: PreferenceKey.loginState);
                      navigateReplacementTo(context, LoginScreen());
                      FirebaseMessaging.instance.unsubscribeFromTopic("alert");

                    },'Logout','Are you sure that you want to Logout');

                    }, icon: const Icon(Icons.logout)),
                ],
              )
            ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          //     useLegacyColorScheme: true,
          //     items: const <BottomNavigationBarItem>[
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.coffee),
          //           label: 'Active Orders',
          //           backgroundColor: Colors.green
          //       ),
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.table_rows_rounded),
          //           label: 'History',
          //           backgroundColor: Colors.yellow
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.attach_money),
          //         label: 'Summary',
          //         backgroundColor: Colors.blue,
          //       ),
          //     ],
          //     type: BottomNavigationBarType.shifting,
          //     currentIndex: _selectedIndex,
          //     selectedItemColor: Colors.black,
          //     iconSize: 40,
          //     onTap: (index){
          //     _selectedIndex = index;
          //       cubit.setState();
          //       },
          //     elevation: 5
          // ),
          bottomNavigationBar: FlashyTabBar(
            selectedIndex: _selectedIndex,
            showElevation: false,
            iconSize: 30,
            animationDuration: const Duration(milliseconds: 800),
            onItemSelected: (index) {
              _selectedIndex = index;
              cubit.setState();
            },
            items: [
              FlashyTabBarItem(
                icon:  Icon(Icons.coffee,color: Theme.of(context).colorScheme.onBackground,),
                title: const Text('Active Orders'),
                activeColor: Theme.of(context).colorScheme.onBackground,
                inactiveColor: Theme.of(context).colorScheme.onBackground,
              ),
              FlashyTabBarItem(
                icon:  Icon(Icons.table_rows_rounded,color: Theme.of(context).colorScheme.onBackground),
                title: const Text('History'),
                activeColor: Theme.of(context).colorScheme.onBackground,
                inactiveColor: Theme.of(context).colorScheme.onBackground,
              ),
              FlashyTabBarItem(
                icon:  Icon(Icons.attach_money,color: Theme.of(context).colorScheme.onBackground),
                title: const Text('Summary'),
                activeColor: Theme.of(context).colorScheme.onBackground,
                inactiveColor: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
          body: screens[_selectedIndex],
        ),
      );
    }));
  }
}
