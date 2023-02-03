import 'package:http/http.dart';

class Cliente {
  Cliente(
      {this.comentario,
      required this.codigo,
      required this.codigoVendedor,
      required this.direccion,
      required this.nombre,
      required this.telefono1,
      required this.telefono2});

  String? comentario;
  String? codigo;
  String? codigoVendedor;
  String? direccion;
  String? nombre;
  String? telefono1;
  String? telefono2;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        comentario: json["comentario "],
        codigo: json["codigo"].toString(),
        codigoVendedor: json["codigoVendedor"],
        direccion: json["direccion"],
        nombre: json["nombre"],
        telefono1: json["telefono1"],
        telefono2: json["telefono2"],
      );

  Map<String, dynamic> toJson() => {
        "comentario ": comentario,
        "codigo": codigo,
        "codigoVendedor": codigoVendedor,
        "direccion": direccion,
        "nombre": nombre,
        "telefono1": telefono1,
        "telefono2": telefono2,
      };
}
