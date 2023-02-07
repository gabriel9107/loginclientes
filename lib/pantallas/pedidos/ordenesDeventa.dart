import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_testing/InkWellGesture.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int qty = 1;
  int items = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido de Venta'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 3,
            ),
            height: 60,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 3, top: 7, right: 6),
                          width: 13,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Codigo de cliente :    7488803',
                                style: TextStyle(fontSize: 15)),
                            Text('Nombre de cliente : Aro y Motor (Guerra)',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items,
                itemBuilder: (ctx, itemIndex) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      height: 65,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('+ESPIGA TIMON BMX MAGN. AZUL',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        '9,507.30',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    qty += 1;
                                                  });
                                                },
                                                child: Icon(
                                                  CupertinoIcons.plus,
                                                  color: Color(0xFFE86969),
                                                  size: 20,
                                                )),

                                            // inkWellGesture(
                                            //   () {
                                            //     setState(() {
                                            //       qty += 1;
                                            //     });
                                            //   },
                                            //   child: Icon(
                                            //     Icons.add_circle,
                                            //     color: Colors.green,
                                            //     size: 25,
                                            //   ),
                                            // ),
                                            Text(
                                              qty > 0 ? qty.toString() : '1',
                                              style: TextStyle(fontSize: 16),
                                            ),

                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    qty -= 1;
                                                  });
                                                },
                                                child: Icon(
                                                  CupertinoIcons.minus,
                                                  color: Color(0xFFE86969),
                                                  size: 20,
                                                )),
                                            // inkWellGesture(
                                            //   () {
                                            //     setState(() {
                                            //       qty -= 1;
                                            //     });
                                            //   },
                                            //   child: Icon(
                                            //     Icons.remove_circle,
                                            //     color: Colors.red,
                                            //     size: 25,
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                              size: 25,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Container(
            height: 200,
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text('Shipping'),
                          // Text('Offer'),
                          Text('Cantidad de Articulos '),
                          Text('Sub Total '),
                          // Text('Sub Total'),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text('  \u{20B9} 80'),
                          // Text('- \u{20B9} 100'),
                          Text('2'),
                          Text('8,200')
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  child: ButtonBar(
                    children: [
                      Text(
                        'guardar',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  )

                  // child: FlatButton(
                  //   child: Text('PROCEED TO \u{20B9} 10,019',
                  //       style: TextStyle(fontSize: 20)),
                  //   onPressed: () {},
                  //   color: Colors.green,
                  //   textColor: Colors.white,
                  // )
                  )),
        ],
      ),
    );
  }
}
