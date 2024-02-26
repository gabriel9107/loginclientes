// import 'dart:convert';

// import 'package:http/http.dart';

// List<Producto?> productoFromJson(String str) => List<Producto?>.from(
//     json.decode(str).map((x) => x == null ? null : Producto.fromJson(x)));

// String productoToJson(List<Producto?> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x?.toJson())));

// class Producto {
//   Producto({
//     required this.compagnia,
//     this.id,
//     required this.isDelete,
//     required this.nombre,
//     required this.ouM,
//     required this.price,
//     required this.productoCodigo,
//     required this.qty,
//     required this.sincronizado,
//     required this.typeOfSales,
//   });

//   String? compagnia;
//   int? id;
//   String? isDelete;
//   String? nombre;
//   String? ouM;
//   String? price;
//   String? productoCodigo;
//   String? qty;
//   String? sincronizado;
//   String? typeOfSales;

//   factory Producto.fromMap(Map<String, dynamic> json) => new Producto(
//       compagnia: json["Compagnia"],
//       isDelete: json["IsDelete"],
//       nombre: json["Nombre"],
//       ouM: json["OuM"],
//       price: json["Price"],
//       productoCodigo: json["ProductoCodigo"],
//       qty: json["Qty"],
//       sincronizado: json["Sincronizado"],
//       typeOfSales: json["TypeOfSales"]);

//   factory Producto.fromJson(Map<String, dynamic> json) => Producto(
//         compagnia: json["Compagnia"],
//         isDelete: json["IsDelete"],
//         nombre: json["Nombre"],
//         ouM: json["OuM"],
//         price: json["Price"],
//         productoCodigo: json["ProductoCodigo"],
//         qty: json["Qty"],
//         sincronizado: json["Sincronizado"],
//         typeOfSales: json["TypeOfSales"],
//       );

//   Map<String, dynamic> toMap() {
//     return {
//       'Compagnia': compagnia,
//       'Id': id,
//       'IsDelete': isDelete,
//       'Nombre': nombre,
//       'OuM': ouM,
//       'Price': price,
//       'ProductoCodigo': productoCodigo,
//       'Qty': qty,
//       'Sincronizado': sincronizado,
//       'TypeOfSales': typeOfSales,
//     };
//   }

//   Map<String, dynamic> toJson() => {
//         "Compagnia": compagnia,
//         "Id": id,
//         "IsDelete": isDelete,
//         "Nombre": nombre,
//         "OuM": ouM,
//         "Price": price,
//         "ProductoCodigo": productoCodigo,
//         "Qty": qty,
//         "Sincronizado": sincronizado,
//         "TypeOfSales": typeOfSales,
//       };
// }

// To parse this JSON data, do
//
//     final producto = productoFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../servicios/db_helper.dart';
import '../global.dart';

class Producto {
  Producto(
      {this.id,
      required this.nombre,
      required this.cantidad,
      required this.codigo,
      required this.compagnia,
      required this.isDelete,
      required this.ouM,
      required this.precio,
      required this.sincronizado,
      required this.tipodeVenta,
      this.seleccionado});

  int? id;
  String codigo;
  String nombre;
  int cantidad;
  double precio;
  String ouM;
  String tipodeVenta;
  int sincronizado;
  int compagnia;
  int isDelete;
  bool? seleccionado;

  factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Producto.fromMap(Map<String, dynamic> json) => new Producto(
        cantidad: 10,

        // json["Cantidad"].toString().replaceAll('0', '1') as int,
        codigo: json["Codigo"],
        compagnia: json["Compagnia"],
        id: json["Id"],
        isDelete: 0,
        nombre: json["Nombre"],
        ouM: json["OuM"],
        precio: json["Precio"].toDouble(),
        sincronizado: json["Sincronizado"],
        tipodeVenta: "Contado",
      );

  Map<String, dynamic> toMap() => {
        "Cantidad": cantidad,
        "Codigo": codigo,
        "Compagnia": compagnia,
        "Id": id,
        "IsDelete": isDelete,
        "Nombre": nombre,
        "OuM": ouM,
        "Precio": precio,
        "Sincronizado": sincronizado,
        "TipodeVenta": tipodeVenta,
      };

  static Future obtenerProductos() async {
    var documento =
        await DatabaseHelper.instance.getProductos() as List<Producto>;

    if (ListaProducto == false) {
      documento.forEach((element) {
        Producto producto = new Producto(
            cantidad: element.cantidad,
            codigo: element.codigo,
            compagnia: element.compagnia,
            isDelete: element.isDelete,
            nombre: element.nombre,
            ouM: element.ouM,
            precio: element.precio,
            sincronizado: element.sincronizado,
            tipodeVenta: element.tipodeVenta,
            id: element.id);
        TodosProductos.add(producto);
      });
      ListaProducto = true;
    }
    return documento;
  }
}
