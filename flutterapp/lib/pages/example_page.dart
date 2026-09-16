
import 'dart:ui';


import 'package:flutter/material.dart';

import '../utils.dart';



class MyExamplePage extends StatefulWidget {
  const MyExamplePage({super.key});

  @override
  State<MyExamplePage> createState() => _MyExamplePageState();
}



class _MyExamplePageState extends State<MyExamplePage> {

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
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Icon(Icons.close),
                    ),
                    Expanded(child: Container()),
                    MyDropDownMenuLanguage.from(context),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Container(

                  )
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(50, 255, 255, 255),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Image(
                        image: AssetImage(
                          'assets/images/kyc-spider-logo-letter-1.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
