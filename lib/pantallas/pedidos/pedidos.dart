import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../clases/pedidos.dart';
import '../NavigationDrawer.dart';

const darkBlueColor = Color(0xff486579);

class pedidop extends StatelessWidget {
  const pedidop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Siga Mobile - Pedidos'),
          backgroundColor: Color.fromARGB(255, 25, 28, 228),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () => {
                      //   showSearch(
                      //       context: context, delegate: MySearchDelegateforProducto())
                    } // },
                )
          ],
        ),
        drawer: navegacions(),
        body: MiPedidos());
  }
}

class MiPedidos extends StatefulWidget {
  @override
  State<MiPedidos> createState() => _MiPedidoState();
}

class _MiPedidoState extends State<MiPedidos> {
  final productCodeController = TextEditingController();
  late TextEditingController controller;

  // List<Orden_Compra> tempOrdenes = Orden_Compra.getOrdenes();

  List<Contact> _contacts = [];

  List<pedidos> _pedidosList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Pedidos - Cliente : Gabriel Montero | 40221025725',
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_list()],
          // children: <Widget>[_form(), _list()],
        ),
      ),
    );
  }

  _form() => Column(
//mis controller

        children: [
          // ListTile(
          //   title: Text('Producto'),
          //   subtitle: TextFormField(
          //     decoration: const InputDecoration(
          //       border: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(8))),
          //       hintText: 'Producto',
          //     ),
          //   ),
          // ),

          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: autocompleteProducto(),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                ]),
          ),

          // ListTile(
          //   title: Text('Producto'),
          //   subtitle: TextFormField(
          //     decoration: const InputDecoration(
          //       border: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(8))),
          //       hintText: 'Producto',
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Cantidad'),
                  subtitle: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'Cantidad',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                alignment: Alignment.topRight,
                width: 500,
                child: ElevatedButton(
                  child: Text('Agregar'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: 15,
                          height: 3,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          )
        ],
      );

  _list() => Expanded(
          child: Card(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x320E151B),
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Hero(
                                tag: 'ControllerImage',
                                transitionOnUserGestures: true,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        Icon(Icons.production_quantity_limits)),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: Text('TV'),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: Text('1000'),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: Text('Cantidad: 100'),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    //remove item of list
                                  },
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Color(0xFFE86969),
                                    size: 20,
                                  ))
                            ])
                      ],
                    ),
                  ),
                ));
          },
        ),
      ));

  _llist() => Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Scrollbar(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        color: darkBlueColor,
                        size: 40.0,
                      ),
                      title: Text(
                        _contacts[index].name.toUpperCase(),
                        style: TextStyle(
                            color: darkBlueColor, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_contacts[index].mobile),
                      onTap: () {},
                    ),
                    Divider(
                      height: 5.0,
                    ),
                  ],
                );
              },
              itemCount: _contacts.length,
            ),
          ),
        ),
      );
}

class autocompleteProducto extends StatelessWidget {
  const autocompleteProducto({super.key});

  static const List<String> _kOptions = <String>[
    'Tv',
    'Abanico',
    'Telefono',
    'Pantalla'
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}
