import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History'),
      actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
      ],),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
        Icon(Icons.no_backpack),
        Text('Empty History')
      ],)),
    );
  }
}
