import 'package:flutter/material.dart';
import 'Screens/Notas_list.dart';

void main() {
  runApp(NotasApp());
}

class NotasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Notaslist(),
    );
  }
}
