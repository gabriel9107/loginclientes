import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';
import 'package:sigalogin/pantallas/buscar/busquedadeProductos.dart';
import 'package:sigalogin/pantallas/productos/products_detail.dart';
import 'package:sqflite/sqflite.dart';

import '../../clases/customers.dart';
import '../../clases/product.dart';
import '../../servicios/db_helper.dart';
import '../busquedas/busquedaProductosenProducto.dart';

class ProductsList extends StatefulWidget {
  @override
  createState() => ProductsListState();
}
// State<StatefulWidget> createState() {
//   return ProductsList();
// }

class ProductsListState extends State<ProductsList> {
  Future<List<Producto>> productos = DatabaseHelper.instance.getProductos();

  @override
  void initState() {
    productos = DatabaseHelper.instance.getProductos();
    super.initState();
  }

  Widget build(BuildContext context) {
    // DBProvider().initializeDB();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siga Mobile - Lista de Productos'),
        backgroundColor: navBar,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => {
              showSearch(
                  context: context, delegate: MySearchDelegateParaProductos())
            },
          )
        ],
      ),
      drawer: navegacions(),
      body: Center(
        child: FutureBuilder<List<Producto>>(
          future: DatabaseHelper.instance.getProductos(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Cargando...'));
            }
            return snapshot.data!.isEmpty
                ? Center(
                    child: Text(
                        'No existen Productos sincronizado, favor sincronizar...'))
                : ListView(
                    children: snapshot.data!.map((producto) {
                      return Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.wallet_travel),
                          ),
                          title: Text(producto.nombre.toString()),
                          subtitle: Text(producto.codigo.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    'En Existencia :  ' +
                                        producto.cantidad.toString(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [Text("           ")],
                              ),

                              Column(
                                children: [
                                  Text('Precio de venta :  ' +
                                      producto.precio.toStringAsFixed(2)),
                                  Text(' Unidad de Medida :  ' + producto.ouM),
                                ],
                              )
                              // Text('En Existencia :  '),
                              // Text(
                              //   producto.cantidad.toString(),
                              // ),
                              // Text(
                              //   producto.cantidad.toString(),
                              // )
                            ],
                          ),
                          onTap: () {
                            // NavigateDetail('Edit Product');
                          },
                        ),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
    );
  }
}
