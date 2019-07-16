import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Data/Verifier.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Widgets/verifierDialog.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

class VerifiersWindow extends StatefulWidget {
  VerifiersWindow(this.walletWindowState);
  final WalletWindowState walletWindowState;
  @override
  _VerifiersWindowState createState() => _VerifiersWindowState();
}

class _VerifiersWindowState extends State<VerifiersWindow> {
  WalletWindowState walletWindowState;
  SlidableController slidableController = SlidableController();
  AddVerifierDialog floatingdialog = AddVerifierDialog();

  @override
  void initState() {
    walletWindowState = widget.walletWindowState;
    super.initState();
  }

  Future<void> refresh() async {
    Future<List<Verifier>> transactions = getVerifiers();
    transactions.then((List<Verifier> verifiersList) {
      walletWindowState.setState(() {
        walletWindowState.verifiersList = verifiersList;
      });
      //getBalance(_address).then((int balance){});
    });
    return transactions;
  }

  SliverPersistentHeader makeHeader(String headerText,var color) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 45.0,
        maxHeight: 70.0,
        child: Container(
            color: color,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    headerText,
                    style: TextStyle(
                        color: color == Colors.black ? Colors.white:Colors.black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        fontSize: 18),
                  ),
                ),
              ],
            ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Center(
          child: Text(
            'Watch List',
            style: TextStyle(
              color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                fontWeight: FontWeight.w600, letterSpacing: 0, fontSize: 35),
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              child: Stack(
                children: <Widget>[
              (walletWindowState.verifiersList != null &&  walletWindowState.addressesToWatch != null)
                      ? (walletWindowState.verifiersList.length != 0 ||  walletWindowState.addressesToWatch?.length != 0)
                          ? LiquidPullToRefresh(
                              color: Color(0xFF403942),
                              height: 75,
                              showChildOpacityTransition: false,
                              springAnimationDurationInMilliseconds: 250,
                              onRefresh: () {
                                return refresh(); 
                              },
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  (walletWindowState.verifiersList?.length != 0)
                                      ? makeHeader("Verifiers",walletWindowState.lightTheme ? Colors.white:Colors.black):SliverList(
                                          delegate: SliverChildListDelegate(
                                              [Container()])),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int i) =>
                                            Slidable(
                                              controller: slidableController,
                                              actionPane:
                                                  SlidableDrawerActionPane(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: ExpandablePanel(iconColor:
                                                  walletWindowState.lightTheme ? Colors.black:Colors.white,
                                                  header: walletWindowState
                                                        .verifiersList[i].inCicle ? ListTile(
                                                    leading: walletWindowState.lightTheme? walletWindowState
                                                        .verifiersList[i].iconBlack : walletWindowState
                                                        .verifiersList[i].iconWhite,
                                                    title: Text(
                                                        walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .nickname
                                                                .toString()
                                                            : walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .id,
                                                        style: walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? TextStyle(
                                                              color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                                                                fontSize: 20.0,
                                                              )
                                                            : TextStyle(

                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20.0,
                                                              )),
                                                              trailing: Container(
                                                                margin: EdgeInsets.all(MediaQuery.of(context).size.width/30),
                                                                child: Image.asset("images/cycle.png")),
                                                  ):ListTile(
                                                    leading: walletWindowState.lightTheme? walletWindowState
                                                        .verifiersList[i].iconBlack : walletWindowState
                                                        .verifiersList[i].iconWhite,
                                                    title: Text(
                                                        walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .nickname
                                                                .toString()
                                                            : walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .id,
                                                        style: walletWindowState
                                                                .verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? TextStyle(
                                                              color: walletWindowState.lightTheme ? Colors.black:Colors.white,
                                                                fontSize: 20.0,
                                                              )
                                                            : TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20.0,
                                                              )),
                                                              
                                                  ),
                                                  expanded: walletWindowState
                                                          .verifiersList[i]
                                                          .isValid
                                                      ? Container(
                                                        margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <Widget>[
                                                                Text("In cycle: ", style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .inCicle
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Open edge: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .openEdge
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Receiving UDP: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .receivingUDP
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Retention edge: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .retentionEdge
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Status: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .retentionEdge
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Trailing Edge: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                    .verifiersList[
                                                                        i]
                                                                    .trailingEdge
                                                                    .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Transactions: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .transactions
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Version : " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .version
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                           
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Balance: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .balance
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Blocks CT: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .blocksCT
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(

                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Text("Block Vote: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700,),
                                                                    ),
                                                                    walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .blockVote
                                                                        .toString().contains("other")? Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .blockVote
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white)): createColumn(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .blockVote
                                                                        .toString(),";")
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Cycle Length: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                    .verifiersList[
                                                                        i]
                                                                    .cycleLength
                                                                    .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Frozen Edge: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .frozenEdge
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("ID: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .id
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("IP Address: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .iPAddress
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Las Queried: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .lastQueried
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Last Removal Heigth: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .lastRemovalHeight
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Mesh: " , style: TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(walletWindowState
                                                                        .verifiersList[
                                                                            i]
                                                                        .mesh
                                                                        .toString(),style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white))
                                                              ],
                                                            ),
                                                            
                                                                
                                                          ],
                                                        ),)
                                                      : Center(
                                                          child: Text(
                                                            
                                                              "No known verifiers for id " +
                                                                  walletWindowState
                                                                      .verifiersList[
                                                                          i]
                                                                      .id,style:TextStyle(color: walletWindowState.lightTheme ? Colors.black:Colors.white,),),
                                                        ),
                                                ),
                                              ),
                                              secondaryActions: <Widget>[
                                                IconSlideAction(
                                                  caption: 'Delete',
                                                  color: walletWindowState.lightTheme ? Colors.white :Colors.black,
                                                  icon: Icons.delete,
                                                  onTap: () {
                                                    walletWindowState
                                                        .verifiersList
                                                        .removeAt(i);
                                                    setState(() {
                                                      saveVerifier(
                                                          walletWindowState
                                                              .verifiersList);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                        childCount: walletWindowState
                                            .verifiersList?.length),
                                  ),
                                  (walletWindowState.addressesToWatch?.length != 0)
                                      ? makeHeader("Addresses",walletWindowState.lightTheme ? Colors.white:Colors.black)
                                      : SliverList(
                                          delegate: SliverChildListDelegate(
                                              [Container()]),
                                        ),
                                  (walletWindowState.addressesToWatch?.length != 0)
                                      ? SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                              (BuildContext context, int i) =>
                                                  Slidable(
                                                    controller:
                                                        slidableController,
                                                    actionPane:
                                                        SlidableDrawerActionPane(),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5),
                                                        child: ListTile(
                                                          leading: Icon(Icons
                                                              .account_balance_wallet,color: walletWindowState.lightTheme ? Colors.black:Colors.white,),
                                                              trailing: Text(walletWindowState.addressesToWatch[i].balance,style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white),),
                                                          title: Text(
                                                              walletWindowState
                                                                      .addressesToWatch[
                                                                          i]
                                                                      .address
                                                                      .substring(
                                                                          0,
                                                                          4) +
                                                                  "..." +
                                                                  walletWindowState
                                                                      .addressesToWatch[
                                                                          i]
                                                                      .address
                                                                      .substring(
                                                                          walletWindowState.addressesToWatch[i].address.length -
                                                                              4),
                                                              style: walletWindowState
                                                                          .addressesToWatch[
                                                                              i]
                                                                          .balance !=
                                                                      null
                                                                  ? TextStyle(
                                                                    color:walletWindowState.lightTheme ? Colors.black:Colors.white,
                                                                      fontSize:
                                                                          20.0,
                                                                    )
                                                                  : TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          20.0,
                                                                    )),
                                                        )),
                                                    secondaryActions: <Widget>[
                                                      IconSlideAction(
                                                        caption: 'Delete',
                                                        color: walletWindowState.lightTheme ? Colors.white : Colors.black,
                                                        icon: Icons.delete,
                                                        onTap: () {
                                                          walletWindowState
                                                              .addressesToWatch
                                                              .removeAt(i);
                                                          setState(() {
                                                            saveWatchAddress(
                                                                walletWindowState
                                                                    .addressesToWatch);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                              childCount: walletWindowState
                                                  .addressesToWatch?.length),
                                        )
                                      : SliverList(
                                          delegate: SliverChildListDelegate(
                                              [Container()]))
                                ],
                              ))
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Image.asset(
                                    "images/noVerifiers.png",
                                    color:  walletWindowState.lightTheme ? Colors.black:Colors.white,
                                    height: walletWindowState.screenHeight / 6,
                                    //width: walletWindowState.screenHeight / 5 * 0.9,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    child: Text(
                                        "There is nothing on your Watch List!",
                                        style: TextStyle(
                                            color:  walletWindowState.lightTheme ? Colors.black:Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text(
                                        "Add something to the watch list using the button below.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF666666),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15)),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            )
                      : ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          itemCount: 8,
                          itemBuilder: (context, i) => Card(
                            color: walletWindowState.lightTheme ? Colors.white : Colors.black,
                                  child: SizedBox(
                                width: 200.0,
                                height: 60.0,
                                child: Shimmer.fromColors(
                                  baseColor: walletWindowState.lightTheme ? Colors.grey[300] : Colors.white30,
                                  highlightColor: walletWindowState.lightTheme ? Colors.grey[100] : Colors.white10,
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
                                          style: TextStyle(
                                              backgroundColor: Colors.grey)),
                                    ),
                                  ),
                                ),
                              ))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget createColumn(String string,String pattern){
    List list = string.split(pattern);
    List<Widget> widgetList = [];
    for (var eachColumn in list) {
      widgetList.add(Text(eachColumn,style: TextStyle(color: walletWindowState.lightTheme ? Colors.black : Colors.white)));
    }
    Column  column = Column(crossAxisAlignment: CrossAxisAlignment.start,children: widgetList,);
    
    return column;
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
