import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/ordenDeventa.dart';
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import 'formatos.dart';

class FacturaMaster {
  late int iD;
  String facturaNumero;
  String idClienteFactura;
  // DateTime fechaFactura;
  int cantidadArticulos;
  String subtotal;
  String montoDescuento;
  double montoImpuesto;
  double totalApagar;

  FacturaMaster(
      {required this.iD,
      required this.idClienteFactura,
      // required this.fechaFactura,
      required this.facturaNumero,
      required this.cantidadArticulos,
      required this.montoDescuento,
      required this.montoImpuesto,
      required this.subtotal,
      required this.totalApagar});

  static totales() {
    int facturaNumeriI = 1;
    int cantidadArticulos = 0;
    Double montoDescuento;
    int descuentoI = 0;

    double impuestoI;
    double impuesto = 0;
    double descuento = 0;

    double subtotal = 0;

    double totalApagar = 0;

    descuentoI = 10;

    if (FacturaDetalle.getFacturaDetalle().isEmpty) {
      return FacturaMaster(
          cantidadArticulos: cantidadArticulos,
          facturaNumero: "1",
          iD: 1,
          idClienteFactura: "1",
          montoDescuento: numberFormat(descuento),
          montoImpuesto: impuesto,
          subtotal: numberFormat(subtotal),
          totalApagar: totalApagar);
    }
    cantidadArticulos = FacturaDetalle.getFacturaDetalle()
        .map((e) => e.cantidadProducto)
        .reduce((value, element) => value + element)
        .toInt();

    subtotal = FacturaDetalle.getFacturaDetalle()
        .map((e) => e.montoLinea)
        .reduce((value, element) => value + element);

    // subtotal = (FacturaDetalle.getFacturaDetalle()
    //         .map((e) => e.montoproducto)
    //         .reduce((value, element) => value + element) *
    //     cantidadArticulos);

    descuento = 0;
    // descuento = ((subtotal * descuentoI) / 1000).toDouble();

    impuestoI = 5;

    compagnia == 0 ? impuesto = ((subtotal * 18) / 1000).toDouble() : 0;
    // impuesto = 0;

    totalApagar = ((subtotal - descuento) + impuesto);

    return FacturaMaster(
        cantidadArticulos: cantidadArticulos,
        facturaNumero: facturaNumeriI.toString(),
        iD: 1,
        idClienteFactura: "1",
        montoDescuento: numberFormat(descuento),
        montoImpuesto: impuesto,
        subtotal: numberFormat(subtotal),
        totalApagar: totalApagar);
  }

  int impuestoPorEmpleador() {
    return 18;
  }

  double get descuentoPorEmpleador {
    return 10.0;
  }
}

class FacturaDetalle {
  late String facturaNumero;
  String codigoProducto;
  String nombreProducto;
  double montoproducto;
  int cantidadProducto;
  double montoLinea;

  FacturaDetalle(
      {required this.facturaNumero,
      required this.codigoProducto,
      required this.montoproducto,
      required this.nombreProducto,
      required this.cantidadProducto,
      required this.montoLinea});

  static List<FacturaDetalle> facturaDetalle = <FacturaDetalle>[];

  static void addfacturaDetalle(FacturaDetalle detalle) {
    var contain = facturaDetalle
            .any((element) => element.codigoProducto == detalle.codigoProducto)
        ? actualizarcantidadProducto(detalle)
        : facturaDetalle.add(detalle);
  }

  static void actualizarcantidadProducto(FacturaDetalle detalle) {
    facturaDetalle[facturaDetalle.indexWhere(
        (element) => element.facturaNumero == detalle.facturaNumero)] = detalle;
  }

  static List<FacturaDetalle> getFacturaDetalle() {
    return facturaDetalle.toList();
  }

  static actualiarLinea(var index) {
    facturaDetalle[index].montoLinea = facturaDetalle[index].montoproducto *
        facturaDetalle[index].cantidadProducto;
  }

  static bool limpiarfacturas() {
    facturaDetalle.clear();
    return true;
  }

  static remover(var index) {
    facturaDetalle.removeAt(index);
  }

  static void guardarPedido(Pedido orden, List<PedidoDetalle> ordendetalle) {
    DatabaseHelper.instance.AgregarPedido(orden);

    ordendetalle.forEach((element) {
      DatabaseHelper.instance.AgregarPedidoDetalle(element);
    });
  }
}
