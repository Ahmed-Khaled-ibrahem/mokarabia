import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';
import 'package:mokarabia/model/login_states.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import 'package:mokarabia/view/layout/admin/admin_home_screen.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
import 'package:mokarabia/view/layout/user/home_screen.dart';

class AccessScreen extends StatelessWidget {
  AccessScreen({Key? key}) : super(key: key);

  String? loginState = PreferenceHelper.getDataFromSharedPreference(
      key: PreferenceKey.loginState);
  String? themeState = PreferenceHelper.getDataFromSharedPreference(
      key: PreferenceKey.theme) ?? 'dark';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        print('----------------------');
        print("Current state is $state");

        AppCubit cubit = AppCubit.get(context);
        String access = cubit.allowAccess();

        return access == 'allow' ?   application() :
        access == 'noInternet'? noInternet() :
        accessDenied(context);
      },
    );
  }

  Widget application(){
    return loginState == LoginState.user ? const HomeScreen() :
    loginState == LoginState.admin ? AdminHomeScreen() :
    LoginScreen();
  }

  Widget accessDenied(context){
    return Scaffold(
      bottomNavigationBar:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('MOKARABIA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Access Denied', style: TextStyle(fontSize: 20),),
                Transform.scale(
                  scale: 2,
                  child: Lottie.asset('assets/lottie/access.zip',
                      height: 300
                  ),
                ),
                Column(
                  children: const [
                    Text('Sorry', style: TextStyle(fontSize: 40),),
                    Text('Please update the app', style: TextStyle(fontSize: 20),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noInternet(){
    return Scaffold(
      bottomNavigationBar:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('MOKARABIA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const Text('Internet Connection', style: TextStyle(fontSize: 20),),
                Transform.scale(
                  scale: 1,
                  child: Lottie.asset('assets/lottie/walking-for-wifi.json',
                      height: 300
                  ),
                ),
                Column(
                  children: const [
                    Text('Connecting ...', style: TextStyle(fontSize: 30),),
                    Text('Make sure you have Network connection', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
