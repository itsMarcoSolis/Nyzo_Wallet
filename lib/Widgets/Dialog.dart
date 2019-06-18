import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Data/Contact.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';

class AddContactDialog {
  static final List<Contact> contatList = [];
  static final TextEditingController addressController =
      new TextEditingController();
  static final TextEditingController nameController =
      new TextEditingController();
  static final TextEditingController dataController =
      new TextEditingController();
  static final addressFormKey = new GlobalKey<FormFieldState>();
  static final dataFormKey = new GlobalKey<FormFieldState>();
  static final nameFormKey = new GlobalKey<FormFieldState>();
  information(BuildContext context2, String title, List<Contact> contactList,
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
            content: Container(
                child: TextFormField(
              validator: (String val) =>
                  val == '' ? "This field can't be empty." : null,
              key: nameFormKey,
              controller: nameController,
              maxLength: 24,
              style: TextStyle(color: Color(0xFF500000)),
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Color(0xFF500000)),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            )),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  nameController.text = '';
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Next"),
                onPressed: () {
                  if (nameFormKey.currentState.validate()) {
                    Navigator.pop(context);
                    address(context2, "Add Contact", contactList,
                        onClose: onClose);
                  }
                },
              ),
            ],
          );
        });
  }

  address(BuildContext context2, String title, List<Contact> contactList,
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
            content: TextFormField(
              key: addressFormKey,
              controller: addressController,
              maxLines: 3,
              maxLength: 67,
              validator: (String val) => (val.contains(RegExp(r'[g-z]')) ||
                          !(val.length == 67 || val.length == 64)) ||
                      val == ''
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
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  nameController.text = '';
                  addressController.text = '';
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Next"),
                onPressed: () {
                  var addressForm = addressFormKey.currentState;
                  if (addressForm.validate()) {
                    Navigator.pop(context);
                    data(context2, "Add Contact", contactList,
                        onClose: onClose);
                  }
                },
              ),
            ],
          );
        });
  }

  data(BuildContext context2, String title, List<Contact> contactList,
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
            content: TextFormField(
              key: dataFormKey,
              controller: dataController,
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
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  nameController.text = '';
                  addressController.text = '';
                  dataController.text = '';
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Add"),
                onPressed: () async {
                  addContact(
                          contactList,
                          new Contact(addressController.text,
                              nameController.text, dataController.text))
                      .then((s) {
                    onClose();
                    Navigator.pop(context);
                    nameController.text = '';
                    addressController.text = '';
                    dataController.text = '';
                  });
                },
              ),
            ],
          );
        });
  }
}
