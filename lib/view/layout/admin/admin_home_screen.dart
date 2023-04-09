import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/view/layout/admin/active_orders.dart';
import 'package:mokarabia/view/layout/admin/history_screen.dart';
import 'package:mokarabia/view/layout/admin/summury_screen.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
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
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 140,
          title: Image.asset('assets/images/logo.png',height: 140,),
          actions: [
            Column(
              children: [
                IconButton(onPressed: (){navigateReplacementTo(context, LoginScreen());}, icon: const Icon(Icons.logout)),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.green
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                  backgroundColor: Colors.yellow
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blue,
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            iconSize: 40,
            onTap: (index){_selectedIndex = index;
              cubit.setState();},
            elevation: 5
        ),
        body: screens[_selectedIndex],
      );
    }));
  }
}