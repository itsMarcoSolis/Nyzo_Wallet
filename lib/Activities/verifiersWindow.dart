import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nyzo_wallet/Activities/WalletWindow.dart';
import 'package:nyzo_wallet/Data/Verifier.dart';
import 'package:nyzo_wallet/Data/Wallet.dart';
import 'package:nyzo_wallet/Widgets/ColorTheme.dart';
import 'package:nyzo_wallet/Widgets/verifierDialog.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

class VerifiersWindow extends StatefulWidget {
  
  
  @override
  _VerifiersWindowState createState() => _VerifiersWindowState();
}

class _VerifiersWindowState extends State<VerifiersWindow> {
  WalletWindowState walletWindowState;
  SlidableController slidableController = SlidableController();
  AddVerifierDialog floatingdialog = AddVerifierDialog();

  @override
  void initState() {
     walletWindowState=context.ancestorStateOfType(TypeMatcher<WalletWindowState>());
    super.initState();
  }

  Future<void> refresh() async {
    Future<List<Verifier>> updateFuture = ColorTheme.of(context).updateVerifiers();
    ColorTheme.of(context).getBalanceList();
    return updateFuture;
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
              color: ColorTheme.of(context).secondaryColor,
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
              (ColorTheme.of(context).verifiersList != null &&  ColorTheme.of(context).addressesToWatch != null)
                      ? (ColorTheme.of(context).verifiersList.length != 0 ||  ColorTheme.of(context).addressesToWatch?.length != 0)
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
                                  (ColorTheme.of(context).verifiersList?.length != 0)
                                      ? makeHeader("Verifiers",ColorTheme.of(context).baseColor):SliverList(
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
                                                child: ExpandablePanel(
                                                  iconColor: ColorTheme.of(context).secondaryColor,
                                                  header: ColorTheme.of(context).verifiersList[i].isValid ? ColorTheme.of(context).verifiersList[i].inCicle ? ListTile(
                                                    leading: ColorTheme.of(context).lightTheme ? ColorTheme.of(context).verifiersList[i].iconWhite : ColorTheme.of(context).verifiersList[i].iconBlack,
                                                    title: Text(
                                                        ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .nickname
                                                                .toString()
                                                            : ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .id,
                                                        style: ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? TextStyle(
                                                              color: ColorTheme.of(context).secondaryColor,
                                                                fontSize: 20.0,
                                                              )
                                                            : TextStyle(

                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20.0,
                                                              )),
                                                              trailing: Container(
                                                                margin: EdgeInsets.all(MediaQuery.of(context).size.width/30),
                                                                child: Image.asset("images/cycle.png",color: ColorTheme.of(context).secondaryColor,)),
                                                  ):ListTile(
                                                    leading: ColorTheme.of(context).lightTheme? ColorTheme.of(context).verifiersList[i].iconWhite : ColorTheme.of(context).verifiersList[i].iconBlack,
                                                    title: Text(
                                                        ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .nickname
                                                                .toString()
                                                            : ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .id,
                                                        style: ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? TextStyle(
                                                              color: ColorTheme.of(context).secondaryColor,
                                                                fontSize: 20.0,
                                                              )
                                                            : TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20.0,
                                                              )),
                                                              
                                                  ):Container(
                                                    child: ListTile(
                                                      leading: Image.asset("images/communicationProblem.png"),
                                                      title: Text(ColorTheme.of(context).verifiersList[
                                                                          i]
                                                                      .id,style: ColorTheme.of(context).verifiersList[
                                                                    i]
                                                                .isValid
                                                            ? TextStyle(
                                                              color: ColorTheme.of(context).secondaryColor,
                                                                fontSize: 20.0,
                                                              )
                                                            : TextStyle(

                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20.0,
                                                              ),),),
                                                  ),
                                                  expanded: ColorTheme.of(context).verifiersList[i]
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
                                                                Text("In cycle: ", style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .inCicle
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Open edge: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .openEdge
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Receiving UDP: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .receivingUDP
                                                                        .toString(),style: TextStyle(color:ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Retention edge: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .retentionEdge
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Status: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .retentionEdge
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Trailing Edge: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                        i]
                                                                    .trailingEdge
                                                                    .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Transactions: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .transactions
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Version : " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .version
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                           
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Balance: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .balance
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Blocks CT: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .blocksCT
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(

                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Text("Block Vote: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700,),
                                                                    ),
                                                                    ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .blockVote
                                                                        .toString().contains("other")? Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .blockVote
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor)): createColumn(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .blockVote
                                                                        .toString(),";")
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Cycle Length: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                        i]
                                                                    .cycleLength
                                                                    .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Frozen Edge: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .frozenEdge
                                                                        .toString(),style: TextStyle(color:ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("ID: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .id
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("IP Address: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .iPAddress
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Las Queried: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .lastQueried
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Last Removal Heigth: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .lastRemovalHeight
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text("Mesh: " , style: TextStyle(color: ColorTheme.of(context).secondaryColor,fontWeight: FontWeight.w700),
                                                                    ),
                                                                    Text(ColorTheme.of(context).verifiersList[
                                                                            i]
                                                                        .mesh
                                                                        .toString(),style: TextStyle(color: ColorTheme.of(context).secondaryColor))
                                                              ],
                                                            ),
                                                            
                                                                
                                                          ],
                                                        ),)
                                                      : Center(
                                                          child: Text(
                                                            
                                                              "No known verifiers for id " +
                                                                  ColorTheme.of(context).verifiersList[
                                                                          i]
                                                                      .id,style:TextStyle(color: ColorTheme.of(context).secondaryColor,),),
                                                        ),
                                                ),
                                              ),
                                              secondaryActions: <Widget>[
                                                IconSlideAction(
                                                  caption: 'Delete',
                                                  color: ColorTheme.of(context).baseColor,
                                                  icon: Icons.delete,
                                                  onTap: () {
                                                    ColorTheme.of(context).verifiersList
                                                        .removeAt(i);
                                                    setState(() {
                                                      saveVerifier(
                                                          ColorTheme.of(context).verifiersList);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                        childCount: ColorTheme.of(context).verifiersList?.length),
                                  ),
                                  (ColorTheme.of(context).addressesToWatch?.length != 0)
                                      ? makeHeader("Addresses",ColorTheme.of(context).baseColor)
                                      : SliverList(
                                          delegate: SliverChildListDelegate(
                                              [Container()]),
                                        ),
                                  (ColorTheme.of(context).addressesToWatch?.length != 0)
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
                                                              .account_balance_wallet,color: ColorTheme.of(context).secondaryColor,),
                                                              trailing: Text(ColorTheme.of(context).addressesToWatch[i].balance,style: TextStyle(color: ColorTheme.of(context).secondaryColor),),
                                                          title: Text(
                                                              ColorTheme.of(context).addressesToWatch[
                                                                          i]
                                                                      .address
                                                                      .substring(
                                                                          0,
                                                                          4) +
                                                                  "..." +
                                                                  ColorTheme.of(context).addressesToWatch[
                                                                          i]
                                                                      .address
                                                                      .substring(
                                                                          ColorTheme.of(context).addressesToWatch[i].address.length -
                                                                              4),
                                                              style: ColorTheme.of(context).addressesToWatch[
                                                                              i]
                                                                          .balance !=
                                                                      null
                                                                  ? TextStyle(
                                                                    color:ColorTheme.of(context).secondaryColor,
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
                                                        color: ColorTheme.of(context).baseColor,
                                                        icon: Icons.delete,
                                                        onTap: () {
                                                          ColorTheme.of(context).addressesToWatch
                                                              .removeAt(i);
                                                          setState(() {
                                                            saveWatchAddress(
                                                                ColorTheme.of(context).addressesToWatch);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                              childCount: ColorTheme.of(context).addressesToWatch?.length),
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
                                    color:  ColorTheme.of(context).secondaryColor,
                                    height: walletWindowState.screenHeight / 6,
                                    //width: walletWindowState.screenHeight / 5 * 0.9,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    child: Text(
                                        "There is nothing on your Watch List!",
                                        style: TextStyle(
                                            color:  ColorTheme.of(context).secondaryColor,
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
                            color: ColorTheme.of(context).baseColor,
                                  child: SizedBox(
                          width: 200.0,
                          height: 60.0,
                          child: Shimmer.fromColors(
                            baseColor: ColorTheme.of(context).transparentColor,
                            highlightColor: ColorTheme.of(context).highLigthColor,
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
      widgetList.add(Text(eachColumn,style: TextStyle(color: ColorTheme.of(context).secondaryColor)));
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
