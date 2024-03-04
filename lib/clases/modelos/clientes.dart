import 'dart:convert';

import '../../servicios/db_helper.dart';

Map<String, Cliente> clienteFromMap(String str) => Map.from(json.decode(str))
    .map((k, v) => MapEntry<String, Cliente>(k, Cliente.fromMap(v)));

String clienteToMap(Map<String, Cliente> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())));

class Cliente {
  Cliente(
      {this.id,
      required this.activo,
      required this.codigo,
      required this.codigoVendedor,
      required this.comentario,
      required this.compagnia,
      required this.direccion,
      required this.nombre,
      required this.sincronizado,
      required this.telefono1,
      required this.telefono2,
      this.creadoEn,
      this.descuento});

  int? id;
  String codigo;
  String codigoVendedor;
  String comentario;
  String direccion;
  String nombre;
  String telefono1;
  String telefono2;
  String? creadoEn;
  String? descuento;
  int compagnia;
  int sincronizado;
  int activo;

  factory Cliente.fromMapSql(Map<String, dynamic> json) => new Cliente(
      id: json["ID"],
      codigo: json["codigo"],
      nombre: json["nombre"].toString().trim(),
      direccion: json["direccion"].toString().trim(),
      telefono2: json["telefono2"].toString().trim(),
      telefono1: json["telefono1"].toString().trim(),
      comentario: json["comentario"].toString().trim(),
      codigoVendedor: json["codigoVendedor"].toString().trim(),
      compagnia: json["compagnia"],
      sincronizado: json["sincronizado"],
      activo: json["activo"],
      descuento: json["descuento"]);

  factory Cliente.fromMapfromJson(Map<String, dynamic> json) => new Cliente(
        codigo: json["codigo"],
        nombre: json["nombre"].toString().trim(),
        direccion: json["direccion"].toString().trim(),
        telefono2: json["telefono2"].toString().trim(),
        telefono1: json["telefono1"].toString().trim(),
        comentario: json["comentario"].toString().trim(),
        codigoVendedor: json["codigoVendedor"].toString().trim(),
        compagnia: json["compagnia"],
        sincronizado: json["sincronizado"],
        activo: 0,
      );

  factory Cliente.fromMap(Map<String, dynamic> json) => new Cliente(
        id: json["ID"],
        codigo: json["codigo"],
        nombre: json["nombre"].toString().trim(),
        direccion: json["direccion"].toString().trim(),
        telefono2: json["telefono2"].toString().trim(),
        telefono1: json["telefono1"].toString().trim(),
        comentario: json["comentario"].toString().trim(),
        codigoVendedor: json["codigoVendedor"].toString().trim(),
        compagnia: json["compagnia"],
        sincronizado: json["sincronizado"],
        activo: 1,
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "activo": activo,
        "codigo": codigo,
        "codigoVendedor": codigoVendedor,
        "comentario": comentario,
        "compagnia": compagnia,
        "direccion": direccion,
        "nombre": nombre,
        "sincronizado": sincronizado,
        "telefono1": telefono1,
        "telefono2": telefono2,
      };

  Map<String, dynamic> toMapsql() => {
        "activo": activo,
        "codigo": codigo,
        "codigoVendedor": codigoVendedor,
        "comentario": comentario,
        "compagnia": compagnia,
        "direccion": direccion,
        "nombre": nombre,
        "sincronizado": sincronizado,
        "telefono1": telefono1,
        "telefono2": telefono2,
      };

  Map<String, dynamic> toMapNewInsert() => {
        "activo": activo,
        "codigo": codigo,
        "codigoVendedor": codigoVendedor,
        "comentario": comentario,
        "compagnia": compagnia,
        "direccion": direccion,
        "nombre": nombre,
        "sincronizado": sincronizado,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "creadoEn": creadoEn,
        "descuento": descuento
      };

  Map<String, dynamic> toJsonUp() => {
        "ID": id,
        "activo": activo.toString(),
        "codigo": codigo,
        "codigoVendedor": codigoVendedor,
        "comentario": comentario,
        "compagnia": compagnia,
        "direccion": direccion,
        "nombre": nombre,
        "sincronizado": sincronizado,
        "telefono1": telefono1,
        "descuento": descuento,
        "telefono2": telefono2,
      };
  Map<String, dynamic> toJson() => {
        "ID": id,
        "activo": activo,
        "codigo": codigo,
        "codigoVendedor": codigoVendedor,
        "comentario": comentario,
        "compagnia": compagnia,
        "direccion": direccion,
        "nombre": nombre,
        "sincronizado": sincronizado,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "descuento": descuento,
      };

  static Future obtenerClientesFijos() async {
    int result = await DatabaseHelper.instance.CantidadDeClientesPorMes();

    return result;
  }

  // static obtenerClientesFijos() async {
  //   print('clientes');

  //   int? valor;
  //   DatabaseHelper.instance.CantidadDeClientesPorMes().then((value) {
  //     valor = value;
  //     print(valor);

  //     print(valor);

  //     print(valor);
  //   });

  //   return valor;
  // }
}

class Dashboar {
  int cantidadVisitas;
  int cantidadVentas;
  int fijos;
  int cobros;

  Dashboar(
      {required this.cantidadVentas,
      required this.cantidadVisitas,
      required this.cobros,
      required this.fijos});
}
