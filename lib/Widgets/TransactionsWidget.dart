import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Data/Contact.dart';
import 'package:nyzo_wallet/Data/Transaction.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';

class TranSactionsWidget extends StatefulWidget {
  final _transactions;
  TranSactionsWidget(this._transactions);
  @override
  TranSactionsWidgetState createState() =>
      TranSactionsWidgetState(_transactions);
}

class TranSactionsWidgetState extends State<TranSactionsWidget> {
  List<Transaction> _transactions;
  TranSactionsWidgetState(this._transactions);
  String _address = '';
  List<Contact> _contactsList;
  WalletWindowState walletWindowState;
  int balance = 0;
  
  @override
  void initState() {
    getSavedBalance().then((double _balance){
      setState(() {
        
      balance = _balance.floor();  
      
      });
      
    });

    walletWindowState =
        context.ancestorStateOfType(TypeMatcher<WalletWindowState>());
    getAddress().then((address) {
      _address = address;
      getTransactions(_address).then((List transactions) {
        setState(() {
          _transactions = transactions;
        });
      });
    });
    getContacts().then((List<Contact> contacts) {
      _contactsList = contacts;
    });
    super.initState();
  }

  Future<void> refresh() async {
    WalletWindowState walletWindowState =
        context.ancestorStateOfType(TypeMatcher<WalletWindowState>());
    Future transactions = getTransactions(_address);
    getBalance(_address).then((_balance) {
      walletWindowState.setState(() {
        walletWindowState.balance = _balance;
      });
    });
    transactions.then((ok) {
      setState(() {
        _transactions = ok;
      });
      //getBalance(_address).then((int balance){});
    });
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Center(
            child: Text(
              'History',
              style: TextStyle(
                color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                  fontWeight: FontWeight.w600, letterSpacing: 0, fontSize: 35),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Balance',
                      style: TextStyle(color: Color(0xFF555555), fontSize: 15),
                    ),
                    RichText(
                      text: TextSpan(
                        text: walletWindowState.balance == 0 ? balance.toString() : (walletWindowState.balance/1000000).toString(),
                        style: TextStyle(
                            color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 40),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ∩',
                            style: TextStyle(
                              color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                                fontWeight: FontWeight.w600, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Color(0xFF555555),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
            child: Text(
              'Transactions',
              style: TextStyle(color: Color(0xFF555555), fontSize: 15),
            ),
          ),
          Container(
            height: walletWindowState.screenHeight / 2,
            child: _transactions != null
                ? _transactions.length == 0
                    ? Center(
                        child: InkWell(
                          onTap: () {
                            refresh();
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/noTransactions.png",
                                  color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                                  height: walletWindowState.screenHeight / 5,
                                  //width: walletWindowState.screenHeight / 5 * 0.9,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Text("You don't have any transactions yet!",style:TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white, fontWeight: FontWeight.w600,fontSize: 15)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  
                                  child: Text("Try receiving some Nyzo.",textAlign: TextAlign.center,style:TextStyle(color: Color(0xFF666666), fontWeight: FontWeight.w400,fontSize: 15)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : LiquidPullToRefresh(
                        color: Color(0xFF403942),
                        height: 75,
                        showChildOpacityTransition: false,
                        springAnimationDurationInMilliseconds: 250,
                        child: ListView.builder(
                            padding: EdgeInsets.all(0.0),
                            itemCount: _transactions?.length,
                            itemBuilder: (context, i) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    leading: Container(
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        border: new Border.all(
                                          width: 1.0,
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                                      child: _transactions[i].type == "from"
                                          ? Icon(
                                              Icons.add,
                                              color: Color(0xFF555555),
                                            )
                                          : Icon(
                                              Icons.remove,
                                              color: Color(0xFF555555),
                                            ),
                                    ),
                                    title: _contactsList
                                                .firstWhere(
                                                    (Contact contact) =>
                                                        contact.address ==
                                                        splitJoinString(
                                                            _transactions[i]
                                                                .address),
                                                    orElse: () => null)
                                                .runtimeType ==
                                            Contact
                                        ? Text(_contactsList
                                            .lastWhere(
                                                (Contact contact) =>
                                                    contact.address ==
                                                    _transactions[i]
                                                        .address
                                                        .split('-')
                                                        .join(''),
                                                orElse: () => null)
                                            .name,style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white),)
                                        : Text(
                                            _transactions[i]
                                                    .address
                                                    .substring(0, 4) +
                                                "..." +
                                                _transactions[i]
                                                    .address
                                                    .substring(_transactions[i]
                                                            .address
                                                            .length -
                                                        4),
                                            style: TextStyle(
                                              color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                    trailing: Text(
                                      _transactions[i].amount.toString()+" ∩",
                                      style: TextStyle(
                                        color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ),
                                )),
                        onRefresh: () {
                          return refresh();
                        },
                      )
                : ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemCount: 8,
                    itemBuilder: (context, i) => Card(
                            child: SizedBox(
                          width: 200.0,
                          height: 60.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListTile(
                                leading: Container(
                                  color: Colors.green,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                    "                                                                        ",
                                    style: TextStyle(
                                        backgroundColor: Colors.grey)),
                              ),
                            ),
                          ),
                        ))),
          ),
        ],
      ),
    );
  }

  String splitJoinString(String address) {
    String val = address.split('-').join('');
    return val;
  }
}
