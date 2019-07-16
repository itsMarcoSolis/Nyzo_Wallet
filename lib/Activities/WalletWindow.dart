import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Activities/SettingsWindow.dart';
import 'package:nyzo_wallet/Activities/verifiersWindow.dart';
import 'package:nyzo_wallet/Data/Verifier.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:flutter/services.dart';
import 'package:nyzo_wallet/Data/noScalingAnimation.dart';
import 'package:nyzo_wallet/Data/watchedAddress.dart';
import 'package:nyzo_wallet/Widgets/TransactionsWidget.dart';
import 'package:nyzo_wallet/Widgets/verifierDialog.dart';

import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:nyzo_wallet/Data/Transaction.dart';
import 'package:nyzo_wallet/Activities/SendWindow.dart';
import 'package:nyzo_wallet/Data/Contact.dart';
import 'package:nyzo_wallet/Activities/ContactsWindow.dart';
import 'package:unicorndial/unicorndial.dart';

class WalletWindow extends StatefulWidget {
  final _password;
  WalletWindow(this._password);
  @override
  WalletWindowState createState() => WalletWindowState(_password);
}

class WalletWindowState extends State<WalletWindow> {
  bool lightTheme = true;
  WalletWindowState(this.password);
  List<List<String>> balanceList = [];
  List<Widget> _pageOptions = [
    ContactsWindow(_contactsList),
    TranSactionsWidget(null),
    SettingsWindow(),
  ];
  List<WatchedAddress> addressesToWatch;
  String password;
  double screenHeight;
  VerifiersWindow verifiersWindow;
  TranSactionsWidget tranSactionsWidgetInstance = TranSactionsWidget(null);
  int balance = 0;
  String _address = '';
  static List<Transaction> transactions;
  static List<Contact> _contactsList;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var f = new NumberFormat("###.0#", "en_US");
  bool _compactFormat = true;
  int pageIndex = 0;
  SendWindow sendWindowInstance;
  List<Verifier> verifiersList;
  bool sentinels = false;

  final textControllerAmount = new TextEditingController();
  final textControllerAddress = new TextEditingController();
  final textControllerData = new TextEditingController();
  final amountFormKey = new GlobalKey<FormFieldState>();
  final addressFormKey = new GlobalKey<FormFieldState>();
  final dataFormKey = new GlobalKey<FormFieldState>();

  AddVerifierDialog floatingdialog = AddVerifierDialog();

  @override
  void initState() {
    getSavedBalance().then((double _balance){
      setState(() {
      balance = _balance.floor();  
      });
      
    });
    verifiersWindow = VerifiersWindow(this);
    getBalanceList().then((List<List<String>> _balanceList) {
      balanceList = _balanceList;
      getWatchAddresses().then((List<WatchedAddress> _list) {
        setState(() {
          addressesToWatch = _list;
      for (var eachAddress in addressesToWatch) {
        eachAddress.balance = balanceList.firstWhere((List<String> address) {
          return address[0] == eachAddress.address;
        })[1];
      }
        });
      
    });
    });

    watchSentinels().then((bool val) {
      setState(() {
        sentinels = val;
      });
    });
    getAddress().then((address) {
      //load the address from disk
      setState(() {
        _address = address;
        sendWindowInstance = new SendWindow(password, _address);

        getBalance(_address).then((_balance) {
          //get the balance value from the network
          setState(() {
            balance = _balance;
            setSavedBalance(double.parse(balance.toString())); //set the balance
          });
          getTransactions(_address).then((List transactions) {
            transactions = transactions;
            getVerifiers().then((List<Verifier> _verifiersList) {
              setState(() {
                verifiersList = _verifiersList;
              });
            });
          });
        }); //set the address
      });
      getContacts().then((contactList) {
        _contactsList = contactList;
      });
    });

    super.initState();

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    //prevent the screen from rotating
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  changeFormat() {
    setState(() {
      _compactFormat = !_compactFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Add verifier",
        currentButton: FloatingActionButton(
          heroTag: "verifier",
          backgroundColor: lightTheme ? Colors.white : Colors.black,
          mini: true,
          child: Container(
              margin: EdgeInsets.all(8),
              child: Image.asset(
                "images/normal.png",
                color: lightTheme ? Colors.black : Colors.white,
              )),
          onPressed: () {
            floatingdialog.information(context, "Add to Watch List", true,
                onClose: () {
              getVerifiers().then((List<Verifier> _verifiersList) {
                setState(() {
                  verifiersList = _verifiersList;
                });
              });
            });
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Add address",
        currentButton: FloatingActionButton(
          heroTag: "address",
          backgroundColor: lightTheme ? Colors.white : Colors.black,
          mini: true,
          child: Icon(
            Icons.account_balance_wallet,
            color: lightTheme ? Colors.black : Colors.white,
          ),
          onPressed: () {
            setState(() {
              floatingdialog.information(context, "Add to Watch List", false,
                  onClose: () {
                getWatchAddresses().then((List<WatchedAddress> _list) {
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
          },
        )));
    return WillPopScope(
      // widget to control the moving between activities
      onWillPop: () async =>
          false, //don't let the user go back to the previous activity
      child: Scaffold(
        floatingActionButtonAnimator: NoScalingAnimation(),
        floatingActionButton: sentinels
            ? pageIndex == 3
                ? UnicornDialer(
                    parentHeroTag: "ParenTagg",
                    childButtons: childButtons,
                    parentButtonBackground: lightTheme ? Colors.white : Colors.black,
                    backgroundColor: Colors.black12,
                    finalButtonIcon: Icon(
                      Icons.close,
                      color:lightTheme ? Colors.black : Colors.white,
                    ),
                    parentButton: Container(
                        margin: EdgeInsets.all(15),
                        child: Icon(
                          Icons.add,
                          color:lightTheme ? Colors.black : Colors.white,
                        )),
                  )
                : null
            : null,
        //resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: lightTheme ? Colors.white:   Colors.black,
        bottomNavigationBar: TitledBottomNavigationBar(
          indicatorColor: lightTheme ? Colors.black:Colors.white,
          inactiveColor: lightTheme ? Colors.black : Colors.white,
            activeColor: lightTheme ? Colors.black : Colors.white,
            reverse: true,
            initialIndex: 0,
            currentIndex:
                pageIndex, // Use this to update the Bar giving a position
            onTap: (index) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                pageIndex = index;
              });
            },
            items: sentinels
                ? [
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'History',
                        icon: Icons.history),
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'Contacts',
                        icon: Icons.contacts),
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'Transfer',
                        icon: Icons.send),
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'Verifiers',
                        icon: Icons.remove_red_eye),
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'Settings',
                        icon: Icons.settings),
                  ]
                : [
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'History',
                        icon: Icons.history),
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'Contacts',
                        icon: Icons.contacts),
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'Transfer',
                        icon: Icons.send),
                    TitledNavigationBarItem(
                        backgroundColor: lightTheme ? Colors.white : Colors.black,
                        title: 'Settings',
                        icon: Icons.settings),
                  ]),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                    child: Opacity(
                        opacity: pageIndex == 0 ? 1.0 : 0.0,
                        child: IgnorePointer(
                            child: tranSactionsWidgetInstance,
                            ignoring: pageIndex != 0)),
                  ),
                  Positioned(
                    child: Opacity(
                        opacity: pageIndex == 1 ? 1.0 : 0.0,
                        child: IgnorePointer(
                            child: _pageOptions[0], ignoring: pageIndex != 1)),
                  ),
                  Positioned(
                    child: Opacity(
                        opacity: pageIndex == 2 ? 1.0 : 0.0,
                        child: IgnorePointer(
                            child: sendWindowInstance,
                            ignoring: pageIndex != 2)),
                  ),
                  Positioned(
                    child: Opacity(
                        opacity: sentinels
                            ? pageIndex == 4 ? 1.0 : 0.0
                            : pageIndex == 3 ? 1.0 : 0.0,
                        child: IgnorePointer(
                            child: _pageOptions[2],
                            ignoring:
                                sentinels ? pageIndex != 4 : pageIndex != 3)),
                  ),
                  Positioned(
                    child: Opacity(
                        opacity: sentinels
                            ? pageIndex == 3 ? 1.0 : 0.0
                            : pageIndex == 4 ? 1.0 : 0.0,
                        child: IgnorePointer(
                            child: VerifiersWindow(this),
                            ignoring:
                                sentinels ? pageIndex != 3 : pageIndex != 4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//List<BottomNavigationDotBarItem> navItemList = [];
