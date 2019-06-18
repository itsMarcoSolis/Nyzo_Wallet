import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:flutter/services.dart';

class BackUpSeed extends StatefulWidget {
  BackUpSeed(this._password);
  final String _password;
  @override
  _BackUpSeedState createState() => _BackUpSeedState(_password);
}

class _BackUpSeedState extends State<BackUpSeed> {
  _BackUpSeedState(this._password);
  final String _password;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _privKey = "";
  @override
  void initState() {
    getPrivateKey(_password).then((String privKey) {
      setState(() {
        _privKey = privKey;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: new Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Center(
                      child: new Text("Backup your private key",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          )))),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Clipboard.setData(new ClipboardData(text: _privKey));
                          final snackBar = SnackBar(
                              content: Text('Address copied to clipboard'));

                          _scaffoldKey.currentState..showSnackBar(snackBar);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _privKey,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 100.0),
                    child: Text(
                      "Tap to copy",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text("Got it!"),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
