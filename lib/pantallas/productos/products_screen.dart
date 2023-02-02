import 'package:flutter/material.dart';
import 'package:sigalogin/pantallas/NavigationDrawer.dart';
import 'package:sigalogin/pantallas/productos/products_detail.dart';

import '../../clases/product.dart';

class ProductsList extends StatefulWidget {
  @override
  createState() => ProductsListState();
}
// State<StatefulWidget> createState() {
//   return ProductsList();
// }

class ProductsListState extends State<ProductsList> {
  final List<String> entries = ['Gabriel', 'Juan', 'Eduardo'];

  late List<Product> products;

  int count = 0;

  @override
  void initState() {
    products = Product.getProduct();
    super.initState();
  }

  Widget build(BuildContext context) {
    // DBProvider().initializeDB();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Siga Mobile'),
        backgroundColor: Color.fromARGB(255, 25, 28, 228),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => {})
        ],
      ),
      drawer: NavigationDrawer(),
      // body: getProductListView(),
      body: entries.length > 0
          ? ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.key),
                    ),
                    title: Text(products[index].codigo),
                    subtitle: Text(products[index].descripcion),
                    onTap: () {
                      debugPrint('Lista tap');
                      NavigateDetail('Edit Product');
                    },
                  ),
                );
                // return ListTile(
                //   title: Text('${entries[index]}'),
                // );
              },
            )
          : Center(
              child: Text('NO existen Productos'),
            ),
    );
  }

  ListView getProductListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.key),
            ),
            title: Text('Dummy Title'),
            subtitle: Text('Dummy Date '),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              debugPrint('Lista tap');
              NavigateDetail('Edit Product');
            },
          ),
        );
      },
    );
  }

  void NavigateDetail(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(title);
    }));
  }
}

class MySearchProductDelegate {}
