class Usuario {
  Usuario(
      {this.id,
      required this.nombre,
      required this.apellido,
      required this.activo,
      required this.compania,
      required this.usuarioClave,
      required this.usuarioNombre,
      required this.sincronizado});

  int? id;
  String nombre;
  String apellido;
  String usuarioNombre;
  String usuarioClave;
  int compania;
  int activo;
  int sincronizado;

  factory Usuario.fromMapSql(Map<String, dynamic> json) => new Usuario(
      id: json["id"],
      nombre: json["Nombre"],
      apellido: json["Apellido"],
      usuarioNombre: json["UsuarioNombre"],
      usuarioClave: json["UsuarioClave"],
      compania: json["Compagnia"],
      activo: json["Activo"],
      sincronizado: json["sincronizado"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Nombre': nombre,
      'Apellido': apellido,
      'UsuarioNombre': usuarioNombre,
      'UsuarioClave': usuarioClave,
      'Compagnia': compania,
      'Activo': activo,
      'sincronizado': sincronizado
    };

    // ignore: dead_code
    Map<String, dynamic> toMapsql() => {
          "Nombre": nombre,
          "Apellido": apellido,
          "UsuarioNombre": usuarioNombre,
          "UsuarioClave": usuarioClave,
          "Compagnia": compania,
          "Activo": activo,
          "sincronizado": sincronizado
        };

    Map<String, dynamic> toJsonUp() => {
          "Nombre": nombre,
          "Apellido": apellido,
          "UsuarioNombre": usuarioNombre,
          "UsuarioClave": usuarioClave,
          "Compagnia": compania,
          "Activo": activo,
          "sincronizado": sincronizado
        };
  }
}


//Leyenda 

//false = 0 
//true = 1

//Activo = 1 
//Inactivo = 0  

//Sincornizado = 1
//NO Sincornizado = 0 


//Siga AX = 0 
//Siga New (GP) = 1