import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyzo_wallet/Data/AppLocalizations.dart';
import 'package:nyzo_wallet/Data/Verifier.dart';
import 'package:nyzo_wallet/Data/watchedAddress.dart';
import 'Data/Wallet.dart';
import 'homePage.dart';
import 'package:nyzo_wallet/Widgets/ColorTheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool lightTheme = false;
  Color baseColor = Colors.white;
  Color secondaryColor = Colors.black;
  Color extraColor = Colors.black87;
  Color transparentColor = Colors.grey[300];
  Color highLightColor = Colors.grey[100];
  List<Verifier> verifiersList;
  List<WatchedAddress> addressesToWatch;
  List<List<String>> balanceList;
  @override
  void initState() {
    downloadBalanceList();
    updateTheme();
    setVerifiers();
    super.initState();
  }

  void updateTheme() {
    getNightModeValue().then((bool value) {
      setState(() {
        value??=false;
        lightTheme = value;
        if (!lightTheme) {
          baseColor = Colors.white;
          secondaryColor = Colors.black;
          extraColor = Colors.black87;
          transparentColor = Colors.grey[300];
          highLightColor = Colors.grey[100];
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        } else {
          baseColor = Colors.black;
          secondaryColor = Colors.white;
          extraColor = Colors.white;
          transparentColor = Colors.white30;
          highLightColor = Colors.white10;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    
    return ColorTheme(
      lightTheme: lightTheme,
      update: updateTheme,
      baseColor: baseColor,
      secondaryColor: secondaryColor,
      extraColor: extraColor,
      transparentColor: transparentColor,
      highLigthColor: highLightColor,
      verifiersList: verifiersList,
      updateVerifiers: setVerifiers,
      addressesToWatch: addressesToWatch,
      getBalanceList: downloadBalanceList,
      balanceList: balanceList,
      updateAddressesToWatch: updateWatchAddresses,
      child: MaterialApp(
        supportedLocales:[
          Locale('en','US'),
          Locale('es','ES')
        ] ,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeListResolutionCallback: (List<Locale> locales,Iterable<Locale> supportedLocales){
          for (var eachLocale  in locales) {
            for (var eachSupportedLocale in supportedLocales) {
              if (eachLocale.languageCode == eachSupportedLocale.languageCode) {
                return eachSupportedLocale;
              }
              
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        title: 'Nyzo Wallet',
        home: HomePage(),
      ),
    );
  }

  Future<List<Verifier>> setVerifiers() async {
    getVerifiers().then((List<Verifier> _verifiersList) {
      setState(() {
        verifiersList = _verifiersList;
      });
      return _verifiersList;
    });
  }

  void updateWatchAddresses(){
    getWatchAddresses().then((List<WatchedAddress> _list) {
          setState(() {
            addressesToWatch = _list;
            for (var eachAddress in addressesToWatch) {
              eachAddress.balance =
                  balanceList.firstWhere((List<String> address) {
                return address[0] == eachAddress.address;
              })[1];
            }
          });
        });
  }
  void downloadBalanceList(){
    getBalanceList().then((List<List<String>> _balanceList) {
        setState(() {
          balanceList = _balanceList;
        });
        getWatchAddresses().then((List<WatchedAddress> _list) {
          setState(() {
            addressesToWatch = _list;
            for (var eachAddress in addressesToWatch) {
              eachAddress.balance =
                  balanceList.firstWhere((List<String> address) {
                return address[0] == eachAddress.address;
              })[1];
            }
          });
        });
      });
  }
}
