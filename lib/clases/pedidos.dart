import 'dart:convert';

import 'package:http/http.dart';
import 'package:sigalogin/clases/global.dart';

class Contact {
  Contact({required this.id, required this.name, required this.mobile});

  int id;
  String name;
  String mobile;
}

class pedidos {
  late String Id;
  String NumeroOrden;
  String IdCliente;
  String CodigoProducto;
  String Cantidad;
  String Precio;
  String Descuento;

  pedidos(this.NumeroOrden, this.IdCliente, this.CodigoProducto, this.Cantidad,
      this.Precio, this.Descuento);
}

// To parse this JSON data, do
//
//     final pedido = pedidoFromMap(jsonString);

class PedidoLista {
  int? id;
  String clienteId;
  String clienteNombre;
  DateTime fechaOrden;
  double impuestos;
  double totalAPagar;
  String? numeroOrden;
  int sincronizado;
  int isDelete;
  int compagnia;
  String? estado;
  String? vendorId;
  String? idfirebase;

  PedidoLista(
      {this.id,
      required this.clienteId,
      required this.clienteNombre,
      required this.fechaOrden,
      this.numeroOrden,
      required this.impuestos,
      required this.totalAPagar,
      required this.compagnia,
      required this.sincronizado,
      required this.isDelete,
      this.estado,
      this.vendorId,
      this.idfirebase});

  factory PedidoLista.fromMapsqlite(Map<String, dynamic> json) => PedidoLista(
      id: json["ID"],
      clienteId: json["ClienteId"].toString().trim(),
      clienteNombre: json["clienteNombre"].toString().trim(),
      compagnia: json["Compagnia"],
      fechaOrden: DateTime.parse(json["FechaOrden"]),
      impuestos: json["Impuestos"],
      isDelete: json["IsDelete"],
      numeroOrden: json["NumeroOrden"],
      sincronizado: json["Sincronizado"],
      totalAPagar: json["TotalAPagar"],
      vendorId: json["vendorId"]);
}

class Pedido {
  Pedido(
      {this.id,
      required this.clienteId,
      required this.clienteNombre,
      required this.fechaOrden,
      this.numeroOrden,
      required this.impuestos,
      required this.totalAPagar,
      required this.compagnia,
      required this.sincronizado,
      required this.isDelete,
      this.estado,
      this.vendorId,
      this.idfirebase});

  int? id;
  String clienteId;
  String clienteNombre;
  DateTime fechaOrden;
  double impuestos;
  double totalAPagar;
  String? numeroOrden;
  int sincronizado;
  int isDelete;
  int compagnia;
  String? estado;
  String? vendorId;
  String? idfirebase;

  factory Pedido.fromJson(String str) => Pedido.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toJsonUp() => {
        "ClienteId": clienteId,
        "clienteNombre": clienteNombre,
        "Compagnia": compagnia,
        "FechaOrden": fechaOrden.toIso8601String(),
        "Id": id,
        "Impuestos": impuestos,
        "IsDelete": isDelete,
        "NumeroOrden": numeroOrden,
        "Sincronizado": sincronizado,
        "totalAPagar": totalAPagar,
        "Estado": estado
      };

  factory Pedido.fromMap(Map<String, dynamic> json) => Pedido(
        id: json["Id"],
        clienteId: json["ClienteId"].toString().trim(),
        compagnia: json["Compagnia"],
        fechaOrden: DateTime.parse(json["FechaOrden"]),
        impuestos: json["Impuestos"].toDouble(),
        isDelete: json["IsDelete"],
        numeroOrden: json["NumeroOrden"],
        sincronizado: json["Sincronizado"],
        totalAPagar: json["totalAPagar"],
        clienteNombre: json["clienteNombre"],
      );
  factory Pedido.fromMapsqlite(Map<String, dynamic> json) => Pedido(
      id: json["ID"],
      clienteId: json["ClienteId"].toString().trim(),
      compagnia: json["Compagnia"],
      fechaOrden: DateTime.parse(json["FechaOrden"]),
      impuestos: json["Impuestos"],
      isDelete: json["IsDelete"],
      numeroOrden: json["NumeroOrden"],
      sincronizado: json["Sincronizado"],
      totalAPagar: json["TotalAPagar"],
      vendorId: json["vendorId"],
      clienteNombre: json["clienteNombre"]);

  Map<String, dynamic> toMap() => {
        "ClienteId": clienteId,
        "clienteNombre": clienteNombre,
        "Compagnia": compagnia,
        "FechaOrden": fechaOrden.toIso8601String(),
        "Id": id,
        "Impuestos": impuestos,
        "IsDelete": isDelete,
        "NumeroOrden": numeroOrden,
        "Sincronizado": sincronizado,
        "totalAPagar": totalAPagar,
        "Estado": estado
      };

  Map<String, dynamic> toMapSql() => {
        "ClienteId": clienteId,
        "clienteNombre": clienteNombre,
        "Compagnia": compagnia,
        "FechaOrden": fechaOrden.toIso8601String(),
        "Impuestos": impuestos,
        "IsDelete": isDelete,
        "NumeroOrden": numeroOrden,
        "Sincronizado": sincronizado,
        "totalAPagar": totalAPagar,
        "Estado": estado,
        "vendorId": usuario,
      };

  Map<String, dynamic> toMapSqli() => {
        "ClienteId": clienteId,
        "clienteNombre": clienteNombre,
        "Compagnia": compagnia,
        "FechaOrden": fechaOrden.toIso8601String(),
        "Impuestos": impuestos,
        "IsDelete": isDelete,
        "NumeroOrden": numeroOrden,
        "Sincronizado": sincronizado,
        "totalAPagar": totalAPagar,
        "Estado": estado,
        "vendorId": usuario,
        "idfirebase": idfirebase,
      };
}
