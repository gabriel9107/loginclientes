import 'dart:convert';

import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/servicios/db_helper.dart';

List<Pago?> pagoFromJson(String str) => List<Pago?>.from(
    json.decode(str).map((x) => x == null ? null : Pago.fromJson(x)));

String pagoToJson(List<Pago?> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x?.toJson())));

class Pago {
  Pago({
    this.banco,
    required this.clienteId,
    required this.clienteNombre,
    this.fechaCheque,
    required this.formadePago,
    this.id,
    this.numeroDeCheque,
    required this.valordelpago,
    required this.vendedor,
  });

  String? banco;
  int clienteId;
  String clienteNombre;
  DateTime? fechaCheque;
  String formadePago;
  int? id;
  int? numeroDeCheque;
  double valordelpago;
  String vendedor;

  factory Pago.fromMap(Map<String, dynamic> json) => Pago(
        banco: json['banco'],
        clienteId: json['clienteId'],
        clienteNombre: json['clienteNombre'],
        fechaCheque: json['fechaCheque'] as DateTime?,
        formadePago: json['formadePago'],
        id: json['id'],
        numeroDeCheque: json['numeroDeCheque'],
        valordelpago: double.parse(json['valordelpago']),
        vendedor: json['vendedor'],
      );

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        banco: json["banco"],
        clienteId: json["clienteId"],
        clienteNombre: json["clienteNombre"],
        fechaCheque: DateTime.parse(json["fechaCheque"]),
        formadePago: json["formadePago"],
        id: json["id"],
        numeroDeCheque: json["numeroDeCheque"],
        valordelpago: json["valordelpago"],
        vendedor: json["vendedor"],
      );

  Map<String, dynamic> toJson() => {
        "banco": banco,
        "clienteId": clienteId,
        "clienteNombre": clienteNombre,
        "fechaCheque": fechaCheque?.toIso8601String(),
        "formadePago": formadePago,
        "id": id,
        "numeroDeCheque": numeroDeCheque,
        "valordelpago": valordelpago,
        "vendedor": vendedor,
      };

  Map<String, dynamic> toMap() {
    return {
      'banco': banco,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'fechaCheque': fechaCheque?.toIso8601String(),
      'formadePago': formadePago,
      'id': id,
      'numeroDeCheque': numeroDeCheque,
      'valordelpago': valordelpago,
      'vendedor': vendedor,
    };
  }

  static var pago = new Pago(
      formadePago: "1",
      valordelpago: 0,
      clienteId: 0,
      clienteNombre: '',
      vendedor: usuario);

  static List<Pago> pagos = [];

  static actualizarpago(Pago update) {
    pago.clienteId = update.clienteId;
    pago.clienteNombre = update.clienteNombre;
    pago.formadePago = update.formadePago;
    pago.banco = update.banco;
    pago.valordelpago = update.valordelpago;
    pago.numeroDeCheque = update.numeroDeCheque;
    pago.fechaCheque = update.fechaCheque;
  }

  static agregarpago(Pago pago) {
    pagos.add(pago);
  }

  static actualizarmontodelpago(double monto) {
    pago.valordelpago = monto;
  }

  static obtenermontodelpago() {
    return pago.valordelpago;
  }

  static eliminarPago(int index) {
    pagos.clear();
  }

  static void guardarPago() {
    DatabaseHelper.instance.agregarPago(pago);

    // );
  }
}
