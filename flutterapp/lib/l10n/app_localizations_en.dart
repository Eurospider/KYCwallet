// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get newWallet => 'new wallet';

  @override
  String get walletName => 'wallet name';

  @override
  String get password => 'password';

  @override
  String get initUserTitle => 'New wallet created.';

  @override
  String get personSubmitted => 'New personal details submitted.';

  @override
  String get personCheck => 'Risk check';

  @override
  String get transaction => 'Transaction';

  @override
  String get lastTransactions => 'Last transactions';

  @override
  String get allTransactions => 'All transactions';

  @override
  String get more => 'more...';

  @override
  String get gwgCheck => 'GWG Check';

  @override
  String get firstName => 'first name';

  @override
  String get lastName => 'last name';

  @override
  String get datesOfBirth => 'date of birth';

  @override
  String get citizenships => 'citizenship';

  @override
  String get countriesOfResidence => 'tax residence (country)';

  @override
  String get email => 'e-mail';

  @override
  String get telephone => 'telephone';
}
