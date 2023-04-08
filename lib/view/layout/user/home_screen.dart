import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mokarabia/model/product.dart';
import 'package:mokarabia/view/layout/login/login_screen.dart';
import 'package:mokarabia/view/resources/componets/navigator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Wrap(
        //   children: const [
        //     Icon(Icons.coffee),
        //     SizedBox(width: 5,),
        //     Text("Mokarabia"),
        //   ],
        // ),
        centerTitle: true,
        toolbarHeight: 140,
        title: Image.asset('assets/images/logo.png',height: 140,),
        actions: [
          Column(
            children: [
              IconButton(onPressed: (){navigateReplacementTo(context, const LoginScreen());}, icon: const Icon(Icons.logout)),
            ],
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
                children: List.generate(3, (index) => Card(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox.square(
                                dimension: 150,
                                child: Image.asset(allProducts[index].image!,
                                fit: BoxFit.cover,),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: const [
                                Icon(Icons.circle,color: Colors.blue,size: 40,),
                                Text('10',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Positioned(
                              right: 0,
                                bottom: 0,
                                child: Card(
                                    color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text('${allProducts[index].price!.round()} LE',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                    ))),
                          ],
                        ),
                        Text(allProducts[index].name!,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                          IconButton(onPressed: (){}, icon: const Icon(Icons.add_circle,size: 40,color: Colors.green,), ),
                          IconButton(onPressed: (){}, icon: const Icon(Icons.remove_circle,color: Colors.deepOrange,), ),
                        ],),


                      ],
                    )
                ),
                ),
            ),
            ElevatedButton.icon(
                onPressed: (){},
                icon: const Icon(Icons.coffee),
                label: const Text("Make an order"))
          ],
        ),
      ),
    );
  }
}
