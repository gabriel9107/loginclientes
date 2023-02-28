// To parse this JSON data, do
//
//     final pedidoDetalle = pedidoDetalleFromMap(jsonString);

import 'dart:convert';

class PedidoDetalle {
  PedidoDetalle({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    this.productoId,
    required this.pedidoId,
    required this.compagnia,
    required this.isDelete,
    required this.sincronizado,
  });

  int? id;
  String codigo;
  String nombre;
  int cantidad;
  double precio;
  int? productoId;
  String pedidoId;
  int sincronizado;
  int compagnia;
  int isDelete;

  factory PedidoDetalle.fromJson(String str) =>
      PedidoDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PedidoDetalle.fromMap(Map<String, dynamic> json) => new PedidoDetalle(
        cantidad: json["Cantidad"],
        compagnia: json["Compagnia"],
        id: json["Id"],
        isDelete: json["IsDelete"],
        pedidoId: json["PedidoId"].toString(),
        precio: json["Precio"].toDouble(),
        productoId: json["ProductoId"],
        sincronizado: json["Sincronizado"],
        codigo: json["Codigo"],
        nombre: json["Nombre"],
      );

  factory PedidoDetalle.toMapSqli(Map<String, dynamic> json) => PedidoDetalle(
        cantidad: json["Cantidad"],
        compagnia: json["Compagnia"],
        isDelete: json["IsDelete"],
        pedidoId: json["PedidoId"],
        precio: json["Precio"].toDouble(),
        productoId: json["ProductoId"],
        sincronizado: json["Sincronizado"],
        codigo: json["Codigo"],
        nombre: json["Nombre"],
      );
  factory PedidoDetalle.fromMapSql(Map<String, dynamic> json) => PedidoDetalle(
        cantidad: json["Cantidad"],
        compagnia: json["Compagnia"],
        isDelete: json["IsDelete"],
        pedidoId: json["PedidoId"],
        precio: json["Precio"].toDouble(),
        productoId: json["ProductoId"],
        sincronizado: json["Sincronizado"],
        codigo: json["Codigo"],
        nombre: json["Nombre"],
      );

  Map<String, dynamic> toMap() => {
        "Cantidad": cantidad,
        "Compagnia": compagnia,
        "Id": id,
        "IsDelete": isDelete,
        "PedidoId": pedidoId,
        "Precio": precio,
        "ProductoId": productoId,
        "Sincronizado": sincronizado,
        "Codigo": codigo,
        "Nombre": nombre,
      };
  Map<String, dynamic> toMapInsert() => {
        "Cantidad": cantidad,
        "Compagnia": compagnia,
        "IsDelete": isDelete,
        "PedidoId": pedidoId,
        "Precio": precio,
        "ProductoId": productoId,
        "Sincronizado": sincronizado,
        "Codigo": codigo,
        "Nombre": nombre,
      };
}
