import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'Data/Wallet.dart';
import 'Activities/NewWallet.dart';
import 'Activities/AuthScreen.dart';
import 'Activities/ImportWallet.dart';

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  bool _walletCreated;
  bool _visibleButttons = false;
  changeStatusColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    checkWallet().then((bool flag) {
      _walletCreated = flag;
      _walletCreated
          ? setState(() {
              //if it does, go to the password activity
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            })
          : setState(() {
              _visibleButttons = true;
            });
    });
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    changeStatusColor(Colors.transparent);
    super.initState();
    //prevent the screen from rotating
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new Column(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 0.0),
                  child: new Image.asset(
                    "images/Logo.png",
                    width: 150.0,
                  )),
              new Padding(padding: EdgeInsets.symmetric(vertical: 30.0)),
              _visibleButttons
                  ? new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        new Padding(
                            padding: new EdgeInsets.symmetric(horizontal: 70.0),
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewWalletScreen()),
                                );
                              },
                              child: Text("Create new Wallet"),
                            )),
                        new Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0)),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 70.0),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImportWalletScreen()),
                                );
                              },
                            child: Text("Import Existing Wallet"),
                          ),
                        ),
                      ],
                    )
                  : new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Color(0XFFD42D72)),
                    ),
              new Expanded(
                child: new Container(),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Made with "),
                  new Icon(Icons.favorite, color: Color(0xFFFFFFFF)),
                  new Text(" for the community.")
                ],
              )
            ],
          ),
        ),
      )
    ;
  }
}
