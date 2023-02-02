import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProductDetail extends StatefulWidget {
  String appBarTitle;

  ProductDetail(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ProductDetailState(this.appBarTitle);
  }
}

class ProductDetailState extends State<ProductDetail> {
  static var _priorities = ['Height', 'Low'];
  // static var _UnidadMedida = ['UND', 'JGO ', 'PZA', 'ROLLO'];
  String appBarTitle;

  TextEditingController titleController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  ProductDetailState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                  items: _priorities.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  value: 'Low',
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('El usuario selecciono  $valueSelectedByUser');
                    });
                  }),
            ),

            //Codigo
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                onChanged: (value) {
                  debugPrint('Algo a cambiado en este text');
                },
                decoration: InputDecoration(
                    labelText: 'Codigo',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            //Nombre
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                onChanged: (value) {
                  debugPrint('Algo a cambiado en este text');
                },
                decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            //Descripcion

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                onChanged: (Descripcion) {
                  debugPrint('Algo a cambiado en este text');
                },
                decoration: InputDecoration(
                    labelText: 'Descripcion',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Unidad de medida

            ListTile(
              title: DropdownButton(
                  items: _priorities.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  value: 'Low',
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('El usuario selecciono  $valueSelectedByUser');
                    });
                  }),
            ),
            //Valor o monto

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                onChanged: (value) {
                  debugPrint('Algo a cambiado en este text');
                },
                decoration: InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                onChanged: (Descripcion) {
                  debugPrint('Algo a cambiado en este text');
                },
                decoration: InputDecoration(
                    labelText: 'Tipo de venta',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.5, bottom: 15.5),
              child: Row(children: <Widget>[
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.5, bottom: 15.5),
              child: Row(children: <Widget>[
                ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
