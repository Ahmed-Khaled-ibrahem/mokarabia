import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/repo/firebase_options.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import 'package:mokarabia/view/layout/acess_page/acess_screen.dart';
import 'package:mokarabia/view/resources/theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android
  );
  await PreferenceHelper.init();

  // await FirebaseMessaging.instance.subscribeToTopic("alert");
  // await FirebaseMessaging.instance.unsubscribeFromTopic("alert");
  FirebaseMessaging.instance.getToken();

  runApp( MyApp() );
}


class MyApp extends StatelessWidget {
   MyApp({super.key});

   final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => AppCubit()..initialSetup(scaffoldMessengerKey),

      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Mokarabia',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: AccessScreen(),
      ),
    );
  }
}
