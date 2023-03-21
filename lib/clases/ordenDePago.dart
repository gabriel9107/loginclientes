// To parse this JSON data, do
//
//     final ordenDepPago = ordenDepPagoFromJson(jsonString);

import 'dart:convert';

List<OrdenDepPago?> ordenDepPagoFromJson(String str) =>
    List<OrdenDepPago?>.from(json
        .decode(str)
        .map((x) => x == null ? null : OrdenDepPago.fromJson(x)));

String ordenDepPagoToJson(List<OrdenDepPago?> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x?.toJson())));

class OrdenDepPago {
  OrdenDepPago({
    required this.abierto,
    required this.activo,
    required this.clienteNumero,
    required this.fechaCheque,
    required this.fechaPago,
    required this.id,
    required this.importado,
    required this.monto,
    required this.vendedor,
    this.nombreBanco,
  });

  String abierto;
  String activo;
  String clienteNumero;
  String fechaCheque;
  String fechaPago;
  int id;
  String importado;
  String monto;
  String vendedor;
  String? nombreBanco;

  factory OrdenDepPago.fromJson(Map<String, dynamic> json) => OrdenDepPago(
        abierto: json["Abierto"],
        activo: json["Activo"],
        clienteNumero: json["ClienteNumero"],
        fechaCheque: json["FechaCheque"],
        fechaPago: json["FechaPago"],
        id: json["Id"],
        importado: json["Importado"],
        monto: json["Monto"],
        vendedor: json["Vendedor"],
        nombreBanco: json["NombreBanco"],
      );

  Map<String, dynamic> toJson() => {
        "Abierto": abierto,
        "Activo": activo,
        "ClienteNumero": clienteNumero,
        "FechaCheque": fechaCheque,
        "FechaPago": fechaPago,
        "Id": id,
        "Importado": importado,
        "Monto": monto,
        "Vendedor": vendedor,
        "NombreBanco": nombreBanco,
      };
}
