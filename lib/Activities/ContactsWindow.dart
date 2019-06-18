import 'package:flutter/material.dart';
import 'package:nyzo_wallet/Data/Contact.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:nyzo_wallet/Widgets/Dialog.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';

class ContactsWindow extends StatefulWidget {
  final List<Contact> _contacts;
  ContactsWindow(this._contacts);
  @override
  ContactsWindowState createState() => ContactsWindowState(_contacts);
}

class ContactsWindowState extends State<ContactsWindow> {
  ContactsWindowState(this.contactsList);
  List<Contact> contactsList;
  final SlidableController slidableController = SlidableController();
  AddContactDialog floatingdialog = new AddContactDialog();

  @override
  void initState() {
    getContacts().then((List<Contact> contactList) {
      setState(() {
        contactsList = contactList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WalletWindowState walletWindowState =
        context.ancestorStateOfType(TypeMatcher<WalletWindowState>());
    return Container(
      child: Stack(
        children: <Widget>[
          contactsList != null
              ? contactsList.length != 0
                  ? ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: contactsList?.length,
                      itemBuilder: (context, i) => Slidable(
                            controller: slidableController,
                            actionPane: SlidableDrawerActionPane(),
                            child: SimpleFoldingCell(
                                frontWidget: _buildFrontWidget(i),
                                innerTopWidget: _buildInnerTopWidget(i),
                                innerBottomWidget: _buildInnerBottomWidget(i),
                                cellSize:
                                    Size(MediaQuery.of(context).size.width, 75),
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                animationDuration: Duration(milliseconds: 300),
                                borderRadius: 0,
                                onOpen: () {},
                                onClose: () => print('cell closed')),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Send',
                                color: Colors.white,
                                icon: Icons.send,
                                onTap: () {
                                  walletWindowState.textControllerAddress.text =
                                      contactsList[i].address;
                                  walletWindowState.textControllerData.text =
                                      contactsList[i].notes;
                                  walletWindowState.setState(() {
                                    walletWindowState.pageIndex = 2;
                                  });
                                },
                              )
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.white,
                                icon: Icons.delete,
                                onTap: () {
                                  contactsList.removeAt(i);
                                  setState(() {
                                    saveContacts(contactsList);
                                  });
                                },
                              ),
                            ],
                          ))
                  : Center(
                      child: Text(
                        "No contacts to show! Try sending some using the button below.",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    )
              : ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemCount: 8,
                  itemBuilder: (context, i) => Card(
                          child: SizedBox(
                        width: 200.0,
                        height: 60.0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: Container(
                                color: Colors.green,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(
                                  "                                                                        ",
                                  style:
                                      TextStyle(backgroundColor: Colors.grey)),
                            ),
                          ),
                        ),
                      ))),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 30,
            right: MediaQuery.of(context).size.height / 30,
            child: FloatingActionButton(
              backgroundColor: Colors.white54,
              foregroundColor: Colors.white,
              onPressed: () {
                floatingdialog.information(context, "Add Contact", contactsList,
                    onClose: () {
                  getContacts().then((List<Contact> _contactList) {
                    setState(() {
                      contactsList = _contactList;
                    });
                  });
                });
                //contactsList.add(addcontact);
              },
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFrontWidget(int index) {
    return Builder(
      builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            SimpleFoldingCellState foldingCellState = context
                .ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());

            foldingCellState?.toggleFold();
          },
          child: Card(
              color: Color(0xFF500000),
              child: Container(
                alignment: Alignment.center,
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text(contactsList[index].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                ),
              )),
        );
      },
    );
  }

  Widget _buildInnerTopWidget(int index) {
    return Builder(
      builder: (BuildContext context) {
        return Card(
            color: Color(0xEEFFFFFF),
            child: Stack(
              children: <Widget>[
                Positioned(
                    right: 5.0,
                    top: 5.0,
                    child: Container(
                      width: 25.0,
                      height: 25.0,
                      child: RawMaterialButton(
                        onPressed: () {
                          SimpleFoldingCellState foldingCellState =
                              context.ancestorStateOfType(
                                  TypeMatcher<SimpleFoldingCellState>());
                          foldingCellState?.toggleFold();
                        },
                        shape: CircleBorder(),
                        elevation: 0,
                        child: Icon(
                          Icons.close,
                          size: 15,
                        ),
                      ),
                    )),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                    child: Text(contactsList[index].address,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        )),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget _buildInnerBottomWidget(int index) {
    return Builder(builder: (context) {
      return Card(
        color: Color(0xEEFFFFFF),
        child: Container(
          alignment: Alignment.center,
          child: TextFormField(
            initialValue: contactsList[index].notes,
            textAlign: TextAlign.center,
            onFieldSubmitted: (String newData) {
              contactsList[index].notes = newData;
              saveContacts(contactsList);
              getContacts().then((List<Contact> _contactList) {
                setState(() {
                  contactsList = _contactList;
                });
              });
            },
          ),
        ),
      );
    });
  }
}
