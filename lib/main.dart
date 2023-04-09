import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/model/login_states.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import 'package:mokarabia/view/layout/admin/admin_home_screen.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
import 'package:mokarabia/view/layout/user/home_screen.dart';
import 'package:mokarabia/view/resources/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  await PreferenceHelper.init();
  // DataBaseInfo info = await DataBaseRepository.init();

  runApp( MyApp() );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  String? loginState = PreferenceHelper.getDataFromSharedPreference(key: PreferenceKey.loginState);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp(
        title: 'Mokarabia',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: loginState == LoginState.user? const HomeScreen():
              loginState == LoginState.admin? AdminHomeScreen():
              LoginScreen(),
      ),
    );
  }
}
