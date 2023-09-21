import 'package:firebase_path_project/auth.dart';
import 'package:firebase_path_project/pages/login_register_page.dart';
import 'package:firebase_path_project/pages/menu.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Menu();
        }else{
          return const LoginPage();
        }
      },
    );
  }
}
