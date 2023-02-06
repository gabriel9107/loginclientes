import 'dart:convert' show json;

FacturaDetalleAsync facturaDetalleAsyncFromJson(String str) =>
    FacturaDetalleAsync.fromJson(json.decode(str));

String facturaDetalleAsyncToJson(FacturaDetalleAsync data) =>
    json.encode(data.toJson());

class FacturaDetalleAsync {
  FacturaDetalleAsync({
    required this.facturaNumero,
    required this.lineaNumero,
    required this.nombre,
    required this.precioDeventa,
    required this.productoCodigo,
    required this.qty,
    required this.montoLinea,
  });

  String facturaNumero;
  int lineaNumero;
  String nombre;
  double precioDeventa;
  String productoCodigo;
  int qty;
  double montoLinea;

  factory FacturaDetalleAsync.fromJson(Map<String, dynamic> json) =>
      FacturaDetalleAsync(
        facturaNumero: json["FacturaNumero"],
        lineaNumero: json["LineaNumero"],
        nombre: json["Nombre"],
        precioDeventa: json["PrecioDeventa"]?.toDouble(),
        productoCodigo: json["ProductoCodigo"],
        qty: json["Qty"],
        montoLinea: json["montoLinea"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "FacturaNumero": facturaNumero,
        "LineaNumero": lineaNumero,
        "Nombre": nombre,
        "PrecioDeventa": precioDeventa,
        "ProductoCodigo": productoCodigo,
        "Qty": qty,
        "montoLinea": montoLinea,
      };

  Map<String, dynamic> toMap() {
    return {
      "FacturaNumero": facturaNumero,
      "LineaNumero": lineaNumero,
      "Nombre": nombre,
      "PrecioDeventa": precioDeventa,
      "ProductoCodigo": productoCodigo,
      "Qty": qty,
      "montoLinea": montoLinea,
    };
  }
}
