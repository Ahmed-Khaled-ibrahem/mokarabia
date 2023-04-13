import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';

class ActiveOrdersScreen extends StatelessWidget {
  const ActiveOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        List snapshot = cubit.activeOrders;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              label: const Text('refresh'),
              icon: const Icon(Icons.refresh),
              onPressed: (){
                cubit.readOrders();
              }),
          body: ListView(
            children: List.generate(snapshot.length, (index) {
              List date = snapshot[index]
                  .value['orderdate']
                  .toString()
                  .replaceAll(' ', 'Q')
                  .replaceAll('.', 'Q')
                  .split('Q');

              return Slidable(
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (val) {
                        cubit.removeOrder(index, 'paid');
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.monetization_on_rounded,
                      label: 'Paid',
                    ),
                    SlidableAction(
                      onPressed: (val) {
                        cubit.removeOrder(index, 'free');
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.free_breakfast,
                      label: 'Free',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 2,
                      onPressed: (val) {
                        cubit.removeOrder(index, 'delete');
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete_rounded,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Text('${date[0]} \n'
                      '${date[1]} \n'),
                  trailing: Text('${snapshot[index].value['cost']} LE'),
                  subtitle: Text('by ${snapshot[index].value['person']}'),
                  title: Text(getText(snapshot, index)),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  String getText(snapshot, index) {
    String val = '';

    if (snapshot[index].value['cap'] != 0) {
      val = '$val${snapshot[index].value['cap']}xCappuccino  ';
    }
    if (snapshot[index].value['latte'] != 0) {
      val = '$val${snapshot[index].value['latte']}xLatte  ';
    }
    if (snapshot[index].value['esp'] != 0) {
      val = '$val${snapshot[index].value['esp']}xEspresso  ';
    }

    if (val == '') {
      val = 'no order';
    }
    return val;
  }
}
