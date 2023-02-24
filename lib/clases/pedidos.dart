import 'dart:convert';

class Contact {
  Contact({required this.id, required this.name, required this.mobile});

  int id;
  String name;
  String mobile;
}

class pedidos {
  late String Id;
  String OrdenNumero;
  String IdCliente;
  String CodigoProducto;
  String Cantidad;
  String Precio;
  String Descuento;

  pedidos(this.OrdenNumero, this.IdCliente, this.CodigoProducto, this.Cantidad,
      this.Precio, this.Descuento);
}

// To parse this JSON data, do
//
//     final pedido = pedidoFromMap(jsonString);

class Pedido {
  Pedido({
    this.id,
    required this.clienteId,
    required this.fechaOrden,
    this.numeroOrden,
    this.impuestos,
    required this.totalAPagar,
    required this.compagnia,
    required this.sincronizado,
    required this.isDelete,
  });

  int? id;
  String clienteId;
  DateTime fechaOrden;
  double? impuestos;
  double totalAPagar;
  int? numeroOrden;
  int sincronizado;
  int isDelete;
  int compagnia;

  factory Pedido.fromJson(String str) => Pedido.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pedido.fromMap(Map<String, dynamic> json) => new Pedido(
        id: json["Id"],
        clienteId: json["ClienteId"].toString().trim(),
        compagnia: json["Compagnia"],
        fechaOrden: DateTime.parse(json["FechaOrden"]),
        impuestos: json["Impuestos"].toDouble(),
        isDelete: json["IsDelete"],
        numeroOrden: json["NumeroOrden"],
        sincronizado: json["Sincronizado"],
        totalAPagar: json["totalAPagar"],
      );
  factory Pedido.fromMapsqlite(Map<String, dynamic> json) => Pedido(
        id: json["ID"],
        clienteId: json["ClienteId"].toString().trim(),
        compagnia: json["Compagnia"],
        fechaOrden: DateTime.parse(json["FechaOrden"]),
        impuestos: json["Impuestos"].toDouble(),
        isDelete: json["IsDelete"],
        numeroOrden: json["NumeroOrden"],
        sincronizado: json["Sincronizado"],
        totalAPagar: json["TotalAPagar"],
      );

  Map<String, dynamic> toMap() => {
        "ClienteId": clienteId,
        "Compagnia": compagnia,
        "FechaOrden": fechaOrden.toIso8601String(),
        "Id": id,
        "Impuestos": impuestos,
        "IsDelete": isDelete,
        "NumeroOrden": numeroOrden,
        "Sincronizado": sincronizado,
        "totalAPagar": totalAPagar,
      };

  Map<String, dynamic> toMapSqli() => {
        "ClienteId": clienteId,
        "Compagnia": compagnia,
        "FechaOrden": fechaOrden.toIso8601String(),
        "Impuestos": impuestos,
        "IsDelete": isDelete,
        "NumeroOrden": numeroOrden,
        "Sincronizado": sincronizado,
        "totalAPagar": totalAPagar,
      };
}
