import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/api.dart';

import 'data_provider.dart';

final String API_RESOURCE_URL="https://kyc.eurospider.com/v8-test-api/rest/3.0.0";
final String API_MANDATOR="eurospider";
final String API_USER="api";
final String API_PASSWORD="0Q4tGQjp";
Future<void> sendRandom(Map<dynamic,dynamic> json) async {
  http.Response res=await http.put(Uri.parse("https://services.kycspider.com/kyc-wallet/rest/1.0.0/upload"),
    headers: {'Content-Type': 'application/json',"Authorization": "Basic c3RvcmU6MlQqUnpWUS0zTEdfVSZXVg=="},
    body: jsonEncode(json)
  );
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return;
}
Future<Uint8List> getDocument(Map<String, dynamic> locator, String part) async {
  String key=await authenticate();
  http.Response res=await http.get(Uri.parse("$API_RESOURCE_URL/customers/${locator["reference"]}/documents/${locator["document"]}/versions/${locator["version"]}/parts/$part"),
    headers: {'Content-Type': 'application/json',"Session-Key": key},
  );
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return res.bodyBytes;
}
Future<String> getDocumentString(Map<String, dynamic> locator, String part) async {
  String key=await authenticate();
  http.Response res=await http.get(Uri.parse("$API_RESOURCE_URL/customers/${locator["reference"]}/documents/${locator["document"]}/versions/${locator["version"]}/parts/$part"),
    headers: {'Content-Type': 'application/json',"Session-Key": key},
  );
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return res.body;
}
Future<List<dynamic>> getDocumentMeta(Map<String, dynamic> locator) async {
  String key=await authenticate();
  http.Response res=await http.get(Uri.parse("$API_RESOURCE_URL/customers/${locator["reference"]}/documents/${locator["document"]}/versions/${locator["version"]}/parts"),
      headers: {'Content-Type': 'application/json',"Session-Key": key},
      );
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return jsonDecode(res.body);
}

Future<String> sendOnlineIdent(Person person) async {
  String key=await authenticate();
  http.Response res=await http.post(Uri.parse("$API_RESOURCE_URL/customers/initiate-online-identification-sessions"),
      headers: {'Content-Type': 'application/json',"Session-Key": key},
      body: jsonEncode({"references":[person.reference],"overridingInvitationUrl":null,"sendInvitation":true}));
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  print(res.body);
  return res.body;
}
Future<String> sendEId(Person person) async {
  String key=await authenticate();
  http.Response res=await http.post(Uri.parse("$API_RESOURCE_URL/customers/initiate-identification-sessions?type=SWISS_EID"),
      headers: {'Content-Type': 'application/json',"Session-Key": key},
      body: jsonEncode({"references":[person.reference],"overridingInvitationUrl":null,"sendInvitation":true}));
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return res.body;
}
Future<String> checkPerson(Person person) async {
  String key=await authenticate();
  http.Response res=await http.post(Uri.parse("$API_RESOURCE_URL/customers/check"),
      headers: {'Content-Type': 'application/json',"Session-Key": key},
      body: jsonEncode([person.reference]));
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return res.body;
}
Future<String> submitPerson(Person person) async {
  String key=await authenticate();
  http.Response res=await http.post(Uri.parse("$API_RESOURCE_URL/customers/simple"),
      headers: {'Content-Type': 'application/json',"Session-Key": key},
      body: jsonEncode(person.toRequest()));
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return res.body;
}
Future<String> challenge() async {
  http.Response res=await http.get(Uri.parse("$API_RESOURCE_URL/challenge"));
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  return res.body;
}
Future<String> authenticate() async {
  var o=jsonDecode(await challenge());
  final sha1 = Digest("SHA-1");

  String hash=HexUtils.encode(sha1.process(utf8.encoder.convert((o["key"] as String)+API_MANDATOR + API_USER + API_PASSWORD +(o["challenge"] as String)))).toLowerCase();
  String body=jsonEncode({"key":o["key"],"mandator":API_MANDATOR,"user":API_USER,"response":hash});
  http.Response res=await http.post(Uri.parse("$API_RESOURCE_URL/authenticate"), headers: {'Content-Type': 'application/json'},body: body);
  if(res.statusCode!=200) throw Exception("Status code: ${res.statusCode}");
  if(res.body=="okay"){
    return o["key"];
  }else{
    throw  Exception("Authenticate failed: ${res.body}");
  }
}

