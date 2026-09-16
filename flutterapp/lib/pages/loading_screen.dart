
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:kycwallet/pages/login.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../utils.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}



class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Users>(context, listen: false,).init().then((_)=>{
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute(
          builder: (context) => MyLoginPage(),
        ),
      )
    });
  }
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KYC Wallet"),
        backgroundColor: Color.fromARGB(211, 255, 0, 0),
      ),
      body: Center(
        child: Image(
          image: AssetImage('assets/images/kyc-spider-icon-2.png'),
          fit: BoxFit.fill,
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
