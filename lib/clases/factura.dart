import 'dart:convert';
import 'global.dart';
import 'package:sigalogin/pantallas/clientes/detalleDelCLiente.dart';

import '../servicios/db_helper.dart';

Map<String, Factura> facturaFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Factura>(k, Factura.fromJson(v)));

String facturaToJson(Map<String, Factura> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Factura {
  Factura({
    required this.id,
    required this.clienteId,
    required this.facturaFecha,
    required this.facturaId,
    required this.facturaVencimiento,
    required this.metodoDePago,
    required this.montoFactura,
    required this.pedidosId,
    required this.totalPagado,
  });

  int? id;
  int clienteId;
  String? facturaFecha;
  String? facturaId;
  String? facturaVencimiento;
  String? metodoDePago;
  String montoFactura;

  String? pedidosId;
  int? totalPagado;

  factory Factura.fromJson(Map<String, dynamic> json) => Factura(
        id: json["Id"],
        clienteId: 7488803,
        facturaFecha: json["FacturaFecha"],
        facturaId: json["FacturaId"],
        facturaVencimiento: json["FacturaVencimiento"],
        metodoDePago: json["MetodoDePago"],
        montoFactura: json["MontoFactura"].toString(),
        pedidosId: json["PedidosId"],
        totalPagado: json["totalPagado"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "clienteId": clienteId,
        "FacturaFecha": facturaFecha,
        "FacturaId": facturaId,
        "FacturaVencimiento": facturaVencimiento,
        "MetodoDePago": metodoDePago,
        "MontoFactura": montoFactura,
        "PedidosId": pedidosId,
        "totalPagado": totalPagado,
      };

  Map<String, dynamic> toMap() {
    return {
      "Id": id,
      "clienteId": clienteId,
      "FacturaFecha": facturaFecha,
      "FacturaId": facturaId,
      "FacturaVencimiento": facturaVencimiento,
      "MetodoDePago": metodoDePago,
      "MontoFactura": montoFactura,
      "PedidosId": pedidosId,
      "totalPagado": totalPagado,
    };
  }

  static List<Factura> facturatemp = <Factura>[];

  static void addfacturaDetalle(Factura detalle) {
    facturatemp.add(detalle);
    print('detalle de factura');
    print(facturatemp.length);
  }

  static List<Factura> obtenerfacturadetalle() {
    return facturatemp;
  }

  List<Factura> factura = [];
  static Future obtenerFacturas() async {
    var documento =
        await DatabaseHelper.instance.getFacturas() as List<Factura>;

    if (ListasFactura == false) {
      documento.forEach((element) {
        Factura a = new Factura(
            id: element.id,
            clienteId: element.clienteId,
            facturaFecha: element.facturaFecha,
            facturaId: element.facturaId,
            facturaVencimiento: element.facturaVencimiento,
            metodoDePago: element.metodoDePago,
            montoFactura: element.montoFactura,
            pedidosId: element.pedidosId,
            totalPagado: element.totalPagado);
        TodasLasFacturas.add(a);
      });
      ListasFactura = true;
    }
    // TodosProductos.add(documento);
    // Lista.add(documento);
    return documento;
  }
}
