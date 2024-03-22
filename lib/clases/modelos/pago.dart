import 'dart:convert';

import 'package:sigalogin/clases/api/facturaRecibo.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/pantallas/Pagos/pago.dart';
import 'package:sigalogin/pantallas/Pagos/pagosForm.dart';

import '../../servicios/db_helper.dart';
import '../factura.dart';

Map<String, Pago> pagoFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Pago>(k, Pago.fromJson(v)));

String pagoToJson(Map<String, Pago> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class PagoReporte {
  int? id;
  late String vendorId;
  String? banco;
  String? numeroDeCheque;
  late String fechaPago;
  late String clienteId;
  late String nombreCliente;
  String? fechaDeCheque;
  String? metodoDePago;
  late double montoPagado;
  late int pendiente;
  late int compania;
  late int sincronizado;
  late int isDelete;
  String? estado;
  String? idFirebase;
  String? facturaId;

  PagoReporte(
      {this.id,
      this.banco,
      required this.clienteId,
      required this.facturaId,
      required this.nombreCliente,
      required this.compania,
      this.fechaDeCheque,
      required this.fechaPago,
      required this.isDelete,
      required this.metodoDePago,
      required this.montoPagado,
      required this.pendiente,
      required this.sincronizado,
      required this.vendorId,
      this.numeroDeCheque,
      this.estado,
      this.idFirebase});

  factory PagoReporte.fromMapSqlLiteWitId(Map<String, dynamic> json) =>
      PagoReporte(
        id: json["id"],
        clienteId: json["clienteId"],
        nombreCliente: json["nombre"],
        banco: json["banco"],
        numeroDeCheque: json["numeroDeCheque"],
        fechaDeCheque: json["fechaDeCheque"],
        fechaPago: json["fechaPago"],
        facturaId: json["facturaId"],
        metodoDePago: json["MetodoDePago"],
        montoPagado: json["montoPagado"]?.toDouble(),
        pendiente: 0,
        vendorId: json["vendorId"],
        compania: json["compagni"],
        sincronizado: json["sincronizado"],
        isDelete: json["isDelete"],
      );
  String getIndex(int index) {
    switch (index) {
      // //id
      case 0:
        return id.toString();
      //compagnia
      case 1:
        return compania == 1 ? "Siga " : "New";

      //Codigo del cliente o Cliente Id
      case 2:
        // //Codigo
        return clienteId.toString().trimLeft().trimRight();
        ;
      // Nombre
      case 3:
        return nombreCliente.toString().trimLeft().trimRight();
        ;
// Fecha recibo
      case 4:
        return fechaPago.toString().substring(0, 10).trimLeft().trimRight();
// //Monto recibido
      case 5:
        return montoPagado.toStringAsFixed(2).trimLeft().trimRight();
        ;
// factura
      case 6:
        return facturaId.toString().trimLeft().trimRight();
        ;
// Tipo de Pago
      case 7:
        return metodoDePago.toString().trimLeft().trimRight();
        ;
      //so[]porte
      case 8:
        return '__________';
    }
    return '';
  }
}

class Pago {
  String getIndex(int index) {
    switch (index) {
      // //id
      case 0:
        return id.toString();

      //Codigo del cliente o Cliente Id
      case 1:
        // //Codigo
        return clienteId.toString();
      // Nombre
      case 2:
        return id.toString();
// Fecha recibo
      case 3:
        return fechaPago.toString().substring(1, 10);
// //Monto recibido
      case 4:
        return montoPagado.toStringAsFixed(2);
// factura
      case 5:
        return factura.toString();
// Tipo de Pago
      case 6:
        return metodoDePago.toString();
      //so[]porte
      case 7:
        return '______________';
    }
    return '';
  }

  Pago(
      {this.id,
      this.banco,
      required this.clienteId,
      required this.compania,
      this.fechaDeCheque,
      required this.fechaPago,
      required this.isDelete,
      required this.metodoDePago,
      required this.montoPagado,
      required this.pendiente,
      required this.sincronizado,
      required this.vendorId,
      this.numeroDeCheque,
      this.estado,
      this.idFirebase});

  int? id;
  String vendorId;
  String? banco;
  String? numeroDeCheque;
  String fechaPago;
  String clienteId;
  String? fechaDeCheque;
  String? metodoDePago;
  double montoPagado;
  int pendiente;
  int compania;
  int sincronizado;
  int isDelete;
  String? estado;
  String? idFirebase;

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        banco: json["Banco"]!,
        clienteId: json["ClienteId"],
        compania: json["Compagni"],
        fechaDeCheque: json["FechaDeCheque"],
        fechaPago: json["FechaPago"],
        id: json["ID"],
        isDelete: json["IsDelete"],
        metodoDePago: json["MetodoDePago"]!,
        montoPagado: json["MontoPagado"]?.toDouble(),
        pendiente: json["Pendiente"],
        sincronizado: json["Sincronizado"],
        vendorId: json["VendorID"],
        numeroDeCheque: json["NumeroDeCheque"],
      );

  Map<String, dynamic> toJsonFire() => {
        "Banco": banco,
        "ClienteId": clienteId,
        "compagni": compania,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "MontoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": 0,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };

  Map<String, dynamic> toJson() => {
        "Banco": banco,
        "ClienteId": clienteId,
        "Compagni": compania,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "montoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };
  Map<String, dynamic> toJsonsql2() => {
        "Banco": banco,
        "ClienteId": clienteId,
        "compagni": compagnia,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "montoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };
  Map<String, dynamic> toJsonsql() => {
        "id": id,
        "Banco": banco,
        "ClienteId": clienteId,
        "Compagni": compagnia,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "montoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };
  Map<String, dynamic> toJsonsqlinsert() => {
        "Banco": banco,
        "ClienteId": clienteId,
        "Compagni": compania,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "montoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };

  Map<String, dynamic> toInsertSql() => {
        "Banco": banco,
        "ClienteId": clienteId,
        "compagni": compania,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "montoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };

  //insertando pago descargado de firebase
  factory Pago.fromMapInsert(Map<String, dynamic> json) => Pago(
        clienteId: json["ClienteId"].toString(),
        banco: json["Banco"],
        numeroDeCheque: json["NumeroDeCheque"],
        fechaDeCheque: json["FechaDeCheque"],
        fechaPago: json["FechaPago"],
        metodoDePago: json["MetodoDePago"],
        montoPagado: json["montoPagado"]?.toDouble(),
        pendiente: json["Pendiente"],
        vendorId: json["VendorID"],
        compania: json["Compagni"],
        estado: json["Estado"],
        sincronizado: json["Sincronizado"],
        isDelete: 1,
      );

  factory Pago.fromMap(Map<String, dynamic> json) => Pago(
        id: json["ID"],
        clienteId: json["ClienteId"].toString(),
        banco: json["Banco"],
        numeroDeCheque: json["NumeroDeCheque"],
        fechaDeCheque: json["FechaDeCheque"],
        fechaPago: json["FechaPago"],
        metodoDePago: json["MetodoDePago"],
        montoPagado: json["montoPagado"]?.toDouble(),
        pendiente: json["Pendiente"],
        vendorId: json["VendorID"],
        compania: json["compagni"],
        estado: json["Estado"],
        sincronizado: json["Sincronizado"],
        isDelete: 1,
      );

  factory Pago.fromMapSqlLiteWitId(Map<String, dynamic> json) => Pago(
        id: json["id"],
        clienteId: json["clienteId"],
        banco: json["banco"],
        numeroDeCheque: json["numeroDeCheque"],
        fechaDeCheque: json["fechaDeCheque"],
        fechaPago: json["fechaPago"],
        metodoDePago: json["MetodoDePago"],
        montoPagado: json["montoPagado"]?.toDouble(),
        pendiente: 0,
        vendorId: json["vendorId"],
        compania: json["compagni"],
        sincronizado: json["sincronizado"],
        isDelete: json["isDelete"],
      );
  factory Pago.fromMapSqlLite(Map<String, dynamic> json) => Pago(
        clienteId: json["clienteId"],
        banco: json["banco"],
        numeroDeCheque: json["numeroDeCheque"],
        fechaDeCheque: json["fechaDeCheque"],
        fechaPago: json["fechaPago"],
        metodoDePago: json["MetodoDePago"],
        montoPagado: json["montoPagado"]?.toDouble(),
        pendiente: 0,
        vendorId: json["vendorId"],
        compania: json["compagni"],
        sincronizado: json["sincronizado"],
        isDelete: json["isDelete"],
      );
  static List<Pago> pagos = [];

  static var pago = Pago(
      clienteId: 'null',
      compania: compagnia,
      fechaPago: DateTime.now().toString(),
      id: 1,
      isDelete: 0,
      metodoDePago: 'metodoDePago',
      montoPagado: 0.0,
      pendiente: 1,
      sincronizado: 0,
      vendorId: 'vendorId',
      estado: 'Pendiente');
// 22301591404
  static actualizarpago(String clienteId, metodoDePago) {
    pago.clienteId = clienteId;
    pago.metodoDePago = metodoDePago;
    pago.vendorId = usuario;

    // pago.clienteNombre = update.clienteId;
    // pago.formadePago = update.;
    // pago.banco = update.banco;
    // pago.valordelpago = update.valordelpago;
    // pago.numeroDeCheque = update.numeroDeCheque;
    // pago.fechaCheque = update.fechaCheque;
  }

  static agregarpago(Pago pago) {
    pagos.add(pago);
  }

  static actualizarmontodelpago(double monto) {
    pago.montoPagado = monto;
  }

  // static actualizarmontodelpago(String monto) {
  //   double valor = double.parse(monto);
  //   // pago.metodoDePago
  //   pago.montoPagado = valor;
  // }

  static obtenermontodelpago() {
    if (pago.montoPagado == 0.0) {
      return 0.0;
    }
    return pago.montoPagado;
    // pago.valordelpago;
  }

  static eliminartotalpago() {
    pago.montoPagado = 0;
  }

  static obtenerCliente() {
    return pago.clienteId;
  }

  static eliminarPago(int index) {
    pagos.clear();
  }

  // static Future obtenerFacturasPorCLiente() async {
  //   var clienteId = pago.clienteId;
  //   var facturas = DatabaseHelper.instance.getFacturasporClientes(clienteId)
  //       as List<Factura>;
  //   facturas.forEach((factura) {
  //     TodasLasFacturas.add(factura);
  //   });
  // }

  List<Factura> factura = [];
  static Future obtenerFacturas() async {
    // TodasLasFacturas.clear();
    var clienteId = pago.clienteId;
    var documento = await DatabaseHelper.instance
        .getFacturasporClientes(clienteId) as List<Factura>;

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
            totalPagado: element.totalPagado,
            clienteNombre: '',
            compagnia: compagnia,
            isDelete: 0,
            montoPendiente: (element.montoPendiente - element.montoFactura),
            pedidoId: element.pedidoId,
            sincronizado: element.sincronizado,
            vendedorId: usuario);

        TodasLasFacturas.add(a);
      });
      ListasFactura = true;
    }
    // TodosProductos.add(documento);
    // Lista.add(documento);
    return documento;
  }

  static void guardarPago() {
    //crear ticket de impresion

    var formaDePago = pago.metodoDePago.toString();

    DatabaseHelper.instance
        .agregarPagoconID(pago)
        .then((value) => PagoTemporal.guardarDetallePago(value, formaDePago));

    // Pagodetalle.ActualizarFacutas();
  }

  static Future<String> guardarPagoConID(Pago pagotemp) async {
    var result;
    var formaDePago = pago.metodoDePago.toString();

    obtenermontodelpago();

    var reciboid = await DatabaseHelper.instance
        .agregarPagoconID(pagotemp)
        .then((value) => {
              PagoTemporal.guardarDetallePago(value, formaDePago),
              result = value,
            });

    // => PagoTemporal.guardarDetallePago(value, formaDePago));

    return result.toString();
  }
}
