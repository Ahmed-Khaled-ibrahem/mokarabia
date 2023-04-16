import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/model/login_states.dart';
import 'package:mokarabia/repo/fire_message.dart';
import 'package:mokarabia/repo/firebase_options.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import 'package:mokarabia/repo/sql.dart';
import 'package:mokarabia/view/layout/admin/admin_home_screen.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
import 'package:mokarabia/view/layout/user/home_screen.dart';
import 'package:mokarabia/view/resources/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android
  );
  await PreferenceHelper.init();

  await FirebaseMessaging.instance.subscribeToTopic("alert");

  // await FirebaseMessaging.instance.unsubscribeFromTopic("alert");
  runApp( MyApp() );
}




class MyApp extends StatelessWidget {
   MyApp({super.key});

  String? loginState = PreferenceHelper.getDataFromSharedPreference(key: PreferenceKey.loginState);
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      create: (context) => AppCubit()..initialSetup(scaffoldMessengerKey),
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Mokarabia',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: loginState == LoginState.user?  HomeScreen():
              loginState == LoginState.admin? AdminHomeScreen():
              LoginScreen(),
      ),
    );
  }
}
