import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokarabia/cubit/app_cubit.dart';
import 'package:mokarabia/cubit/app_states.dart';
import 'package:mokarabia/repo/sql.dart';
import 'package:mokarabia/view/resources/componets/confirmation_dialog.dart';
import '../../../model/product.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
  builder: (context, state) {
    AppCubit cubit = AppCubit.get(context);
    return Scaffold(
      appBar: AppBar(title: const Text('History'),
        actions: [
          IconButton(onPressed: () {
            deleteAllHistory(cubit, context);
          }, icon: const Icon(Icons.delete))
        ],),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: cubit.historyTable.readData(),
          builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isEmpty){
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.table_rows_rounded, size: 100,),
                        Text('Empty History')
                      ],));
              }
              return ListView(
                children: List.generate(snapshot.data!.length,
                        (index) {
                      List date = snapshot.data![index]['orderdate'].
                      toString().replaceAll(' ', 'Q').replaceAll('.', 'Q').split('Q');

                      return ListTile(
                        leading: Text(
                            '${date[0]} \n'
                                '${date[1]} \n'
                        ),
                        trailing: Text('${snapshot.data![index]['cost']} LE'),
                        subtitle: Text('by ${snapshot.data![index]['person']}'),
                        title: Text(getText(snapshot, index)),);
                    }),
              );
            }
            else{
              return const Center(
                  child: CircularProgressIndicator());
            }
          }),
    );
  },
);
  }

  void deleteAllHistory(AppCubit cubit, context) {

    showConfirmDialog(context,(){
      Navigator.of(context).pop();
      DataBaseRepository.dispose();
      cubit.setState();
    },'Delete Confirmation','Are you sure that you want to delete all history');

  }

  String getText(snapshot, index) {
    String val = '';

    if(snapshot.data![index]['cap'] != 0){
      val = '$val${snapshot.data![index]['cap']}xCappuccino  ';
    }
    if(snapshot.data![index]['latte'] != 0){
      val = '$val${snapshot.data![index]['latte']}xLatte  ';
    }
    if(snapshot.data![index]['esp'] != 0){
      val = '$val${snapshot.data![index]['esp']}xEspresso  ';
    }

    if(val == ''){val = 'no order';}
    return val;
  }

  String getCost(snapshot, index) {
    double val = snapshot.data![index]['cap'] * allProductsMap['cap']!.price!+
            snapshot.data![index]['esp'] * allProductsMap['esp']!.price!+
            snapshot.data![index]['latte'] * allProductsMap['latte']!.price!;
    return '${val.round()} LE';
  }

}


