import 'dart:convert';
import 'dart:math';
import 'dart:ui';



import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:gscankit/gscankit.dart';
import 'package:kycwallet/data_provider.dart';
import 'package:kycwallet/models/transaction.dart';
import 'package:kycwallet/pages/gwg_check.dart';
import 'package:kycwallet/system_id.dart';
import 'package:provider/provider.dart';

import 'package:kycwallet/request.dart' as request;



import '../crypto_utils.dart';
import '../utils.dart';
import 'identification_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{

  int _counter = 0;
  GlobalKey head1Key=GlobalKey();
  GlobalKey head2Key=GlobalKey();
  GlobalKey wrapKey=GlobalKey();
  GlobalKey transKey=GlobalKey();
  GlobalKey logoKey=GlobalKey();
  double offset=0;
  @override
  void initState() {
    _setOffset();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _setOffset();
  }
  void _setOffset(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      final h1=_getHeight(head1Key);
      final h2=_getHeight(head2Key);
      final h3=_getHeight(wrapKey);
      final h4=_getHeight(transKey);
      final h5=_getHeight(logoKey);
      double _offset;
      if(h1!=null&&h2!=null&&h3!=null&&h4!=null&&h5!=null){
        _offset=max(0, MediaQuery.of(context).size.height-h1-h2-h3-h4-h5);
      }else{
        _offset=0;
      }
      if(_offset!=offset){
        setState(() {
          offset=_offset;
        });
      }

    });
    setState(() {

    });
  }
  double? _getHeight(GlobalKey key){
    return key.currentContext?.findRenderObject()?.paintBounds.height;
  }
  Future<void> _incrementCounter() async {
    SendOnlineIdent? t=Provider.of<UserData>(context, listen: false,).user!.transactions.where((e)=>e is SendOnlineIdent).last as SendOnlineIdent;
    var loc=jsonDecode(t.getContent())[0]["locators"][0];
    print(loc);
    var metas=await request.getDocumentMeta(loc);
    var meta=metas.where((e)=>e["label"]=="Metadata").first;
    print(meta);
    var res=await request.getDocumentString(loc, meta["name"]);
    res=res.replaceAll(RegExp(r'>\s+<'), ">\n<");
    print(res);



    setState(() {
      _counter++;
    });
  }
  bool _isScanning=false;
  void scan (){
    if(_isScanning) return;
    var checks=Provider.of<UserData>(context, listen: false,).user!.transactions.whereType<PersonCheck>().toList();
    if(checks.isEmpty) return;
    PersonCheck check=checks.last;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GscanKit(
          onDetect: (BarcodeCapture capture) {
            if(!_isScanning){
              _isScanning=true;
              print(capture.barcodes.first.displayValue);
              String? val=capture.barcodes.first.displayValue;
              Navigator.of(context).pop(val);
            }

          },
        ),
      ),
    ).then((a){
      Future.delayed(Duration(seconds: 3)).then((b){_isScanning=false;});
      print(a);
      Uri url= Uri.parse(a);
      print(url.queryParameters["id"]);
      int n=int.parse(url.queryParameters["id"]!);
      print(n);


      List<dynamic> chl=jsonDecode(check.getContent());
      //var kp = generateRSAkeyPair(exampleSecureRandom());

      var json={};
      json["pub_key"]=CryptoUtils.encodeRSAPublicKeyToPem(Provider.of<UserData>(context, listen: false,).user!.publicKey);
      json["pub_key_signed"]=base64.encode(rsaSign(Provider.of<UserData>(context, listen: false,).user!.privateKey,utf8.encode(CryptoUtils.encodeRSAPublicKeyToPem(Provider.of<UserData>(context, listen: false,).user!.publicKey))));
      json["rand"]=n;
      json["rand_signed"]=base64.encode(rsaSign(Provider.of<UserData>(context, listen: false,).user!.privateKey,int64bytes(n)));
      json["aml_risk_key"]=chl[0]["riskState"];
      json["aml_risk_key_signed"]="SIGNED BY KYC SPIDER";
      json["checkTime"]=chl[0]["checkTime"];
      print(jsonEncode(json));
      request.sendRandom(json);
    });
  }
  void scan2 (){
    if(_isScanning) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GscanKit(
          onDetect: (BarcodeCapture capture) {
            if(!_isScanning){
              _isScanning=true;
              print(capture.barcodes.first.displayValue);
              String? val=capture.barcodes.first.displayValue;
              Navigator.of(context).pop(val);
            }

          },
        ),
      ),
    ).then((a){
      Future.delayed(Duration(seconds: 3)).then((b){_isScanning=false;});
      print(a);
      Uri url= Uri.parse(a);
      print(url.queryParameters["id"]);
      int n=int.parse(url.queryParameters["id"]!);
      print(n);

      var kp = generateRSAkeyPair(exampleSecureRandom());

      var json={};
      json["publicKey"]=CryptoUtils.encodeRSAPublicKeyToPem(kp.publicKey);
      json["signedPublicKey"]=base64.encode(rsaSign(kp.privateKey,utf8.encode(CryptoUtils.encodeRSAPublicKeyToPem(kp.publicKey))));
      json["id"]=n;
      json["signedId"]=base64.encode(rsaSign(kp.privateKey,int64bytes(n)));
      print("publicKey");
      print(json["publicKey"]);
      print("signedPublicKey");
      print(json["signedPublicKey"]);
      print("id");
      print(json["id"]);
      print("signedId");
      print(json["signedId"]);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: head1Key,
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
              key: head2Key,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  MyDropDownMenuLanguage.from(context),
                ],
              ),
            ),
            Center(
              key: wrapKey,
              child: Wrap(
                children: [
                  GestureDetector(
                    onTap: scan,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        shadowColor: Colors.black,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: const Image(image: AssetImage('assets/images/qr-code-scan-svgrepo-com.png'),width: 80,height:80),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Text("Scan QR-Code"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const IdentificationPage(),
                        ),
                      ).then((a){setState(() {});_setOffset();});
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        shadowColor: Colors.black,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: const Image(image: AssetImage('assets/images/id-wallet-svgrepo-com.png'),width: 80,height:80),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Text("Identification"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const GwgCheckPage(),
                        ),
                      ).then((a){setState(() {});_setOffset();});
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        shadowColor: Colors.black,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: const Image(image: AssetImage('assets/images/kyc-spider-icon-2.png'),width: 80,height:80),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Text("GWG-Check"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: offset),
            TransactionModel(key: transKey, ),
            //Text(AppLocalizations.of(context)!.helloWorld),


            Padding(
              key: logoKey,
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

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.title, required this.icon});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        shadowColor: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Icon(icon, size: 80),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
