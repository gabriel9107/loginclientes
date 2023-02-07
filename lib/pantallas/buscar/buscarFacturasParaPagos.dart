import 'package:flutter/material.dart';
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/product.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/facturaDetalle.dart';
import '../../clases/global.dart';

class BuscarFacturaEnPagos extends SearchDelegate {
  @override
  final textController = TextEditingController();

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
    List<Factura> _ListFactura = [];

    Factura.obtenerFacturas().then((value) {
      if (value != null) value.forEach((item) => _ListFactura.add(item));
    });

    //  Productos.getProductoPrueba().then((value) {
    //   if (value != null) value.forEach((item) => _listProducts.add(item));
    // });

    // _ListFactura
    _ListFactura = TodasLasFacturas.toList() as List<Factura>;

    List<Factura> suggestions = _ListFactura.where((element) {
      final result = element.facturaId.toString().toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text('Numero Factura: ' + suggestion.facturaId.toString(),
              style: TextStyle(fontSize: 18)),
          subtitle: Text('Monto total : ' + suggestion.montoFactura.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 80,
                child: Text('Monto Pendiente'),
              ),

              Container(
                width: 60,
                child: Text(
                  '10,000.',
                ),
              ),
              // Container(
              //   child: Text('Prueba'),
              // ),
              // Container(
              //   child: Text('Prueba'),
              // ),
              // ),

              // Container(
              //   color: Colors.red,
              //   child: Text('Valor Pendiente'),
              // ),

              IconButton(onPressed: () {}, icon: Icon(Icons.payment)),
              Container(
                width: 100,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'saldo '),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  onTap: () {
                    query = suggestion.facturaId.toString();
                  },
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    // double price = suggestion.price as double;

                    // FacturaDetalle.addfacturaDetalle(FacturaDetalle(
                    //     facturaNumero: "1",
                    //     codigoProducto: suggestion.productoCodigo.toString(),
                    //     montoproducto:
                    //         double.parse(suggestion.price.toString()),
                    //     nombreProducto: suggestion.nombre.toString(),
                    //     cantidadProducto:
                    //         int.parse(textController.text.toString())));
                    // close(context, null);
                  },
                  child: Text('Agregar'),
                ),
              )
            ],
          ),
          onTap: () {
            query = suggestion.facturaId.toString();
          },
        );
      },
    );
  }
}
