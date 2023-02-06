import 'dart:convert';

Map<String, Factura> facturaFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Factura>(k, Factura.fromJson(v)));

String facturaToJson(Map<String, Factura> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Factura {
  Factura({
    required this.facturaFecha,
    required this.facturaId,
    required this.facturaVencimiento,
    required this.id,
    required this.metodoDePago,
    required this.montoFactura,
    required this.pedidosId,
    required this.totalPagado,
  });

  String? facturaFecha;
  String? facturaId;
  String? facturaVencimiento;
  int? id;
  String? metodoDePago;
  String montoFactura;
  String? pedidosId;
  int? totalPagado;

  factory Factura.fromJson(Map<String, dynamic> json) => Factura(
        facturaFecha: json["FacturaFecha"],
        facturaId: json["FacturaId"],
        facturaVencimiento: json["FacturaVencimiento"],
        id: json["Id"],
        metodoDePago: json["MetodoDePago"],
        montoFactura: json["MontoFactura"].toString(),
        pedidosId: json["PedidosId"],
        totalPagado: json["totalPagado"],
      );

  Map<String, dynamic> toJson() => {
        "FacturaFecha": facturaFecha,
        "FacturaId": facturaId,
        "FacturaVencimiento": facturaVencimiento,
        "Id": id,
        "MetodoDePago": metodoDePago,
        "MontoFactura": montoFactura,
        "PedidosId": pedidosId,
        "totalPagado": totalPagado,
      };

  Map<String, dynamic> toMap() {
    return {
      "FacturaFecha": facturaFecha,
      "FacturaId": facturaId,
      "FacturaVencimiento": facturaVencimiento,
      "Id": id,
      "MetodoDePago": metodoDePago,
      "MontoFactura": montoFactura,
      "PedidosId": pedidosId,
      "totalPagado": totalPagado,
    };
  }
}
