import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  class HomeScreen extends StatefulWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome'),
      ),
      body: Center(
          child:
          Text (
            'je suis le Home Screen',
          )
      ),
    );
  }

}