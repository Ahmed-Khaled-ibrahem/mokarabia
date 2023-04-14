import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () {

          }),
          body: Column(
            children: [
              Row(
                children: const [
                  SizedBox(width: 10,),
                  Text('Total Money collected', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Text('Free'),
                          Row(
                            children: [
                              Text(
                                '50',
                                style: TextStyle(fontSize: 45),
                              ),
                              Text(
                                'LE',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children:  [
                          Text('Paid'),
                          Row(
                            children: [
                              Text(
                                '4050',
                                style: TextStyle(fontSize: 45),
                              ),
                              Text(
                                'LE',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: const [
                  SizedBox(width: 10,),
                  Text('Customer insights', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [

                ],),
              )
            ],
          ),
        );
      },
    );
  }
}
