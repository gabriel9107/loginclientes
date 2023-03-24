// import 'package:flutter/material.dart';
// import 'package:sigalogin/clases/modelos/productos.dart';
// import 'package:sigalogin/clases/product.dart';
// import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';
// import 'package:sigalogin/servicios/db_helper.dart';

// import '../../clases/facturaDetalle.dart';
// import '../../clases/global.dart';

// class MySearchDelegateParaProductosEnPedidos extends SearchDelegate {
//   @override
//   final textController = TextEditingController();

//   Pattern get input => 'q';

//   List<Widget>? buildActions(BuildContext context) => [
//         IconButton(
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               if (query.isEmpty) {
//                 close(context, null);
//               } else {
//                 query = '';
//               }
//             }),
//       ];
//   @override
//   Widget? buildLeading(BuildContext context) => IconButton(
//         //Boton para regresar atras
//         icon: const Icon(Icons.arrow_back),
//         onPressed: () => close(context, null),
//       );

//   @override
//   Widget buildResults(BuildContext context) => Center(
//         child: Text(
//           query,
//           style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300),
//         ),
//       );

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<Producto> _listProducts = [];

//     Productos.getProductoPrueba().then((value) {
//       if (value != null) value.forEach((item) => _listProducts.add(item));
//     });

//     _listProducts = TodosProductos.cast<Producto>().toList();

//     List<Producto> suggestions = _listProducts.where((element) {
//       final result = element.nombre.toString().toLowerCase();
//       final input = query.toLowerCase();
//       return result.contains(input);
//     }).toList();
//     Future<void> _showMyDialog() async {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: false, // user must tap button!
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Alert'),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: const <Widget>[
//                   Text('debe de agregar una cantidad'),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Ok'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }

//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final suggestion = suggestions[index];
//         return ListTile(
//           tileColor: suggestion.seleccionado == true
//               ? Color.fromARGB(255, 147, 194, 231)
//               : null,
//           title: Text('Nombre: ' + suggestion.nombre.toString()),
//           subtitle: Text('Costo : ' + suggestion.precio.toString()),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               IconButton(
//                   onPressed: () {},
//                   icon: Icon(Icons.production_quantity_limits)),
//               Container(
//                 width: 100,
//                 child: TextField(
//                   controller: textController,
//                   decoration: InputDecoration(hintText: 'Cantidad'),
//                   keyboardType: TextInputType.numberWithOptions(
//                       signed: false, decimal: true),
//                   onTap: () {
//                     query = suggestion.nombre.toString();
//                   },
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.topRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // double price = suggestion.price as double;
//                     if (textController.text.isEmpty) {
//                       suggestions[index].seleccionado = true;

//                       FacturaDetalle.addfacturaDetalle(FacturaDetalle(
//                           facturaNumero: "1",
//                           codigoProducto: suggestion.codigo.toString(),
//                           montoproducto:
//                               double.parse(suggestion.precio.toString()),
//                           nombreProducto: suggestion.nombre.toString(),
//                           cantidadProducto: 1));
//                       // close(context, null);
//                     } else {
//                       suggestions[index].seleccionado = true;
//                       FacturaDetalle.addfacturaDetalle(FacturaDetalle(
//                           facturaNumero: "1",
//                           codigoProducto: suggestion.codigo.toString(),
//                           montoproducto:
//                               double.parse(suggestion.precio.toString()),
//                           nombreProducto: suggestion.nombre.toString(),
//                           cantidadProducto: int.parse(textController.text)));
//                       // close(context, null);
//                     }
//                   },
//                   child: Text('Agregar'),
//                 ),
//               )
//             ],
//           ),
//           onTap: () {
//             query = suggestion.nombre.toString();
//           },
//         );
//       },
//     );
//   }
// }

// class Productos {
//   String codigoProducto;
//   String nombreProducto;
//   String descripcionProducto;
//   double precioProducto;

//   Productos(
//       {required this.codigoProducto,
//       required this.nombreProducto,
//       required this.descripcionProducto,
//       required this.precioProducto});

//   List<Producto> producto = [];
//   static Future getProductoPrueba() async {
//     var documento =
//         await DatabaseHelper.instance.getProductos() as List<Producto>;

//     if (ListaProducto == false && TodosProductos.length >= 0) {
//       documento.forEach((element) {
//         Producto a = new Producto(
//             compagnia: element.compagnia,
//             isDelete: element.isDelete,
//             nombre: element.nombre,
//             ouM: element.ouM,
//             precio: element.precio,
//             codigo: element.codigo,
//             cantidad: element.cantidad,
//             sincronizado: element.sincronizado,
//             tipodeVenta: element.tipodeVenta);
//         TodosProductos.add(a);
//       });
//       ListaProducto = true;
//     }
//     // TodosProductos.add(documento);
//     // Lista.add(documento);
//     return documento;
//   }

//   static List<Producto> getProductos() {
//     return DatabaseHelper.instance.getProductos() as List<Producto>;

//     // return <Productos>[
//     //   Productos(
//     //       codigoProducto: '160X14 ',
//     //       nombreProducto: 'TVR ARO',
//     //       descripcionProducto: 'TVR ARO 1.60 X 14 NIQUEL',
//     //       precioProducto: 993.18),
//     //   Productos(
//     //       codigoProducto: '3AA-15631-00',
//     //       nombreProducto: '31120-CG125 ',
//     //       descripcionProducto: 'TVR CAMPO 8-BOB CG125 COMPL    ',
//     //       precioProducto: 804.07)
//     // ];
//   }
// }

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/product.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/facturaDetalle.dart';
import '../../clases/global.dart';

class MySearchDelegateParaProductosEnPedidos extends SearchDelegate {
  @override
  final textController = TextEditingController();
  List<TextEditingController> _controllers = [];

  Pattern get input => 'q';

  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            }),
      ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        //Boton para regresar atras
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(
          query,
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Producto> _listProducts = [];

    Productos.getProductoPrueba().then((value) {
      if (value != null) value.forEach((item) => _listProducts.add(item));
    });

    _listProducts = TodosProductos.cast<Producto>().toList();

    List<Producto> suggestions = _listProducts.where((element) {
      final result = element.nombre.toString().toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('debe de agregar una cantidad'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        _controllers.add(new TextEditingController());

        final suggestion = suggestions[index];
        return ListTile(
          title: Text('Nombre: ' + suggestion.nombre.toString()),
          subtitle: Text(" Codigo:" +
              suggestion.codigo +
              "             " +
              'Costo : ' +
              suggestion.precio.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.production_quantity_limits)),
              Container(
                width: 100,
                child: TextField(
                  controller: _controllers[index],
                  decoration: InputDecoration(hintText: 'Cantidad'),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  onTap: () {
                    // query = suggestion.nombre.toString();
                  },
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    // double price = suggestion.price as double;
                    if (_controllers[index].text.isEmpty) {
                      FacturaDetalle.addfacturaDetalle(FacturaDetalle(
                          montoLinea: suggestion.precio,
                          facturaNumero: "1",
                          codigoProducto: suggestion.codigo.toString(),
                          montoproducto:
                              double.parse(suggestion.precio.toString()),
                          nombreProducto: suggestion.nombre.toString(),
                          cantidadProducto: 1));
                      // close(context, null);
                    } else {
                      int cantidad =
                          int.parse(_controllers[index].text.toString());
                      FacturaDetalle.addfacturaDetalle(FacturaDetalle(
                          montoLinea: (cantidad * suggestion.precio),
                          facturaNumero: "1",
                          codigoProducto: suggestion.codigo.toString(),
                          montoproducto:
                              double.parse(suggestion.precio.toString()),
                          nombreProducto: suggestion.nombre.toString(),
                          cantidadProducto:
                              int.parse(_controllers[index].text.toString())));
                      // close(context, null);
                    }
                  },
                  child: Text('Agregar'),
                ),
              )
            ],
          ),
          onTap: () {
            // query = suggestion.nombre.toString();
          },
        );
      },
    );
  }
}

class Productos {
  String codigoProducto;
  String nombreProducto;
  String descripcionProducto;
  double precioProducto;

  Productos(
      {required this.codigoProducto,
      required this.nombreProducto,
      required this.descripcionProducto,
      required this.precioProducto});

  List<Producto> producto = [];
  static Future getProductoPrueba() async {
    var documento =
        await DatabaseHelper.instance.getProductos() as List<Producto>;

    if (ListaProducto == false) {
      documento.forEach((element) {
        Producto a = new Producto(
            compagnia: element.compagnia,
            isDelete: element.isDelete,
            nombre: element.nombre,
            ouM: element.ouM,
            precio: element.precio,
            codigo: element.codigo,
            cantidad: element.cantidad,
            sincronizado: element.sincronizado,
            tipodeVenta: element.tipodeVenta);
        TodosProductos.add(a);
      });
      ListaProducto = true;
    }
    // TodosProductos.add(documento);
    // Lista.add(documento);
    return documento;
  }

  static List<Producto> getProductos() {
    return DatabaseHelper.instance.getProductos() as List<Producto>;
  }
}
