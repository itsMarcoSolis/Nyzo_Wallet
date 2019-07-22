import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Activities/BackupSeed.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/homePage.dart';
import 'package:nyzo_wallet/Widgets/ColorTheme.dart';

class SettingsWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsWindowState();
}

class SettingsWindowState extends State<SettingsWindow> {
  WalletWindowState walletWindowState;

  bool _switchValue = false;
  bool _nigthMode = false;
  @override
  void initState() {
    walletWindowState =
        context.ancestorStateOfType(TypeMatcher<WalletWindowState>());
    watchSentinels().then((bool val) {
      setState(() {
        _switchValue = val;
      });
    });
    getNightModeValue().then((bool value) {
      setState(() {
        _nigthMode = value;
      });
    });
    super.initState();
  }

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
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Center(
            child: Text(
              'Settings',
              style: TextStyle(
                  color: ColorTheme.of(context).secondaryColor,
                  fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                          fontSize: 35),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Container(
                    decoration: BoxDecoration(
                        color: ColorTheme.of(context).baseColor,
                        borderRadius: BorderRadius.circular(5000),
                        border: Border.all(color: Color(0xFF666666))),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Backup Wallet Seed",
                        style: TextStyle(
                            color: ColorTheme.of(context).secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                  decoration: BoxDecoration(
                      color: ColorTheme.of(context).baseColor,
                      borderRadius: BorderRadius.circular(5000),
                      border: Border.all(color: Color(0xFF666666))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Delete Wallet",
                      style: TextStyle(
                          color: ColorTheme.of(context).secondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorTheme.of(context).baseColor,
                  borderRadius: BorderRadius.circular(5000),
                  border: Border.all(color: Color(0xFF666666))),
              child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      leading: Text(
                        "Watch Sentinels",
                        style: TextStyle(
                            color: ColorTheme.of(context).secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      trailing: Switch(
                        inactiveTrackColor: ColorTheme.of(context).transparentColor,
                        activeColor: ColorTheme.of(context).secondaryColor,
                        value: _switchValue,
                        onChanged: (bool val) {
                          if (val) {
                            setState(() {
                              _switchValue = val;
                            });
                            setWatchSentinels(val);
                            walletWindowState.setState(() {
                              walletWindowState.sentinels = true;
                              walletWindowState.pageIndex = 4;
                            });
                          } else {
                            setState(() {
                              _switchValue = val;
                            });
                            setWatchSentinels(val);
                            walletWindowState.setState(() {
                              walletWindowState.sentinels = false;
                              walletWindowState.pageIndex = 3;
                            });
                          }
                        },
                      ),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorTheme.of(context).baseColor,
                  borderRadius: BorderRadius.circular(5000),
                  border: Border.all(color: Color(0xFF666666))),
              child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      leading: Text(
                        "Night  Mode",
                        style: TextStyle(
                            color: ColorTheme.of(context).secondaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      trailing: Switch(
                        inactiveTrackColor: ColorTheme.of(context).transparentColor,
                        activeColor: ColorTheme.of(context).secondaryColor,
                        value: _nigthMode,
                        onChanged: (bool val) {
                          ColorTheme colorTheme = ColorTheme.of(context);
                          if (val) {
                            setState(() {
                              _nigthMode = val;
                              
                            });
                            setNightModeValue(val);

                            colorTheme.update();
                          } else {
                            setState(() {
                              _nigthMode = val;
                            });
                            setNightModeValue(val);

                            colorTheme.update();
                          }
                        },
                      ),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorTheme.of(context).baseColor,
                  borderRadius: BorderRadius.circular(5000),
                  border: Border.all(color: Color(0xFF666666))),
              child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Beta v0.1 ",
                      style: TextStyle(
                          color: ColorTheme.of(context).secondaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Made with ",
                  style: TextStyle(
                    color: ColorTheme.of(context).secondaryColor,
                  ),
                ),
                new Icon(
                  Icons.favorite,
                  color: ColorTheme.of(context).secondaryColor,
                  size: 15,
                ),
                new Text(" for the community.",
                    style: TextStyle(
                        color: ColorTheme.of(context).secondaryColor))
              ],
            ),
          )
        ],
      ),
    );
  }
}
