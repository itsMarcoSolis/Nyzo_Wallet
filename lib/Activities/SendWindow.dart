import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';

class SendWindow extends StatelessWidget {
  SendWindow(this.password, this.address);

  final String password;
  final String address;

  @override
  Widget build(BuildContext context) {
    WalletWindowState walletWindowState =
        context.ancestorStateOfType(TypeMatcher<WalletWindowState>());
    print(walletWindowState.balance.toString());
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Sending from",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          RaisedButton(
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: address));
              final snackBar =
                  SnackBar(content: Text('Address copied to clipboard'));
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Text(
              address != ""
                  ? address.substring(0, 4) +
                      "..." +
                      address.substring(address.length - 10)
                  : "Loading address...",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
            ),
            child: TextFormField(
              key: walletWindowState.amountFormKey,
              controller: walletWindowState.textControllerAmount,
              keyboardType: TextInputType.number,
              maxLines: 1,
              maxLength: 20,
              validator: (String val) =>
                  double.parse(walletWindowState.textControllerAmount.text)
                                  .toInt() *
                              1000000 >=
                          walletWindowState.balance
                      ? "You don't have enough Nyzo."
                      : null,
              style: TextStyle(color: Color(0xFF500000)),
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(color: Color(0xFF500000)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
            ),
            child: TextFormField(
              key: walletWindowState.addressFormKey,
              controller: walletWindowState.textControllerAddress,
              maxLines: 3,
              maxLength: 67,
              validator: (String val) => val.contains(RegExp(r'[g-z]')) ||
                      !(val.length == 67 || val.length == 64)
                  ? "Invalid Nyzo address."
                  : null,
              style: TextStyle(color: Color(0xFF500000)),
              decoration: InputDecoration(
                labelText: "Address",
                labelStyle: TextStyle(color: Color(0xFF500000)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
            ),
            child: TextFormField(
              key: walletWindowState.dataFormKey,
              controller: walletWindowState.textControllerData,
              maxLength: 32,
              style: TextStyle(color: Color(0xFF500000)),
              decoration: InputDecoration(
                labelText: "Data",
                labelStyle: TextStyle(color: Color(0xFF500000)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.15,
                    right: MediaQuery.of(context).size.width * 0.15,
                  ),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Color(0xFF500000),
                    textColor: Colors.white,
                    child: Text("Send"),
                    onPressed: () {
                      //var dataForm = dataFormKey.currentState;
                      var addressForm =
                          walletWindowState.addressFormKey.currentState;
                      var amountForm =
                          walletWindowState.amountFormKey.currentState;
                      if (addressForm.validate() && amountForm.validate()) {
                        var address = walletWindowState
                            .textControllerAddress.text
                            .split('-')
                            .join('');
                        send(
                                password,
                                address,
                                (double.parse(walletWindowState
                                            .textControllerAmount.text) *
                                        1000000)
                                    .toInt(),
                                walletWindowState.balance,
                                walletWindowState.textControllerData.text)
                            .then((String result) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Transaction state:",
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: Text(result),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        });
                        walletWindowState.textControllerAddress.clear();
                        walletWindowState.textControllerAmount.clear();
                        walletWindowState.textControllerData.clear();
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
