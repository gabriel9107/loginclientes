// import 'dart:convert';
// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:sigalogin/clases/global.dart';
// import 'package:sigalogin/clases/modelos/resumen.dart';
// import 'package:sigalogin/clases/usuario.dart';
// import 'package:sigalogin/servicios/db_helper.dart';
// import 'package:http/http.dart' as http;

// class UsuariosServices extends ChangeNotifier {
//   final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
//   final List<Usuario> usuarios = [];

//   UsuariosServices() {
//     DescargarUsuarios();
//     // CargarUsuarios();
//   }

//   Future DescargarUsuarios() async {
//     var usuarios = await DatabaseHelper.instance
//         .obtenerListaDeUsuarios(compagnia)
//         .then((value) => sincronizarUsuariosAFire(value));
//   }

//   Future cargarUsuarios() async {
//     final url = Uri.https(_baseUrl, 'Usuario.json');

//     final resp = await http.get(url);

//     final response =
//         await http.get(url, headers: {"Content-Type": "application/json"});
//     // final jsonList = jsonDecode(response.body) as List<dynamic>;

//     // DatabaseHelper.instance.Deleteproducto();
//     final Map<String, dynamic> map = json.decode(resp.body);

//     map.forEach((key, value) {
//       final temp = Usuario.fromMap(value);
//       usuarios.add(temp);
//     });

//     usuarios.forEach((element) {
//       DatabaseHelper.instance.verificarUsuarioASincronizar(element);
//     });

//     Resumen.resumentList.add(Resumen(
//         accion: 'Usuarios Sincronizados',
//         cantidad: usuarios.length.toString()));
//   }

//   sincronizarUsuariosAFire(List<Usuario> value) {
//     final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
//     final url = Uri.https(_baseUrl, 'Usuario.json');

//     value.forEach((usuario) async {
//       final resp = await http.post(url, body: json.encode(usuario.toMap()));
//       final codeData = json.decode(resp.body);

//       final decodeData = codeData['name'];
//       if (decodeData.isNotEmpty) {
//         DatabaseHelper.instance.actualizarUsarioCargado(usuario);
//       }
//     });

//     Resumen.resumentList.add(Resumen(
//         accion: 'Usuarios Cargado', cantidad: usuario.length.toString()));
//   }
// }
