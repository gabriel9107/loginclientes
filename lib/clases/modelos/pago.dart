// import 'dart:convert';

// import 'package:sigalogin/clases/global.dart';
// import 'package:sigalogin/clases/modelos/pagodetalle.dart';
// import 'package:sigalogin/servicios/db_helper.dart';

// List<Pago?> pagoFromJson(String str) => List<Pago?>.from(
//     json.decode(str).map((x) => x == null ? null : Pago.fromJson(x)));

// String pagoToJson(List<Pago?> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x?.toJson())));

// class Pago {
//   Pago({
//     this.banco,
//     required this.clienteId,
//     required this.clienteNombre,
//     this.fechaCheque,
//     required this.formadePago,
//     this.id,
//     this.numeroDeCheque,
//     required this.valordelpago,
//     required this.vendedor,
//   });

//   String? banco;
//   int clienteId;
//   String clienteNombre;
//   DateTime? fechaCheque;
//   String formadePago;
//   int? id;
//   int? numeroDeCheque;
//   double valordelpago;
//   String vendedor;

//   factory Pago.fromMap(Map<String, dynamic> json) => Pago(
//         banco: json['banco'],
//         clienteId: json['clienteId'],
//         clienteNombre: json['clienteNombre'],
//         fechaCheque: json['fechaCheque'] as DateTime?,
//         formadePago: json['formadePago'],
//         id: json['id'],
//         numeroDeCheque: json['numeroDeCheque'],
//         valordelpago: double.parse(json['valordelpago']),
//         vendedor: json['vendedor'],
//       );

//   factory Pago.fromJson(Map<String, dynamic> json) => Pago(
//         banco: json["banco"],
//         clienteId: json["clienteId"],
//         clienteNombre: json["clienteNombre"],
//         fechaCheque: DateTime.parse(json["fechaCheque"]),
//         formadePago: json["formadePago"],
//         id: json["id"],
//         numeroDeCheque: json["numeroDeCheque"],
//         valordelpago: json["valordelpago"],
//         vendedor: json["vendedor"],
//       );

//   Map<String, dynamic> toJson() => {
//         "banco": banco,
//         "clienteId": clienteId,
//         "clienteNombre": clienteNombre,
//         "fechaCheque": fechaCheque?.toIso8601String(),
//         "formadePago": formadePago,
//         "id": id,
//         "numeroDeCheque": numeroDeCheque,
//         "valordelpago": valordelpago,
//         "vendedor": vendedor,
//       };

//   Map<String, dynamic> toMap() {
//     return {
//       'banco': banco,
//       'clienteId': clienteId,
//       'clienteNombre': clienteNombre,
//       'fechaCheque': fechaCheque?.toIso8601String(),
//       'formadePago': formadePago,
//       'id': id,
//       'numeroDeCheque': numeroDeCheque,
//       'valordelpago': valordelpago,
//       'vendedor': vendedor,
//     };
//   }

//   static var pago = new Pago(
//       formadePago: "1",
//       valordelpago: 0,
//       clienteId: 0,
//       clienteNombre: '',
//       vendedor: usuario);

//   static List<Pago> pagos = [];

//   static actualizarpago(Pago update) {
//     pago.clienteId = update.clienteId;
//     pago.clienteNombre = update.clienteNombre;
//     pago.formadePago = update.formadePago;
//     pago.banco = update.banco;
//     pago.valordelpago = update.valordelpago;
//     pago.numeroDeCheque = update.numeroDeCheque;
//     pago.fechaCheque = update.fechaCheque;
//   }

//   static agregarpago(Pago pago) {
//     pagos.add(pago);
//   }

//   static actualizarmontodelpago(double monto) {
//     pago.valordelpago = monto;
//   }

//   static obtenermontodelpago() {
//     return pago.valordelpago;
//   }

//   static eliminarPago(int index) {
//     pagos.clear();
//   }

//   static void guardarPago() {
//     DatabaseHelper.instance.agregarPago(pago);

//     Pagodetalle.ActualizarFacutas();
//     pagos.clear();
//   }
// }

// To parse this JSON data, do
//
//     final pago = pagoFromJson(jsonString);

import 'dart:convert';

import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/pantallas/Pagos/pago.dart';
import 'package:sigalogin/pantallas/Pagos/pagosForm.dart';

import '../../servicios/db_helper.dart';
import '../factura.dart';

Map<String, Pago> pagoFromJson(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Pago>(k, Pago.fromJson(v)));

String pagoToJson(Map<String, Pago> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Pago {
  Pago(
      {this.id,
      this.banco,
      required this.clienteId,
      required this.compagni,
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
  int compagni;
  int sincronizado;
  int isDelete;
  String? estado;
  String? idFirebase;

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        banco: json["Banco"]!,
        clienteId: json["ClienteId"],
        compagni: json["Compagni"],
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
        "Compagni": compagni,
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
        "Compagni": compagni,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "MontoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };
  Map<String, dynamic> toJsonsql() => {
        "id": id,
        "Banco": banco,
        "ClienteId": clienteId,
        "Compagni": compagni,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "MontoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };
  Map<String, dynamic> toJsonsqlinsert() => {
        "Banco": banco,
        "ClienteId": clienteId,
        "Compagni": compagni,
        "FechaDeCheque": fechaDeCheque,
        "FechaPago": fechaPago,
        "IsDelete": isDelete,
        "MetodoDePago": metodoDePago,
        "MontoPagado": montoPagado,
        "Pendiente": pendiente,
        "Sincronizado": sincronizado,
        "VendorID": vendorId,
        "NumeroDeCheque": numeroDeCheque,
      };

  factory Pago.fromMap(Map<String, dynamic> json) => Pago(
        id: json["ID"],
        clienteId: json["ClienteId"],
        banco: json["Banco"],
        numeroDeCheque: json["NumeroDeCheque"],
        fechaDeCheque: json["FechaDeCheque"],
        fechaPago: json["FechaPago"],
        metodoDePago: json["MetodoDePago"],
        montoPagado: json["MontoPagado"]?.toDouble(),
        pendiente: json["Pendiente"],
        vendorId: json["VendorID"],
        compagni: json["Compagni"],
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
        compagni: json["compagni"],
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
        compagni: json["compagni"],
        sincronizado: json["sincronizado"],
        isDelete: json["isDelete"],
      );
  static List<Pago> pagos = [];

  static var pago = Pago(
      clienteId: 'null',
      compagni: 1,
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
    var formaDePago = pago.metodoDePago.toString();

    DatabaseHelper.instance
        .agregarPagoconID(pago)
        .then((value) => PagoTemporal.guardarDetallePago(value, formaDePago));

    // Pagodetalle.ActualizarFacutas();
  }
}
