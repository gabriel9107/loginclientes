// import 'dart:convert';

// import 'package:sigalogin/clases/modelos/resumen.dart';
// import 'package:sigalogin/clases/usuario.dart';
// import 'package:sigalogin/servicios/db_helper.dart';
// import 'package:http/http.dart' as http;

// class ListSincrinizacion {
//   String nombre;
//   int cantidad;

//   ListSincrinizacion(
//     this.nombre,
//     this.cantidad,
//   );
// }

// class DataServices {
//   final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';

//   final List<ListSincrinizacion> resultado = [];

//   Future downNewUser() async {
//     var client = http.Client();
//     try {
//       var response = await client.get(
//           Uri.parse(
//               'https://siga-d5296-default-rtdb.firebaseio.com/Usuario.json'),
//           headers: {"Content-Type": "application/json"});

//       final Map<String, dynamic> usuariosMap = json.decode(response.body);

//       usuariosMap.forEach((key, value) {
//         final tempUsuarios = Usuario.fromMap(value);

//         var cargado =
//             DatabaseHelper.instance.verificarUsuarioASincronizar(tempUsuarios);
//       });
//       print('Usuario Descargado para la prueba');

//       Resumen.resumentList.add(Resumen(
//           accion: 'Usuario Descargado o actualizado',
//           cantidad: usuariosMap.length.toString()));
//     } finally {
//       client.close();
//     }
//   }
// }
