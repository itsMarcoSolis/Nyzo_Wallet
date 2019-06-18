import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:nyzo_wallet/Activities/WalletWindow.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _storage = new FlutterSecureStorage();
  var _localAuth = new LocalAuthentication();
  final textController = new TextEditingController();

  @override
  void initState() {
    try {
      Future didAuthenticate = _localAuth.authenticateWithBiometrics(
          localizedReason: 'Please authenticate to show your account.');
      didAuthenticate.then((value) {
        if (value) {
          Future salt = _storage.read(key: "Password");
          salt.then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WalletWindow(
                        value,
                      )),
            );
          });
        }
      });
      super.initState();
      //prevent the screen from rotating
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
      } else if (e.code == auth_error.notEnrolled) {
      } else if (e.code == auth_error.passcodeNotSet) {
      } else if (e.code == auth_error.otherOperatingSystem) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: new Center(
          child: new Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 125.0, 0.0, 75.0),
                  child: InkWell(
                    onTap: () {
                      try {
                        Future didAuthenticate =
                            _localAuth.authenticateWithBiometrics(
                                localizedReason:
                                    'Please authenticate to show your account.');
                        didAuthenticate.then((value) {
                          if (value) {
                            Future salt = _storage.read(key: "Password");
                            salt.then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WalletWindow(
                                          value,
                                        )),
                              );
                            });
                          }
                        });
                      } on PlatformException catch (e) {
                        if (e.code == auth_error.notAvailable) {
                        } else if (e.code == auth_error.notEnrolled) {
                        } else if (e.code == auth_error.passcodeNotSet) {
                        } else if (e.code == auth_error.otherOperatingSystem) {}
                      }
                    },
                    child: Icon(Icons.fingerprint,
                        size: 75.0, color: Color(0XFFD42D72)),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text("Enter your Password to unlock your Wallet",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21.0,
                          )),
                      new SizedBox(
                        height: 40.0,
                      ),
                      new TextFormField(
                        onFieldSubmitted: (text) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletWindow(
                                      text,
                                    )),
                          );
                        },
                        autocorrect: false,
                        autofocus: false,
                        obscureText: true,
                        controller: textController,
                        decoration: new InputDecoration(
                          labelText: "Password",
                        ),
                      ),
                      new Expanded(
                        child: new Container(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
