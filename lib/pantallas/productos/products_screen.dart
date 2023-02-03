import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/themes.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';
import 'package:sigalogin/pantallas/productos/products_detail.dart';

import '../../clases/customers.dart';
import '../../clases/product.dart';
import '../../servicios/db_helper.dart';

class ProductsList extends StatefulWidget {
  @override
  createState() => ProductsListState();
}
// State<StatefulWidget> createState() {
//   return ProductsList();
// }

class ProductsListState extends State<ProductsList> {
  late List<Product> products;

  @override
  void initState() {
    products = Product.getProduct();
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
            onPressed: () => {},
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
                            child: Icon(Icons.emoji_people),
                          ),
                          title: Text(producto.productoCodigo.toString()),
                          subtitle: Text(producto.nombre.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('En Existencia :  '),
                              Text(producto.qty.toString())
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
