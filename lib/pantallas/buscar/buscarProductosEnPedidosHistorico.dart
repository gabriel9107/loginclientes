import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/clases/product.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';
import 'package:sigalogin/pantallas/pedidos/pedidos.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../../clases/facturaDetalle.dart';
import '../../clases/global.dart';

class MySearchDelegateParaProductosEnPedidosHistorico
    extends SearchDelegate<int> {
  final int pedidoId;

  MySearchDelegateParaProductosEnPedidosHistorico(this.pedidoId);

  @override
  final textController = TextEditingController();
  List<TextEditingController> _controllers = [];

  Pattern get input => 'q';

  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (query.isEmpty) {
                close(context, pedidoId);
              } else {
                query = '';
              }
            }),
      ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        //Boton para regresar atras
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, pedidoId),
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

    // Productos.getProductoPrueba().then((value) {
    //   if (value != null) value.forEach((item) => _listProducts.add(item));
    // });

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
              suggestion.precio.toStringAsFixed(2)),
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
                      PedidoDetalle detalle = new PedidoDetalle(
                          codigo: suggestion.codigo.toString(),
                          nombre: suggestion.nombre.toString(),
                          cantidad: 1,
                          precio: double.parse(suggestion.precio.toString()),
                          pedidoId: pedidoId.toString(),
                          compagnia: compagnia,
                          isDelete: 0,
                          sincronizado: 0);

                      DatabaseHelper.instance.AddSalesDetalle(detalle);
                      close(context, pedidoId);
                      // close(context, null);
                    } else {
                      PedidoDetalle detalle = new PedidoDetalle(
                          codigo: suggestion.codigo.toString(),
                          nombre: suggestion.nombre.toString(),
                          cantidad:
                              int.parse(_controllers[index].text.toString()),
                          precio: double.parse(suggestion.precio.toString()),
                          pedidoId: pedidoId.toString(),
                          compagnia: compagnia,
                          isDelete: 0,
                          sincronizado: 0);
                      DatabaseHelper.instance.AddSalesDetalle(detalle);
                      close(context, pedidoId);
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

    // if (ListaProducto == false) {
    //   documento.forEach((element) {
    //     Producto a = new Producto(
    //         compagnia: element.compagnia,
    //         isDelete: element.isDelete,
    //         nombre: element.nombre,
    //         ouM: element.ouM,
    //         precio: element.precio,
    //         codigo: element.codigo,
    //         cantidad: element.cantidad,
    //         sincronizado: element.sincronizado,
    //         tipodeVenta: element.tipodeVenta);
    //     TodosProductos.add(a);
    //   });
    //   ListaProducto = true;
    // }
    // TodosProductos.add(documento);
    // Lista.add(documento);
    return documento;
  }

  static List<Producto> getProductos() {
    return DatabaseHelper.instance.getProductos() as List<Producto>;
  }
}
