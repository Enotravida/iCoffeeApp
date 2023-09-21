import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_path_project/pages/inicio.dart';
import 'package:firebase_path_project/pages/login_register_page.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key : key);
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Inicio(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}

