import 'package:flutter/material.dart';
import 'homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const nyzoRed = const Color(0xFF550000);
  static const kBlackLight = const Color(0xFF484848);
  static const kBlack = const Color(0xFF000000);
  static const kYellow = const Color(0xFFffd600);
  static const kYellowLight = const Color(0xFFffff52);
  static const kYellowDark = const Color(0xFFc7a500);
  static const kWhite = Colors.white;

  static final Map<int, Color> nyzoColor = {
    50: Color.fromRGBO(80, 0, 0, .1),
    100: Color.fromRGBO(80, 0, 0, .2),
    200: Color.fromRGBO(80, 0, 0, .3),
    300: Color.fromRGBO(80, 0, 0, .4),
    400: Color.fromRGBO(80, 0, 0, .5),
    500: Color.fromRGBO(80, 0, 0, .6),
    600: Color.fromRGBO(80, 0, 0, .7),
    700: Color.fromRGBO(80, 0, 0, .8),
    800: Color.fromRGBO(80, 0, 0, .9),
    900: Color.fromRGBO(80, 0, 0, 1),
  };
  ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData();
    return base.copyWith(
      primaryColor: kWhite,
      accentColor: nyzoRed,
      scaffoldBackgroundColor: nyzoRed,
      primaryTextTheme: buildTextTheme(base.primaryTextTheme, kWhite),
      primaryIconTheme: base.iconTheme.copyWith(color: kWhite),
      buttonColor: kWhite,
      hintColor: kWhite,
      textTheme: buildTextTheme(base.textTheme, kWhite),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: kWhite),
      ),
    );
  }

  TextTheme buildTextTheme(TextTheme base, Color color) {
    return base.copyWith(
      body1: base.headline.copyWith(color: color, fontSize: 16.0),
      caption: base.headline.copyWith(color: color),
      display1: base.headline.copyWith(color: color),
      button: base.headline.copyWith(color: color),
      headline: base.headline.copyWith(color: color),
      title: base.title.copyWith(color: color),
    );
  }

  static MaterialColor colorCustom = MaterialColor(0xFF500000, nyzoColor);
  final ThemeData base = ThemeData();
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nyzo Wallet',
      theme: buildDarkTheme(),
      home: HomePage(),
    );
  }
}
