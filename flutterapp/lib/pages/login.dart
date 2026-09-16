import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kycwallet/data_provider.dart';
import 'package:kycwallet/pages/home.dart';

import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../utils.dart';


class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  int _counter = 0;

  String? dropdownValue="";
  late MyDropdownMenuItem newUser;

  @override
  void initState() {
    super.initState();
    newUser=MyDropdownMenuItem(value: null, isNewUser: true);
    //dropdownValue=newUser;
    setState(() {

    });
  }


  void setDropdownValue(String? v) {
    setState(() {
      dropdownValue = v!;
    });
  }

  bool passwordVisible = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();

  Future<void> onSubmit() async {
    if(dropdownValue!=null){

      Username? un;
      if(dropdownValue==""){
        un=Provider.of<Users>(context, listen: false,).addUser(userController.text);
        print(un?.username);
      }else{
        un=Provider.of<Users>(context, listen: false,).get(dropdownValue!);
      }
      print(un?.username);
      await Provider.of<UserData>(context, listen: false,).load(un!);
      setState(() {

      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyHomePage(

          ),
        ),
      );
    }

  }

  void _incrementCounter() {
    //removeAll();
    print(dropdownValue);
    //showAll();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("KYC Wallet Login"),
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
            DropdownButton<String>(
              value: dropdownValue??"",
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(height: 2, color: Colors.deepPurpleAccent),
              onChanged: setDropdownValue,
              items: [
                DropdownMenuItem<String>(
                  value: "",
                  child: Text(AppLocalizations.of(context,)!.newWallet),
                ),
                 ...Provider.of<Users>(context, listen: false,).users!.map((u) {
                  return DropdownMenuItem<String>(
                    value: u.userId,
                    child: Text(u.username),
                  );
                })
              ],
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      if (dropdownValue=="")
                        Padding(padding: EdgeInsets.all(5),
                          child: TextField(
                            controller: userController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: AppLocalizations.of(context,)!.walletName,
                              labelText: AppLocalizations.of(context,)!.walletName,
                              //helperText: "Username must contain special character",
                              helperStyle: TextStyle(color: Colors.green),
                              alignLabelWithHint: false,
                              filled: true,
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      Padding(padding: EdgeInsets.all(5),
                        child: TextField(
                          controller: passwordController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: AppLocalizations.of(context,)!.password,
                            labelText: AppLocalizations.of(context,)!.password,
                            //helperText: "Password must contain special character",
                            helperStyle: TextStyle(color: Colors.green),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            alignLabelWithHint: false,
                            filled: true,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                        ),
                      ),

                      Padding(padding: EdgeInsets.all(20),
                        child: FilledButton.tonal(
                          onPressed: onSubmit,
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(50, 255, 255, 255)),
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
