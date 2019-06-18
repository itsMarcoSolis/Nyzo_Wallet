import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Activities/BackupSeed.dart';

class NewWalletScreen extends StatefulWidget {
  @override
  _NewWalletScreenState createState() => _NewWalletScreenState();
}

class _NewWalletScreenState extends State<NewWalletScreen> {
  bool _isLoading = false;
  final textController1 = new TextEditingController();
  final textController2 = new TextEditingController();
  final formKey = new GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    //prevent the screen from rotating
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    textController2.dispose();
    textController1.dispose();
    super.dispose();
  }

  void _performWalletCreation() {
    setState(() {
      _isLoading = true;
    });
    createNewWallet(textController1.text).then((onValue) {
      print(onValue);
      //onValue not used
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WalletWindow(textController1.text)),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BackUpSeed(textController1.text)),
      );

      ///this.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFF550000),
          leading: new IconButton(
            color: const Color(0xFFFFFFFF),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Center(
                      child: new Text("Set your Password",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          )))),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new TextFormField(
                    autocorrect: false,
                    autofocus: false,
                    obscureText: true,
                    controller: textController1,
                    style: TextStyle(color: Colors.white),
                    decoration: new InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  new TextFormField(
                    key: formKey,
                    autocorrect: false,
                    controller: textController2,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration:
                        new InputDecoration(labelText: "Confirm password"),
                    validator: (val) => val != textController1.text
                        ? "The passwords don't match"
                        : null,
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),
                  _isLoading
                      ? Center(
                          child: new CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation(
                                  Color(0XFFFFFFFF))))
                      : Center(
                          child: new RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              final form = formKey.currentState;
                              if (form.validate()) {
                                _performWalletCreation();
                              }
                            },
                            child: new Text("Create Wallet"),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ));
  }
}
