
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../utils.dart';


class IdentificationPage extends StatefulWidget {
  const IdentificationPage({super.key});

  @override
  State<IdentificationPage> createState() => _IdentificationPageState();
}



class _IdentificationPageState extends State<IdentificationPage> {

  int _counter = 0;
  Future<void> sendEId() async {
    bool r=await Provider.of<UserData>(context, listen: false,).sendEId();
    if(r){
      Navigator.of(context).pop();
    }else{
      final snackBar = SnackBar(content: Text("Not available!"),duration: const Duration(seconds: 5));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }
  Future<void> getEid() async {
    bool r=await Provider.of<UserData>(context, listen: false,).getEId();
    if(r){
      Navigator.of(context).pop();
    }else{
      final snackBar = SnackBar(content: Text("No data available!"),duration: const Duration(seconds: 5));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<void> sendOnlineIdent() async {
    bool r=await Provider.of<UserData>(context, listen: false,).sendOnlineIdent();
    if(r){
      Navigator.of(context).pop();
    }else{
      final snackBar = SnackBar(content: Text("Not available!"),duration: const Duration(seconds: 5));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<void> getOnlineIdent() async {
    bool r=await Provider.of<UserData>(context, listen: false,).getOnlineIdent();
    if(r){
      Navigator.of(context).pop();
    }else{
      final snackBar = SnackBar(content: Text("No data available!"),duration: const Duration(seconds: 5));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  MyDropDownMenuLanguage.from(context),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("e-ID",style: TextStyle(fontSize: 24),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FilledButton.tonal(
                      onPressed: sendEId,
                      child: Text(
                        'send e-ID invitation',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FilledButton.tonal(
                      onPressed: getEid,
                      child: Text(
                        'get e-ID data',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Online Ident",style: TextStyle(fontSize: 24),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FilledButton.tonal(
                      onPressed: sendOnlineIdent,
                      child: Text(
                        'send online-ident invitation',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: FilledButton.tonal(
                      onPressed: getOnlineIdent,
                      child: Text(
                        'get online-ident data',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
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
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
