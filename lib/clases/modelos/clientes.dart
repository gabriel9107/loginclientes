class Cliente {
  Cliente({
    required this.comentario,
    required this.codigo,
    required this.codigoVendedor,
    required this.direccion,
    required this.nombre,
    required this.telefono1,
    required this.telefono2,
  });

  String comentario;
  String? codigo;
  int codigoVendedor;
  String direccion;
  String nombre;
  int telefono1;
  int telefono2;

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        comentario: json["COmentario "],
        codigo: json["Codigo"].toString(),
        codigoVendedor: json["CodigoVendedor"],
        direccion: json["Direccion"],
        nombre: json["Nombre"],
        telefono1: json["Telefono1"],
        telefono2: json["Telefono2"],
      );

  Map<String, dynamic> toJson() => {
        "Comentario ": comentario,
        "Codigo": codigo,
        "CodigoVendedor": codigoVendedor,
        "Direccion": direccion,
        "Nombre": nombre,
        "Telefono1": telefono1,
        "Telefono2": telefono2,
      };
}
