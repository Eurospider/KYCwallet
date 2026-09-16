
import 'package:flutter/material.dart';
import 'package:kycwallet/data_provider.dart';

import 'main.dart';



class MyDropDownMenu extends StatelessWidget{
  const MyDropDownMenu({ super.key, required this.dropdownValue, required this.items, required this.setDropdownValue });
  final MyDropdownMenuItem dropdownValue;
  final List<DropdownMenuItem<MyDropdownMenuItem>> items;
  final void Function(MyDropdownMenuItem?) setDropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MyDropdownMenuItem>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: setDropdownValue,
      items: items,
    );
  }
}
class MyDropdownMenuItem{
  const MyDropdownMenuItem({required this.value, required this.isNewUser});
  final Username? value;
  final bool isNewUser;
}


/*
class MyDropDownMenuLanguage extends StatelessWidget {
  MyDropDownMenuLanguage({ super.key , this.dropdownValue, required this.items, required this.onChange});
  final MyDropdownMenuItemLanguage? dropdownValue;
  final List<DropdownMenuItem<MyDropdownMenuItemLanguage>> items;
  final void Function(MyDropdownMenuItemLanguage?) onChange;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<MyDropdownMenuItemLanguage>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: onChange,
      items: items,
    );
  }
}

 */

class MyDropDownMenuLanguage extends StatefulWidget {
  MyDropDownMenuLanguage({ super.key,required this.dropdownValue, required this.items });

  MyDropdownMenuItemLanguage? dropdownValue;
  final List<DropdownMenuItem<MyDropdownMenuItemLanguage>> items;
  static MyDropDownMenuLanguage from(BuildContext context){
    List<DropdownMenuItem<MyDropdownMenuItemLanguage>> items=context.findAncestorWidgetOfExactType<MaterialApp>()?.supportedLocales
        .map((a){return DropdownMenuItem<MyDropdownMenuItemLanguage>(value: MyDropdownMenuItemLanguage(value: a),child: Text(a.languageCode),);}).toList()??[];
    Locale currentLocale=Localizations.localeOf(context);
    MyDropdownMenuItemLanguage? dropdownValue=items.where((DropdownMenuItem<MyDropdownMenuItemLanguage> test){return test.value?.value.languageCode==currentLocale.languageCode;}).first.value;
    return MyDropDownMenuLanguage(dropdownValue: dropdownValue, items: items);
  }
  @override
  State<MyDropDownMenuLanguage> createState() => _MyDropDownMenuLanguageState();
}

class _MyDropDownMenuLanguageState extends State<MyDropDownMenuLanguage> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MyDropdownMenuItemLanguage>(
      value: widget.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: (MyDropdownMenuItemLanguage? a){
        setState(() {
          widget.dropdownValue=a!;
        });
        MyApp.setLocale(context, a!.value);
      },
      items: widget.items,
    );
  }
}

class MyDropdownMenuItemLanguage{
  const MyDropdownMenuItemLanguage({required this.value});
  final Locale value;
}