import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';
import 'package:mokarabia/view/resources/theme/app_theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   cubit.sendNotification('ahmed k');
          // }),
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
                      child: FutureBuilder(
                        initialData: const [{'Total':'0'}],
                        future: cubit.readSummary('totalCost',paidOrFree: 'free'),
                        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
                          return Column(
                            children: [
                               Text('Free', style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                          ),),
                              Row(
                                children: [
                                  Text(
                                    (snapshot.data![0]['Total']??0).toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.background,
                                        fontSize: 45
                                    ),
                                  ),
                                   Text(
                                    'LE',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.background,
                                        fontSize: 20
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.lightBlueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          FutureBuilder(
                            initialData: const [{'Total':'0'}],
                            future: cubit.readSummary('totalCost',paidOrFree: 'paid'),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
                              return Column(
                                children:  [
                                   Text('Paid' ,style: TextStyle(
                                  color: Theme.of(context).colorScheme.background,
                              ),),
                                  Row(
                                    children:  [
                                      Text(
                                        (snapshot.data![0]['Total']??0).toString(),
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.background,
                                            fontSize: 45
                                        ),
                                      ),
                                      Text(
                                        'LE',
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.background,
                                            fontSize: 20
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
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
                child: FutureBuilder(
                  initialData: const [{'person':'user'}],
                  future: cubit.readSummary('customers'),
                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){

                    return ListView(
                      children: List.generate(snapshot.data!.length, (index) =>
                          ListTile(
                            title: Text(snapshot.data![index]['person']),
                            subtitle: Wrap(
                              children: [
                                const Text('Free : '),
                                FutureBuilder(
                                  initialData: const [{'person':'user'}],
                                  future: cubit.readSummary('customerCost',paidOrFree: 'free',name: snapshot.data![index]['person'].toString() ),
                                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot2){
                                    return Text((snapshot2.data![0]['Total']??0).toString());
                                  },
                                ),
                                const Text(' LE   Paid : '),
                                FutureBuilder(
                                  initialData: const [{'person':'user'}],
                                  future: cubit.readSummary('customerCost',paidOrFree: 'paid',name: snapshot.data![index]['person'].toString()),
                                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot3){
                                    return Text((snapshot3.data![0]['Total']??0).toString());
                                  },
                                ),
                                const Text(' LE'),
                              ],
                            ),
                            trailing: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children:  [
                              FutureBuilder(
                                initialData: const [{'person':'user'}],
                                future: cubit.readSummary('count',name: snapshot.data![index]['person'].toString()),
                                builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot4){
                                  return Text(snapshot4.data!.length.toString());
                                },
                              ),
                              const Icon(Icons.delivery_dining)
                            ],),
                            // leading: Text((index+1).toString()),
                          )),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
