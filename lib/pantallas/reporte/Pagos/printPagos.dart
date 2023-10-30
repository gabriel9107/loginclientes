// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sigalogin/pantallas/reporte/Pagos/printPage.dart';

// import '../../../clases/api/facturaRecibo.dart';
// import '../../../clases/modelos/pago.dart';

// class PrintHome extends StatelessWidget {
//   // final comprobanteDePago pagos = comprobanteDePago(
//   //     clienteNombre: 'Gabriel Montero',
//   //     clienteCodigo: '40221025725',
//   //     fechaComprobante: DateTime.now(),
//   //     vendedorNombre: 'Gabriel Jose',
//   //     pagos: [
//   //       Pago(
//   //           clienteId: '40221025725',
//   //           compagni: 1,
//   //           fechaPago: DateTime.now().toString(),
//   //           isDelete: 1,
//   //           metodoDePago: 'Efectivo',
//   //           montoPagado: 4532.51,
//   //           pendiente: 1,
//   //           sincronizado: 1,
//   //           vendorId: 'gmontero'),
//   //       Pago(
//   //           clienteId: '40221025725',
//   //           compagni: 1,
//   //           fechaPago: DateTime.now().toString(),
//   //           isDelete: 1,
//   //           metodoDePago: 'Efectivo',
//   //           montoPagado: 1500.15,
//   //           pendiente: 1,
//   //           sincronizado: 1,
//   //           vendorId: 'gmontero'),
//   //       Pago(
//   //           clienteId: '40221025725',
//   //           compagni: 1,
//   //           fechaPago: DateTime.now().toString(),
//   //           isDelete: 1,
//   //           metodoDePago: 'Efectivo',
//   //           montoPagado: 12500.14,
//   //           pendiente: 1,
//   //           sincronizado: 1,
//   //           vendorId: 'gmontero'),
//   //       Pago(
//   //           clienteId: '40221025725',
//   //           compagni: 1,
//   //           fechaPago: DateTime.now().toString(),
//   //           isDelete: 1,
//   //           metodoDePago: 'Efectivo',
//   //           montoPagado: 682.3,
//   //           pendiente: 1,
//   //           sincronizado: 1,
//   //           vendorId: 'gmontero')
//   //     ]);

//   // final List<Map<String, dynamic>> data = [
//   //   {'title': 'Cadbury Dairy Milk', 'price': 15, 'qty': 2},
//   //   {'title': 'Parle-G Gluco Biscut', 'price': 5, 'qty': 5},
//   //   {'title': 'Fresh Onion - 1KG', 'price': 20, 'qty': 1},
//   //   {'title': 'Fresh Sweet Lime', 'price': 20, 'qty': 5},
//   //   {'title': 'Maggi', 'price': 10, 'qty': 5},
//   // ];

//   final f = NumberFormat("\$###,###.00", "en_US");

//   @override
//   Widget build(BuildContext context) {
//     int _total = 0;
//     _total = data.map((e) => e['price'] * e['qty']).reduce(
//           (value, element) => value + element,
//         );

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter - Thermal Printer'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (c, i) {
//                 return ListTile(
//                   title: Text(
//                     data[i]['title'].toString(),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(
//                     "${f.format(data[i]['price'])} x ${data[i]['qty']}",
//                   ),
//                   trailing: Text(
//                     f.format(
//                       data[i]['price'] * data[i]['qty'],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             color: Colors.grey[200],
//             padding: EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Text(
//                   "Total: ${f.format(_total)}",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 80,
//                 ),
//                 Expanded(
//                   child: TextButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => PrintPage(pagos),
//                         ),
//                       );
//                     },
//                     icon: Icon(Icons.print),
//                     label: Text('Print'),
//                     style: TextButton.styleFrom(
//                         primary: Colors.white, backgroundColor: Colors.green),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
