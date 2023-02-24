import 'dart:ffi';

class Resumen {
  String? accion;
  String? cantidad;

  Resumen({this.accion, this.cantidad});

  static List<Resumen> resumentList = [];

  static List<Resumen> obtenerResumen(Resumen resumen) {
    return resumentList.toList();
  }

  static agregarResumen(Resumen resumen) {
    resumentList.add(resumen);
  }
}
