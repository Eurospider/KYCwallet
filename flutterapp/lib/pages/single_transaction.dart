


import 'package:flutter/material.dart';

import '../data_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils.dart';



class SingleTransactionPage extends StatefulWidget {
  const SingleTransactionPage({super.key, required this.transaction});
  final Transaction transaction;
  @override
  State<SingleTransactionPage> createState() => _SingleTransactionPageState();
}



class _SingleTransactionPageState extends State<SingleTransactionPage> {

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
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: Text(AppLocalizations.of(context)!.transaction,style: TextStyle(fontSize: 25),)),
                  MyDropDownMenuLanguage.from(context),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(widget.transaction.getTitle(context),style: TextStyle(fontSize: 24),),
            ),
            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text("${widget.transaction.getDate()}"),
            ),
            Padding(padding: EdgeInsets.all(10),
              child: SelectableText(widget.transaction.getContent()),
            )
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
