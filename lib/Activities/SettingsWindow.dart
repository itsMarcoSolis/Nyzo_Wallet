import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Activities/BackupSeed.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/homePage.dart';

class SettingsWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Text(
            "Settings",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          InkWell(
            onTap: () {
              WalletWindowState foldingCellState =
                  context.ancestorStateOfType(TypeMatcher<WalletWindowState>());
              print(foldingCellState.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BackUpSeed(foldingCellState.password)),
              );
            },
            child: Card(
              color: Color(0xFF500000),
              child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Backup Wallet Seed"),
                  )),
            ),
          ),
          Card(
            color: Color(0xFF500000),
            child: InkWell(
              onTap: () {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "DELETE WALLET",
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Text(
                          "You will lose all your Nyzo if you don't have a backup of your seed. \n \nDo you want to continue?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text("DELETE MY WALLET"),
                          onPressed: () {
                            Navigator.pop(context);
                            deleteWallet();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Delete Wallet"),
                ),
                width: double.infinity,
              ),
            ),
          ),
          Card(
            color: Color(0xFF500000),
            child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Alpha v0.1.2 "),
                )),
          ),
          Expanded(
            child: Container(),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Made with ",
                style: TextStyle(color: Colors.black),
              ),
              new Icon(Icons.favorite, color: Colors.black),
              new Text(" for the community.",
                  style: TextStyle(color: Colors.black))
            ],
          )
        ],
      ),
    );
  }
}
