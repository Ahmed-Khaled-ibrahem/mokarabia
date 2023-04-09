import 'dart:async';
import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: darkMainColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/coffee-time2.zip',
              ),
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
              }, child: const Text("Are you Admin?"))
            ],
          ),
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
                              if (value != 'passWord') {
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
                        // Navigator.of(context).pop();

                        PreferenceHelper.putDataInSharedPreference(
                            value: LoginState.admin,
                            key: PreferenceKey.loginState);

                        navigateReplacementTo(context, AdminHomeScreen());

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Welcome to admin access')),
                        );
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
