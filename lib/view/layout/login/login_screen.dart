import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';
import 'package:mokarabia/model/login_states.dart';
import 'package:mokarabia/repo/pref_helper.dart';
import '../../resources/componets/navigator.dart';
import '../../resources/theme/app_theme.dart';
import '../admin/admin_home_screen.dart';
import '../user/home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _passFormKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController(
      text: PreferenceHelper.getDataFromSharedPreference(
          key: PreferenceKey.userName));

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.light?
      SystemUiOverlayStyle.dark:SystemUiOverlayStyle.light,

      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BlocBuilder<AppCubit, AppStates>(
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
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: const [
                        Text('Welcome to', style: TextStyle(fontSize: 14),),
                        Text('MOKARABIA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Transform.scale(
                      scale: Theme.of(context).brightness == Brightness.dark? 1:1.5,
                      child: Lottie.asset(Theme.of(context).brightness == Brightness.dark?
                      'assets/lottie/coffe-orange.zip':
                      'assets/lottie/coffee-time2.zip',
                        height: 300
                      ),
                    ),

                    const SizedBox(height: 15,),
                    Container(
                      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.3)),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                controller: userName,
                                onEditingComplete: () {
                                  PreferenceHelper.putDataInSharedPreference(
                                      value: userName.text, key: PreferenceKey.userName);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (value.length < 4) {
                                    return 'the name is too short';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person_pin_rounded),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  helperText: 'your name to be sent with the orders',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  PreferenceHelper.putDataInSharedPreference(
                                      value: userName.text, key: PreferenceKey.userName);
                                  PreferenceHelper.putDataInSharedPreference(
                                      value: LoginState.user,
                                      key: PreferenceKey.loginState);
                                  cubit.myOrder.personName = userName.text;

                                  navigateReplacementTo(context, HomeScreen());

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Welcome ${userName.text}')),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(const Size(250, 30)),
                                  elevation: MaterialStateProperty.all(7)),
                              child: const Text("Login")),
                          TextButton(onPressed: () {
                            adminLoginDialog(context);
                          }, child: const Text("Are you Admin?")),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      );
  },
),
      ),
    );
  }

  Future adminLoginDialog(context) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        bool obsecure = true;

        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              AppCubit cubit = AppCubit.get(context);
              return AlertDialog(
                title: const Text('Login as admin'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Form(
                          key: _passFormKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value != cubit.adminPass) {
                                return 'WRONG Password';
                              }
                              return null;
                            },
                            obscureText: obsecure,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: (){
                                    obsecure = !obsecure;
                                    cubit.setState();
                                  },
                                  child: obsecure? const Icon(Icons.visibility_off):const Icon(Icons.visibility)),
                              icon: const Icon(Icons.password),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Login'),
                    onPressed: () {
                      if (_passFormKey.currentState!.validate()) {

                        PreferenceHelper.putDataInSharedPreference(
                            value: LoginState.admin,
                            key: PreferenceKey.loginState);

                        navigateReplacementTo(context, AdminHomeScreen());

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Welcome to admin access')),
                        );

                        FirebaseMessaging.instance.subscribeToTopic("alert");

                      }

                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

}
