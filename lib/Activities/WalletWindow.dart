import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Activities/SettingsWindow.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:flutter/services.dart';
import 'package:nyzo_wallet/Widgets/TransactionsWidget.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nyzo_wallet/Data/Transaction.dart';
import 'package:nyzo_wallet/Activities/SendWindow.dart';
import 'package:nyzo_wallet/Data/Contact.dart';
import 'package:nyzo_wallet/Activities/ContactsWindow.dart';

class WalletWindow extends StatefulWidget {
  final _password;
  WalletWindow(this._password);
  @override
  WalletWindowState createState() => WalletWindowState(_password);
}

class WalletWindowState extends State<WalletWindow> {
  WalletWindowState(this.password);

  static int _nyzoColor = 0xFF500000;
  List<Widget> _navItemList = [
    Icon(Icons.history, color: Color(_nyzoColor)),
    Icon(Icons.contacts, color: Color(_nyzoColor)),
    Icon(Icons.send, color: Color(_nyzoColor)),
    Icon(Icons.settings, color: Color(_nyzoColor)),
  ];
  String password;
  double _screenHeight;
  double _screenWidth;
  List<Widget> _pageOptions = [
    ContactsWindow(_contactsList),
    TranSactionsWidget(null),
    SettingsWindow(),
  ];
  TranSactionsWidget tranSactionsWidgetInstance = TranSactionsWidget(null);
  int balance = 70;
  String _address = '';
  static List<Transaction> transactions;
  static List<Contact> _contactsList;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var f = new NumberFormat("###.0#", "en_US");
  bool _compactFormat = true;
  int pageIndex = 0;
  SendWindow sendWindowInstance;
  CurvedNavigationBar navBar;

  

  @override
  void initState() {
    sendWindowInstance = new SendWindow(password,  _address);
    super.initState();
    
    getAddress().then((address) {
      //load the address from disk
      setState(() {
        _address = address;
        getBalance(_address).then((_balance) {
          //get the balance value from the network
          setState(() {
            balance = _balance; //set the balance
          });
          getTransactions(_address).then((List transactions) {
            transactions = transactions;
          });
        }); //set the address
      });
      getContacts().then((contactList) {
        _contactsList = contactList;
      });
    });
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
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    navBar = new CurvedNavigationBar(
          height: _screenHeight/14,
          index: 0,
          backgroundColor: Color(_nyzoColor),
          items: _navItemList,
          onTap: (int index) {
            setState(() {
              print("index: " + index.toString());
              pageIndex = index;
              print("Page index: " + pageIndex.toString());
            });
          },
        );
    
    return WillPopScope(
      // widget to control the moving between activities
      onWillPop: () async =>
          false, //don't let the user go back to the previous activity
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Color(0xFFFFFFFF),
        bottomNavigationBar: navBar,
        body: Container(
          color: Color(_nyzoColor),
          child: Center(
            child: new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Card(
                    color: Color(_nyzoColor),
                    elevation: 50.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                            bottomRight: Radius.circular(_screenWidth / 2),
                            bottomLeft: Radius.circular(_screenWidth / 2))),
                    margin: EdgeInsets.all(0.0),
                    child: Container(
                      width: _screenWidth,
                      height: _screenHeight / 3.8,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                              padding: EdgeInsets.all(_screenHeight / 25)),
                          new Image.asset(
                            "images/Logo.png",
                            width: 120.0,
                          ),
                          new Padding(
                              padding: EdgeInsets.all(_screenHeight / 50)),
                          new InkWell(
                            highlightColor: Color(_nyzoColor),
                            splashColor: Color(_nyzoColor),
                            child: _compactFormat
                                ? Text(
                                    NumberFormat.compact()
                                            .format(balance / 1000000) +
                                        ' ∩',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.0),
                                  )
                                : new Text(
                                    (balance / 1000000).toString() + ' ∩',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.0),
                                  ),
                            onTap: () {
                              setState(() {
                                _compactFormat = !_compactFormat;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(_screenHeight / 500)),
                  Expanded(
                    child: Card(
                        color: Colors.white,
                        child: Stack(
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
                                      child: _pageOptions[0],
                                      ignoring: pageIndex != 1)),
                            ),
                            Positioned(
                              child: Opacity(
                                  opacity: pageIndex == 2 ? 1.0 : 0.0,
                                  child: IgnorePointer(
                                      child:
                                          sendWindowInstance,
                                      ignoring: pageIndex != 2)),
                            ),
                            Positioned(
                              child: Opacity(
                                  opacity: pageIndex == 3 ? 1.0 : 0.0,
                                  child: IgnorePointer(
                                      child: _pageOptions[2],
                                      ignoring: pageIndex != 3)),
                            ),
                          ],
                        )),
                  ),
                  Padding(padding: EdgeInsets.all(_screenHeight / 200)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
