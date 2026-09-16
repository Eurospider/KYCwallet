



import 'package:flutter/material.dart';
import 'package:kycwallet/data_provider.dart';
import 'package:kycwallet/pages/single_transaction.dart';


import '../l10n/app_localizations.dart';
import '../utils.dart';


class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key, required this.transactions});
  final List<Transaction> transactions;
  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}



class _AllTransactionsPageState extends State<AllTransactionsPage> {

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
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(height: 1.0,),
          itemCount: widget.transactions.length+1,
          itemBuilder: (BuildContext context, int index) {
            if(index==0){
              return Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(child: Text(AppLocalizations.of(context)!.allTransactions,style: TextStyle(fontSize: 25),)),
                    MyDropDownMenuLanguage.from(context),
                  ],
                ),
              );
            }else{
              return MyComponent(transaction: widget.transactions[index-1]);
            }
          },
        )
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
class MyComponent extends StatelessWidget{
  const MyComponent({super.key, required this.transaction});
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => SingleTransactionPage(transaction: transaction),
          ),
        );
      },
      child: Padding(padding: EdgeInsets.all(10),
        child: Text("${transaction.getDate()}: ${transaction.getTitle(context)}"),
      ),
    );
  }


}
