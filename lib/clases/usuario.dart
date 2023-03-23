class Usuario {
  Usuario(
      {this.id,
      required this.activo,
      required this.compania,
      required this.usuarioClave,
      required this.usuarioNombre});

  int? id;
  String usuarioNombre;
  String usuarioClave;
  String compania;
  String activo;

  Map<String, dynamic> toMapsql() => {
        "UsuarioNombre": usuarioNombre,
        "UsuarioClave": usuarioClave,
        "Compagnia": compania,
        "Activo": activo,
      };
}
