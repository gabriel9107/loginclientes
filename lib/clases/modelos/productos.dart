import 'dart:convert';

import 'package:http/http.dart';

List<Producto?> productoFromJson(String str) => List<Producto?>.from(
    json.decode(str).map((x) => x == null ? null : Producto.fromJson(x)));

String productoToJson(List<Producto?> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x?.toJson())));

class Producto {
  Producto({
    required this.compagnia,
    this.id,
    required this.isDelete,
    required this.nombre,
    required this.ouM,
    required this.price,
    required this.productoCodigo,
    required this.qty,
    required this.sincronizado,
    required this.typeOfSales,
  });

  String? compagnia;
  int? id;
  String? isDelete;
  String? nombre;
  String? ouM;
  String? price;
  String? productoCodigo;
  String? qty;
  String? sincronizado;
  String? typeOfSales;

  factory Producto.fromMap(Map<String, dynamic> json) => new Producto(
      compagnia: json["Compagnia"],
      isDelete: json["IsDelete"],
      nombre: json["Nombre"],
      ouM: json["OuM"],
      price: json["Price"],
      productoCodigo: json["ProductoCodigo"],
      qty: json["Qty"],
      sincronizado: json["Sincronizado"],
      typeOfSales: json["TypeOfSales"]);

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        compagnia: json["Compagnia"],
        isDelete: json["IsDelete"],
        nombre: json["Nombre"],
        ouM: json["OuM"],
        price: json["Price"],
        productoCodigo: json["ProductoCodigo"],
        qty: json["Qty"],
        sincronizado: json["Sincronizado"],
        typeOfSales: json["TypeOfSales"],
      );

  Map<String, dynamic> toMap() {
    return {
      'Compagnia': compagnia,
      'Id': id,
      'IsDelete': isDelete,
      'Nombre': nombre,
      'OuM': ouM,
      'Price': price,
      'ProductoCodigo': productoCodigo,
      'Qty': qty,
      'Sincronizado': sincronizado,
      'TypeOfSales': typeOfSales,
    };
  }

  Map<String, dynamic> toJson() => {
        "Compagnia": compagnia,
        "Id": id,
        "IsDelete": isDelete,
        "Nombre": nombre,
        "OuM": ouM,
        "Price": price,
        "ProductoCodigo": productoCodigo,
        "Qty": qty,
        "Sincronizado": sincronizado,
        "TypeOfSales": typeOfSales,
      };
}
