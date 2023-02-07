// import 'package:flutter/material.dart';
// import 'package:sigalogin/clases/factura.dart';
// import 'package:sigalogin/clases/modelos/productos.dart';
// import 'package:sigalogin/clases/product.dart';
// import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';
// import 'package:sigalogin/servicios/db_helper.dart';

// import '../../clases/facturaDetalle.dart';
// import '../../clases/global.dart';

// class BuscarFacturaEnPagos extends SearchDelegate {
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
//     List<Factura> _ListFactura = [];

//     // Factura.obtenerFacturasdelCLiente().then((value) {
//     //   if (value != null) value.forEach((item) => _listProducts.add(item));
//     // });

//     //  Productos.getProductoPrueba().then((value) {
//     //   if (value != null) value.forEach((item) => _listProducts.add(item));
//     // });



//     // _ListFactura 
//     List<Factura> suggestions = TodosProductos.cast<Producto>().toList() as List<Factura>;

//     // List<Producto> suggestions = _listProducts.where((element) {
//     //   final result = element.nombre.toString().toLowerCase();
//     //   final input = query.toLowerCase();
//     //   return result.contains(input);
//     // }).toList();

//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final suggestion = suggestions[index];
//         return ListTile(
//           title: Text('Nombre: ' + suggestion.nombre.toString()),
//           subtitle: Text('Costo : ' + suggestion.price.toString()),
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

//                     FacturaDetalle.addfacturaDetalle(FacturaDetalle(
//                         facturaNumero: "1",
//                         codigoProducto: suggestion.productoCodigo.toString(),
//                         montoproducto:
//                             double.parse(suggestion.price.toString()),
//                         nombreProducto: suggestion.nombre.toString(),
//                         cantidadProducto:
//                             int.parse(textController.text.toString())));
//                     close(context, null);
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

//     if (ListaProducto == false) {
//       documento.forEach((element) {
//         Producto a = new Producto(
//             compagnia: element.compagnia,
//             isDelete: element.isDelete,
//             nombre: element.nombre,
//             ouM: element.ouM,
//             price: element.price,
//             productoCodigo: element.productoCodigo,
//             qty: element.qty,
//             sincronizado: element.sincronizado,
//             typeOfSales: element.typeOfSales);
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

   
//   }
// }
