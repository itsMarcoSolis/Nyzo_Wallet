import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyzo_wallet/Activities/ImportWallet2.dart';

class ImportWalletScreen extends StatefulWidget {
  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  bool _isLoading = false;

  final privKeytextController = new TextEditingController();
  final formKey = new GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    //prevent the screen from rotating
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _performWalletCreation() {
    setState(() {
      _isLoading = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ImportWalletScreen2(privKeytextController.text)),
    );
    setState(() {
      _isLoading = false;
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
                      child: new Text("Paste your Private Key",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          )))),
              new TextFormField(
                key: formKey,
                autocorrect: false,
                autofocus: false,
                obscureText: true,
                maxLength: 67,
                controller: privKeytextController,
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  labelText: "Private Key",
                ),
                validator: (String val) => val.contains(RegExp(r'[g-z]')) ||
                        !(val.length == 67 || val.length == 64)
                    ? "Invalid private key."
                    : null,
              ),
              new SizedBox(
                height: 50.0,
              ),
              _isLoading
                  ? Center(
                      child: new CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation(Color(0XFFFFFFFF))))
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
                        child: new Text("Next"),
                      ),
                    ),
            ],
          ),
        ));
  }
}
