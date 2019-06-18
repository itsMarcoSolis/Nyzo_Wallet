import 'package:flutter/material.dart';
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

  @override
  void initState() {
    getAddress().then((address) {
      _address = address;
      getTransactions(_address).then((List transactions) {
        setState(() {
          _transactions = transactions;
        });
      });
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
    print("transactionsss" + _transactions.runtimeType.toString());
    return Container(
      child: _transactions != null
          ? _transactions.length == 0
              ? Center(
                  child: Text(
                    "No transactions to show! Try sending or receiving some nyzo.",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                )
              : LiquidPullToRefresh(
                  height: 75,
                  showChildOpacityTransition: false,
                  springAnimationDurationInMilliseconds: 250,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemCount: _transactions?.length,
                    itemBuilder: (context, i) => Card(
                          color: Color(0xFF500000),
                          child: ListTile(
                            leading: _transactions[i].type == "from"
                                ? Icon(
                                    Icons.add,
                                    color: Colors.greenAccent,
                                  )
                                : Icon(Icons.remove, color: Colors.redAccent),
                            title: new Text(
                              _transactions[i].address.substring(0, 4) +
                                  "..." +
                                  _transactions[i].address.substring(
                                      _transactions[i].address.length - 10),
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Text(
                              _transactions[i].ammount.toString() + ' ∩',
                            ),
                          ),
                        ),
                  ),
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
                              style: TextStyle(backgroundColor: Colors.grey)),
                        ),
                      ),
                    ),
                  ))),
    );
  }
}
