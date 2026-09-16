

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:kycwallet/request.dart' as request;
import 'package:kycwallet/system_id.dart';
import 'package:path_provider/path_provider.dart';

import 'crypto_utils.dart';
import 'l10n/app_localizations.dart';
class UserData with ChangeNotifier{
  Username? username;
  User? user;
  Future<void> load(Username username) async {
    this.username=username;
    final Directory dir = await getApplicationDocumentsDirectory();
    final f=File("${dir.path}/users/${username.userId}.json");
    if(f.existsSync()){
      final json = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      user=User.fromJson(json);
    }else{
      user=await User.init();

      await save();
    }
  }
  Future<void> save() async {
    if(username==null||user==null) return;
    final Directory dir = await getApplicationDocumentsDirectory();
    final d=Directory("${dir.path}/users");
    if(!d.existsSync()){
      d.create();
    }
    final f=File("${dir.path}/users/${username!.userId}.json");
    f.writeAsString(jsonEncode(user!.toJson()));
  }
  Map<String, dynamic>? getDocMeta(List<dynamic> docMetas){
    for(Map<String, dynamic> d in docMetas){
      if(d["name"]=="data"){
        return d;
      }
    }
    return null;
  }
  Map<String, dynamic>? getSendEidTransaction(){
    if(user?.person==null) return null;
    for(Transaction t in user!.transactions){
      if(t is SendEId){
        List<dynamic> json=jsonDecode(t.getContent());
        if(json[0]["reference"]==user!.person!.reference){
          return json[0]["locators"][0];
        }
      }
    }
    return null;
  }
  Future<bool> getEId() async {
    if(user?.person==null) return false;
    try {
      Map<String, dynamic>? loc=getSendEidTransaction();
      //print(jsonEncode(loc));
      if(loc==null) return false;
      List<dynamic> docMetas=await request.getDocumentMeta(loc);
      //print(jsonEncode(docMetas));
      Map<String, dynamic>? docMeta=getDocMeta(docMetas);
      if(docMeta==null) return false;
      //print(jsonEncode(docMeta));
      String doc=utf8.decoder.convert(await request.getDocument(loc, "data"));
      //print(doc);
      user!.transactions.add(GetEId(DateTime.now(), doc));
      //String res=await request.getEId(user!.person!);
      //user?.transactions.add(GetEId(DateTime.now(), res));
      notifyListeners();
      save();
      return true;
    } on Exception catch (exception) {
      return false;
    }

  }
  Future<bool> sendEId() async {
    if(user?.person==null) return false;
    try {
      String res=await request.sendEId(user!.person!);
      user?.transactions.add(SendEId(DateTime.now(), res));
      notifyListeners();
      save();
      return true;
    } on Exception catch (exception) {
      return false;
    }
  }
  Future<bool> sendOnlineIdent() async {
    if(user?.person==null) return false;
    try {
      String res=await request.sendOnlineIdent(user!.person!);
      user?.transactions.add(SendOnlineIdent(DateTime.now(), res));
      notifyListeners();
      save();
      return true;
    } on Exception catch (exception) {
      return false;
    }

  }
  Future<bool> getOnlineIdent() async {
    if(user==null) return false;
    try {
      var ts=user!.transactions.whereType<SendOnlineIdent>().toList();
      if(ts.isEmpty) return false;
      var loc=jsonDecode(ts.last.getContent())[0]["locators"][0];
      if(loc==null) return false;
      print(loc);
      var metas=await request.getDocumentMeta(loc);
      if(metas.isEmpty) return false;
      var meta=metas.where((e)=>e["label"]=="Metadata").toList();
      if(meta.isEmpty) return false;
      print(meta);
      var res=await request.getDocumentString(loc, meta.first["name"]);
      print(res);
      user!.transactions.add(GetOnlineIdent(DateTime.now(), res));
      notifyListeners();
      save();
      return true;
    } on Exception catch (exception) {
      return false;
    }
  }
  Future<void> checkPerson() async {
    String res=await request.checkPerson(user!.person!);
    user?.transactions.add(PersonCheck(DateTime.now(), res));
    notifyListeners();
    save();
  }
  Future<void> addPerson(Person p) async {
    String res=await request.submitPerson(p);
    user?.transactions.add(PersonSubmitted(DateTime.now(), "$res\n${p.toString()}"));
    user?.person=p;
    notifyListeners();
    save();
  }

}
abstract class Transaction{
  DateTime getDate();
  String getTitle(BuildContext context);
  String getContent();
  Map<String, dynamic> toJson();

  static Transaction fromJson(Map<String, dynamic> json){
    if(json["type"]=="InitUser"){
      return InitUser.fromJson(json);
    }else if(json["type"]=="PersonSubmitted"){
      return PersonSubmitted.fromJson(json);
    }else if(json["type"]=="PersonCheck"){
      return PersonCheck.fromJson(json);
    }else if(json["type"]=="SendEId"){
      return SendEId.fromJson(json);
    }else if(json["type"]=="GetEId"){
      return GetEId.fromJson(json);
    }else if(json["type"]=="SendOnlineIdent"){
      return SendOnlineIdent.fromJson(json);
    }else if(json["type"]=="GetOnlineIdent"){
      return GetOnlineIdent.fromJson(json);
    }else{
      throw UnimplementedError();
    }
  }
}
class GetOnlineIdent extends Transaction{
  DateTime date;
  String content;

  GetOnlineIdent(this.date, this.content);

  @override
  String getContent() {
    return content.replaceAll(RegExp(r'>\s+<'), ">\n<");
  }

  @override
  DateTime getDate() {
    return date;
  }

  @override
  String getTitle(BuildContext context) {
    return "Onlineident data";
  }

  GetOnlineIdent.fromJson(Map<String, dynamic> json)
      : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        content = json['content'];

  @override
  Map<String, dynamic> toJson() => {
    'type': "GetOnlineIdent",
    'date': date.millisecondsSinceEpoch,
    'content': content
  };
}
class SendOnlineIdent extends Transaction{
  DateTime date;
  String content;

  SendOnlineIdent(this.date, this.content);

  @override
  String getContent() {
    return content;
  }

  @override
  DateTime getDate() {
    return date;
  }

  @override
  String getTitle(BuildContext context) {
    return "Onlineident invitation";
  }

  SendOnlineIdent.fromJson(Map<String, dynamic> json)
      : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        content = json['content'];

  @override
  Map<String, dynamic> toJson() => {
    'type': "SendOnlineIdent",
    'date': date.millisecondsSinceEpoch,
    'content': content
  };
}
class GetEId extends Transaction{
  DateTime date;
  String content;

  GetEId(this.date, this.content);

  @override
  String getContent() {
    return content;
  }

  @override
  DateTime getDate() {
    return date;
  }

  @override
  String getTitle(BuildContext context) {
    return "GetEId";
  }

  GetEId.fromJson(Map<String, dynamic> json)
      : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        content = json['content'];

  @override
  Map<String, dynamic> toJson() => {
    'type': "GetEId",
    'date': date.millisecondsSinceEpoch,
    'content': content
  };
}
class SendEId extends Transaction{
  DateTime date;
  String content;

  SendEId(this.date, this.content);

  @override
  String getContent() {
    return content;
  }

  @override
  DateTime getDate() {
    return date;
  }

  @override
  String getTitle(BuildContext context) {
    return "SendEId";
  }

  SendEId.fromJson(Map<String, dynamic> json)
      : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        content = json['content'];

  @override
  Map<String, dynamic> toJson() => {
    'type': "SendEId",
    'date': date.millisecondsSinceEpoch,
    'content': content
  };
}
class PersonCheck extends Transaction{
  DateTime date;
  String content;

  PersonCheck(this.date, this.content);

  @override
  String getContent() {
    return content;
  }

  @override
  DateTime getDate() {
    return date;
  }

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context,)!.personCheck;
  }

  PersonCheck.fromJson(Map<String, dynamic> json)
      : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        content = json['content'];

  @override
  Map<String, dynamic> toJson() => {
    'type': "PersonCheck",
    'date': date.millisecondsSinceEpoch,
    'content': content
  };
}
class PersonSubmitted extends Transaction{
  DateTime date;
  String content;

  PersonSubmitted(this.date, this.content);

  @override
  String getContent() {
    return content;
  }

  @override
  DateTime getDate() {
    return date;
  }

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context,)!.personSubmitted;
  }

  PersonSubmitted.fromJson(Map<String, dynamic> json)
      : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        content = json['content'];

  @override
  Map<String, dynamic> toJson() => {
    'type': "PersonSubmitted",
    'date': date.millisecondsSinceEpoch,
    'content': content
  };
}
class InitUser extends Transaction{
  DateTime date;
  String content;

  InitUser(this.date, this.content);

  @override
  String getContent() {
    return content;
  }

  @override
  DateTime getDate() {
    return date;
  }

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context,)!.initUserTitle;
  }

  InitUser.fromJson(Map<String, dynamic> json)
      : date = DateTime.fromMillisecondsSinceEpoch(json['date']),
        content = json['content'];

  @override
  Map<String, dynamic> toJson() => {
    'type': "InitUser",
    'date': date.millisecondsSinceEpoch,
    'content': content
  };

}
class User{
  String? fingerprint;
  RSAPublicKey publicKey;
  RSAPrivateKey privateKey;
  Person? person;
  List<Transaction> transactions;
  User(this.publicKey, this.privateKey, this.transactions, this.fingerprint);

  static Future<User> init() async {
    var kp = generateRSAkeyPair(exampleSecureRandom());
    String? fp=await getId();
    var t=InitUser(DateTime.now(), "Hardware Id:\n${fp??'null'}\n\n${CryptoUtils.encodeRSAPublicKeyToPem(kp.publicKey)}");
    return User(kp.publicKey, kp.privateKey,[t], fp);
    var json={};
    json["publicKey"]=CryptoUtils.encodeRSAPublicKeyToPem(kp.publicKey);
  }
  Map<String, dynamic> toJson() => {
    'publicKey': CryptoUtils.encodeRSAPublicKeyToPem(publicKey),
    'privateKey': CryptoUtils.encodeRSAPrivateKeyToPem(privateKey),
    'person': person?.toJson(),
    'transactions' : transactions.map((t){return t.toJson();}).toList(),
    'fingerprint' : fingerprint
  };
  User.fromJson(Map<String, dynamic> json)
      : publicKey = CryptoUtils.rsaPublicKeyFromPem(json['publicKey'] as String),
        privateKey = CryptoUtils.rsaPrivateKeyFromPem(json['privateKey'] as String),
        person = json['person']==null?null:Person.fromJson(json['person']),
        transactions=(json["transactions"] as List<dynamic>).map((t){return Transaction.fromJson(t);}).toList(),
        fingerprint=json['fingerprint'];


}
class Person{
  String reference;
  String firstName;
  String lastName;
  Date datesOfBirth;
  String citizenships;
  String countriesOfResidence;
  String email;
  String telephone;

  Person(this.reference, this.firstName, this.lastName, this.datesOfBirth,
      this.citizenships, this.countriesOfResidence, this.email, this.telephone);
  Map<String, dynamic> toRequest() => {
    'reference': reference,
    'type': "PERSON",
    'names': [{'firstName':firstName,'lastName' : lastName}],
    'datesOfBirth' : [datesOfBirth.toJson()],
    'citizenships' : [citizenships],
    'countriesOfResidence' : [countriesOfResidence],
    'emails' : [email],
    'telephones' : [telephone],
    "addresses":[],
    "structuredAddresses":[],
    "gender":"UNKNOWN",
    "title":"",
    "preferredLanguage":""
  };
  Map<String, dynamic> toJson() => {
    'reference': reference,
    'firstName': firstName,
    'lastName' : lastName,
    'datesOfBirth' : datesOfBirth.toJson(),
    'citizenships' : citizenships,
    'countriesOfResidence' : countriesOfResidence,
    'email' : email,
    'telephone' : telephone
  };
  Person.fromJson(Map<String, dynamic> json)
      : reference = json['reference'] as String,
        firstName = json['firstName'] as String,
        lastName = json['lastName'] as String,
        datesOfBirth = Date.fromJson(json['datesOfBirth']),
        citizenships = json['citizenships'] as String,
        countriesOfResidence = json['countriesOfResidence'] as String,
        email = json['email'] as String,
        telephone = json['telephone'] as String;
  @override
  String toString(){
    return "$reference\n$firstName $lastName\n${datesOfBirth.toString()}\n$citizenships\n$countriesOfResidence\n$email\n$telephone";
  }
  static Person fromCtr(TextEditingController fnCtr, TextEditingController lnCtr, TextEditingController dateCtr, TextEditingController citCtr, TextEditingController resCtr, TextEditingController emailCtr, TextEditingController telCtr) {
    List<String> dd=dateCtr.text.split("-");
    Date date=Date(int.parse(dd[0]),int.parse(dd[1]),int.parse(dd[2]));
    return Person(genRandString(15), fnCtr.text, lnCtr.text, date, citCtr.text, resCtr.text, emailCtr.text, telCtr.text.replaceAll("+", "00"));
  }
  bool hasChanged(TextEditingController fnCtr, TextEditingController lnCtr, TextEditingController dateCtr, TextEditingController citCtr, TextEditingController resCtr, TextEditingController emailCtr, TextEditingController telCtr){
    if(firstName!=fnCtr.text) return true;
    if(lastName!=lnCtr.text) return true;
    if(citizenships!=citCtr.text) return true;
    if(countriesOfResidence!=resCtr.text) return true;
    if(email!=emailCtr.text) return true;
    if(telephone!=telCtr.text) return true;
    List<String> dd=dateCtr.text.split("-");
    Date d=Date(int.parse(dd[0]),int.parse(dd[1]),int.parse(dd[2]));
    if(datesOfBirth.year!=d.year||datesOfBirth.month!=d.month||datesOfBirth.day!=d.day) return true;
    return false;
  }
}
class Date{
  int year;
  int month;
  int day;

  Date(this.year, this.month, this.day);
  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'day' : day
  };
  Date.fromJson(Map<String, dynamic> json)
      : year = json['year'] as int,
        month = json['month'] as int,
        day = json['day'] as int;
  String toString(){
    return "${year.toString()}-${month.toString()}-${day.toString()}";
  }
}
Future<void> removeAll() async {
  final Directory dir = await getApplicationDocumentsDirectory();
  final d=Directory("${dir.path}/users");
  if(d.existsSync()){
    d.deleteSync(recursive: true);
  }
  final f=File("${dir.path}/users.json");
  if(f.existsSync()){
    f.deleteSync();
  }
}
Future<void> showAll() async {
  final Directory dir = await getApplicationDocumentsDirectory();
  final f=File("${dir.path}/users.json");
  if(f.existsSync()){
    print(f.path);
    print(f.readAsStringSync());
  }
  final d=Directory("${dir.path}/users");
  if(d.existsSync()){
    List<FileSystemEntity> fs=d.listSync();
    for(var f in fs){
      var ff=File(f.path);
      print(ff.path);
      print(ff.readAsStringSync());
    }
  }

}
class Users with ChangeNotifier {
  List<Username>? users=null;
  Username? get(String userId){
    if(users==null) return null;
    for(Username u in users!){
      if(u.userId==userId) return u;
    }
    return null;
  }
  Username? addUser(String username){
    String id;
    do{
      id=genRandString(15);
    }while(users!.any((a){return a.userId==id;}));
    var un=Username(username, id);
    users!.add(un);
    notifyListeners();
    save();
    return(un);
  }
  Future<void> save() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final f=File("${dir.path}/users.json");
    f.writeAsString(jsonEncode(this.toJson()));
  }
  Future<void> init() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final f=File("${dir.path}/users.json");
    if(f.existsSync()){
      final json = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      final arr=json["users"] as List<dynamic>;
      users=arr.map((a){return Username.fromJson(a);}).toList();
    }else{
      users=[];
    }
  }
  Map<String, dynamic> toJson() => {'users': users!.map((a){return a.toJson();}).toList(growable: false)};

}

class Username{
  String username;
  String userId;

  Username(this.username, this.userId);
  Map<String, dynamic> toJson() => {'username': username, 'userId': userId};
  Username.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        userId = json['userId'] as String;
}
String genRandString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}