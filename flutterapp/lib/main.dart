import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kycwallet/data_provider.dart';
import 'package:kycwallet/pages/loading_screen.dart';

import 'package:kycwallet/pages/login.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'navigation_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Users()),
        ChangeNotifierProvider(create: (context) => UserData()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'KYC Wallet',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('de'),
        Locale('en'),
      ],
      locale: _locale,
      localeResolutionCallback: (locale, supportedLocales) {
        return locale;
      },
      navigatorKey: NavigationService.navigatorKey,
      theme:
      //ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 254, 0, 0),)),

      ThemeData(colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 143, 74, 64),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          primaryContainer: Color.fromARGB(255, 255, 217, 212),
          onPrimaryContainer: Color.fromARGB(255, 115, 51, 41),
          secondary: Color.fromARGB(255, 119, 86, 80),
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          secondaryContainer: Color.fromARGB(255, 255, 217, 212),
          onSecondaryContainer: Color.fromARGB(255, 92, 63, 59),
          tertiary: Color.fromARGB(255, 111, 92, 46),
          onTertiary: Color.fromARGB(255, 255, 255, 255),
          tertiaryContainer: Color.fromARGB(255, 250, 222, 166),
          onTertiaryContainer: Color.fromARGB(255, 86, 68, 24),
          error: Color.fromARGB(255, 185, 26, 26),
          onError: Color.fromARGB(255, 255, 255, 255),
          errorContainer: Color.fromARGB(255, 255, 217, 213),
          onErrorContainer: Color.fromARGB(255, 147, 0, 9),
          surface: Color.fromARGB(255, 255, 49, 49),
          onSurface: Color.fromARGB(255, 35, 24, 23)
      )),
      home: const LoadingScreen(),
    );
  }
}