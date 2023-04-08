import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../resources/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
        appBar: AppBar(
          backgroundColor: darkMainColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/coffee-time2.zip',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  // cursorColor: Theme.of(context).cursorColor,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_pin_rounded),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Color(0xFF6200EE),
                    ),
                    helperText: 'your name to be sent with the orders',
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){},
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(250, 30)),
                      elevation: MaterialStateProperty.all(7)),
                  child: const Text("Login")),
              TextButton(onPressed: (){}, child: const Text("Are you Admin?"))
            ],
          ),
        ),
      ),
    );
  }
}
