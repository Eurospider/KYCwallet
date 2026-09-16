

import 'package:flutter/material.dart';
import 'package:kycwallet/data_provider.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../utils.dart';


class GwgCheckPage extends StatefulWidget {
  const GwgCheckPage({super.key});

  @override
  State<GwgCheckPage> createState() => _GwgCheckPageState();
}



class _GwgCheckPageState extends State<GwgCheckPage> {

  int _counter = 0;
  late TextEditingController fnCtr = TextEditingController()..addListener(() {setState(() {});});
  late TextEditingController lnCtr = TextEditingController()..addListener(() {setState(() {});});
  late TextEditingController dateCtr = TextEditingController()..addListener(() {setState(() {});});
  late TextEditingController citCtr = TextEditingController()..addListener(() {setState(() {});});
  late TextEditingController resCtr = TextEditingController()..addListener(() {setState(() {});});
  late TextEditingController emailCtr = TextEditingController()..addListener(() {setState(() {});});
  late TextEditingController telCtr = TextEditingController()..addListener(() {setState(() {});});
  @override
  void initState(){
    super.initState();
    if(Provider.of<UserData>(context, listen: false,).user!.person!=null){
      Person p=Provider.of<UserData>(context, listen: false,).user!.person!;
      fnCtr.text=p.firstName;
      lnCtr.text=p.lastName;
      dateCtr.text=p.datesOfBirth.toString();
      citCtr.text=p.citizenships;
      resCtr.text=p.countriesOfResidence;
      emailCtr.text=p.email;
      telCtr.text=p.telephone;
    }
  }

  Future<void> checkRisk() async {
    if(Provider.of<UserData>(context, listen: false,).user!.person==null||Provider.of<UserData>(context, listen: false,).user!.person!.hasChanged(fnCtr, lnCtr, dateCtr, citCtr, resCtr, emailCtr, telCtr)){
      Person p=Person.fromCtr(fnCtr,lnCtr,dateCtr,citCtr,resCtr,emailCtr,telCtr);
      await Provider.of<UserData>(context, listen: false,).addPerson(p);
      await Provider.of<UserData>(context, listen: false,).checkPerson();
      Navigator.of(context).pop();
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
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: Text(AppLocalizations.of(context)!.gwgCheck,style: TextStyle(fontSize: 25),)),
                  MyDropDownMenuLanguage.from(context),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 400,
                child: Column(
                  children: [

                    Padding(padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: fnCtr,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: AppLocalizations.of(context,)!.firstName,
                          labelText: AppLocalizations.of(context,)!.firstName,
                          //helperText: "Username must contain special character",
                          helperStyle: TextStyle(color: Colors.green),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: lnCtr,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: AppLocalizations.of(context,)!.lastName,
                          labelText: AppLocalizations.of(context,)!.lastName,
                          //helperText: "Username must contain special character",
                          helperStyle: TextStyle(color: Colors.green),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: dateCtr,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "${AppLocalizations.of(context,)!.datesOfBirth} [1990-01-31]",
                          labelText: "${AppLocalizations.of(context,)!.datesOfBirth} [1990-01-31]",
                          //helperText: "Username must contain special character",
                          helperStyle: TextStyle(color: Colors.green),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: citCtr,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: AppLocalizations.of(context,)!.citizenships,
                          labelText: AppLocalizations.of(context,)!.citizenships,
                          //helperText: "Username must contain special character",
                          helperStyle: TextStyle(color: Colors.green),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: resCtr,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: AppLocalizations.of(context,)!.countriesOfResidence,
                          labelText: AppLocalizations.of(context,)!.countriesOfResidence,
                          //helperText: "Username must contain special character",
                          helperStyle: TextStyle(color: Colors.green),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: emailCtr,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: AppLocalizations.of(context,)!.email,
                          labelText: AppLocalizations.of(context,)!.email,
                          //helperText: "Username must contain special character",
                          helperStyle: TextStyle(color: Colors.green),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: telCtr,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: AppLocalizations.of(context,)!.telephone,
                          labelText: AppLocalizations.of(context,)!.telephone,
                          //helperText: "Username must contain special character",
                          helperStyle: TextStyle(color: Colors.green),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10),
                      child: FilledButton.tonal(
                        onPressed: Provider.of<UserData>(context, listen: false,).user!.person?.hasChanged(fnCtr, lnCtr, dateCtr, citCtr, resCtr, emailCtr, telCtr)??true?checkRisk:null,
                        child: Text(
                          'Check Risk',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
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
