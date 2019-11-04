import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Data/AppLocalizations.dart';
import 'package:nyzo_wallet/Data/Verifier.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Data/watchedAddress.dart';

class AddVerifierDialog {
  static final TextEditingController nameController = TextEditingController();

  static final nameFormKey = GlobalKey<FormFieldState>();
  information(BuildContext context2, String title, bool isVerifier,
      {VoidCallback onClose}) {
    return showDialog(
        context: context2,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        isVerifier ? AppLocalizations.of(context).translate("String80") : 	AppLocalizations.of(context).translate("String9"),
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Container(
                    child: TextFormField(
                  validator: (String val) =>
                      val == '' ? 	AppLocalizations.of(context).translate("String67") : null,
                  key: nameFormKey,
                  controller: nameController, 
                  maxLength: isVerifier ? 9 : 67,
                  decoration: InputDecoration(

                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(color: Colors.red)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(color: Colors.red)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(color: Color(0x55666666))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(color: Color(0x55666666))),
                              contentPadding: EdgeInsets.all(10),
                              hasFloatingPlaceholder: false,
                              labelText: "",
                              labelStyle: TextStyle(
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                )),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(	AppLocalizations.of(context).translate("String34")),
                onPressed: () {
                  nameController.text = '';
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(	AppLocalizations.of(context).translate("String71")),
                onPressed: () async {
                  isVerifier ? addVerifier(
                      Verifier.fromId(
                        nameController.text,
                      )).then((s) {
                    onClose();
                    Navigator.pop(context);
                    nameController.text = '';
                  }):addWatchAddress(
                      WatchedAddress.fromAddress(
                        nameController.text.split("-").join(),
                      )).then((s) {
                    onClose();
                    Navigator.pop(context);
                    nameController.text = '';
                  });
                },
              ),
            ],
          );
        });
  }
}
