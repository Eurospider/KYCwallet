import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kycwallet/pages/all_transactions.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../l10n/app_localizations.dart';

class TransactionModel extends StatelessWidget {
  const TransactionModel({ super.key });

  static Widget getModel(BuildContext context,Transaction t){
    return Text("${t.getDate()}: ${t.getTitle(context)}");
  }
  @override
  Widget build(BuildContext context) {
    final List<Transaction> transactions=Provider.of<UserData>(context, listen: false,).user!.transactions;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(180, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.lastTransactions,style: TextStyle(fontSize: 24),),
              ...transactions.reversed.toList().getRange(0, min(3, transactions.length)).map((t){return getModel(context, t);}),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => AllTransactionsPage(transactions: transactions),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.more),
              )
            ],
          ),
        ),
      ),
    );
  }
}