import 'package:flutter/material.dart';
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/product.dart';
import 'package:sigalogin/pantallas/Pagos/pagosForm.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/detalledePago.dart';
import '../../clases/facturaDetalle.dart';
import '../../clases/global.dart';
import '../../clases/modelos/pagodetalle.dart';

import 'package:intl/intl.dart';

class BuscarFacturaEnPagos extends SearchDelegate {
  @override
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

    Pago.obtenerFacturas().then((value) {
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
          subtitle: Text('Monto total : ' +
              NumberFormat.simpleCurrency().format(suggestion.montoFactura)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 150,
                child: Text('Monto Pendiente :'),
              ),
              Container(
                width: 100,
                child: Text(NumberFormat.simpleCurrency()
                    .format(suggestion.montoFactura)),
              ),
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    var facturafecha = DateTime.now();
                    var facturafechavencimiento = DateTime.now();

                    var pago = new PagoTemporal(
                      fechaFactura: suggestion.facturaFecha.toString(),
                      fechaVencimiento:
                          suggestion.facturaVencimiento.toString(),
                      compagni: compagnia,
                      facturaId: suggestion.facturaId,
                      id: 0,
                      isDelete: 0,
                      montoAplicado: 0.0,
                      montoDeFacturaAlMomento:
                          (suggestion.montoFactura - suggestion.totalPagado),
                      sincronizado: 0,
                      valorFactura:
                          (suggestion.montoFactura * 100).round() / 100.0,
                      valorPendiente:
                          (suggestion.montoFactura - suggestion.totalPagado),
                    );

                    PagoTemporal.agregarFacturasaPagos(pago);

                    // PagoTemporal.addfacturaDetalle(Factura(
                    //     facturaFecha: suggestion.facturaFecha,
                    //     facturaId: suggestion.facturaId,
                    //     facturaVencimiento: suggestion.facturaVencimiento,
                    //     id: suggestion.id,
                    //     metodoDePago: suggestion.metodoDePago,
                    //     montoFactura: suggestion.montoFactura,
                    //     totalPagado: suggestion.totalPagado,
                    //     clienteId: suggestion.clienteId,
                    //     clienteNombre: suggestion.clienteNombre,
                    //     compagnia: compagnia,
                    //     isDelete: 0,
                    //     montoPendiente:
                    //         (suggestion.montoFactura - suggestion.totalPagado),
                    //     pedidoId: suggestion.pedidoId,
                    //     sincronizado: 0,
                    //     vendedorId: usuario));

                    close(context, null);
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
