import 'package:flutter/material.dart';

navigateTo(context,screen){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

navigateReplacementTo(context,screen){
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}