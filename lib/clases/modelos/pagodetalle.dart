// To parse this JSON data, do
//
//     final pagodetalle = pagodetalleFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/servicios/db_helper.dart';

List<Pagodetalle?> pagodetalleFromJson(String str) => List<Pagodetalle?>.from(
    json.decode(str).map((x) => x == null ? null : Pagodetalle.fromJson(x)));

String pagodetalleToJson(List<Pagodetalle?> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x?.toJson())));

class Pagodetalle {
  Pagodetalle({
    required this.activo,
    required this.fechaEmision,
    required this.fechavencimiento,
    required this.montoPagado,
    required this.numeroDeFactura,
    required this.pago,
    required this.valorfactura,
    required this.valorpendiente,
  });

  int activo;
  DateTime fechaEmision;
  DateTime fechavencimiento;
  double montoPagado;
  String numeroDeFactura;
  int pago;
  double valorfactura;
  double valorpendiente;

  factory Pagodetalle.fromJson(Map<String, dynamic> json) => Pagodetalle(
        activo: json["activo"],
        fechaEmision: DateTime.parse(json["fechaEmision"]),
        fechavencimiento: DateTime.parse(json["fechavencimiento"]),
        montoPagado: json["montoPagado"]?.toDouble(),
        numeroDeFactura: json["numeroDeFactura"],
        pago: json["pago"],
        valorfactura: json["valorfactura"]?.toDouble(),
        valorpendiente: json["valorpendiente"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "activo": activo,
        "fechaEmision": fechaEmision.toIso8601String(),
        "fechavencimiento": fechavencimiento.toIso8601String(),
        "montoPagado": montoPagado,
        "numeroDeFactura": numeroDeFactura,
        "pago": pago,
        "valorfactura": valorfactura,
        "valorpendiente": valorpendiente,
      };

  static List<Pagodetalle> pagos = [];

  static void agregarFacturasaPagos(Pagodetalle pago) {
    return pagos.add(pago);
  }

  static List<Pagodetalle> getDetalleFactura() {
    return pagos;
  }

  static actualizardetalle(int index, double? monto) {
    if (monto != null) {
      pagos[index].montoPagado = monto;
    }
  }

  static eliminarpago(int index) {
    pagos.removeAt(index);
    pagos.remove(index);
    return null;
  }

  static double obtenerSubtotal() {
    if (pagos.length > 0) {
      double monto = pagos
          .map((e) => e.montoPagado)
          .reduce((value, element) => value + element);
      if (monto != 0) {
        return monto;
      }
    }
    return 0;
  }

  static ActualizarFacutas() {
    pagos.forEach((element) {
      actualizarMontoFactura(
          element.numeroDeFactura, element.montoPagado.toString());
    });
  }

  static void actualizarMontoFactura(String numerofactura, String montoPagado) {
    DatabaseHelper.instance.actualizarMontoFactura(numerofactura, montoPagado);
  }
}
