import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';

import 'package:sigalogin/clases/modelos/resumen.dart';
import 'package:sigalogin/clases/usuario.dart';
import 'package:http/http.dart' as http;

import 'package:sigalogin/servicios/db_helper.dart';

class UsuarioServicios extends ChangeNotifier {
  final String _baseUrl = 'siga-d5296-default-rtdb.firebaseio.com';
  final List<Usuario> usuarios = [];
  final int dos = 0;
  final int fin = 0;

  UsuarioServicios() {
    // this.bajarUsuarios();
    this.downNewUser();
    this.upNewUser();
  }
  Future downNewUser() async {
    final url = Uri.https(_baseUrl, 'Usuario.json');

    var client = http.Client();
    try {
      var response = await client.get(
          Uri.parse(
              'https://siga-d5296-default-rtdb.firebaseio.com/Usuario.json'),
          headers: {"Content-Type": "application/json"});

      final Map<String, dynamic> usuariosMap = json.decode(response.body);

      usuariosMap.forEach((key, value) {
        final tempUsuarios = Usuario.fromMap(value);

        var cargado =
            DatabaseHelper.instance.verificarUsuarioASincronizar(tempUsuarios);
      });

      

      if (fin == usuariosMap.length) estado += 1;
      Resumen.resumentList.add(Resumen(
          accion: 'Usuario Descargado o actualizado',
          cantidad: usuariosMap.length.toString()));
    } finally {
      client.close();
    }
  }

  // Future bajarUsuarios() async {
  //   final List<Usuario> List_usuarios = [];
  //   int usuarioCargado = 0;
  //   final url = Uri.https(_baseUrl, 'Usuario.json');
  //   final resp = await http.get(url);

  //   final response =
  //       await http.get(url, headers: {"Content-Type": "application/json"});
  //   final Map<String, dynamic> usuariosMap = json.decode(resp.body);

  //   usuariosMap.forEach((key, value) {
  //     final tempUsuarios = Usuario.fromMap(value);

  //     // List_usuarios.add(tempUsuarios);

  //     var cargado =
  //         DatabaseHelper.instance.verificarUsuarioASincronizar(tempUsuarios);

  //     if (cargado == 1) {
  //       usuarioCargado += 1;
  //     }
  //   });
  //   print('Usuario sincronizadas');
  //   Resumen.resumentList.add(Resumen(
  //       accion: 'Usuarios Sincrinizados', cantidad: usuarioCargado.toString()));
  // }

  Future upNewUser() async {
    final url = Uri.https(_baseUrl, 'Usuario.json');
    var usuarios = await DatabaseHelper.instance
        .obtenerListaDeUsuariosPendienteASincronizar(compagnia);

    var client = http.Client();
    try {
      usuarios.forEach((element) async {
        var response = await client.post(
            Uri.parse(
                'https://siga-d5296-default-rtdb.firebaseio.com/Usuario.json'),
            body: json.encode(element.toMap()));
        var Response = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        if (Response.isNotEmpty) {
          DatabaseHelper.instance.actualizarUsarioCargado(element.id as int);
        }
      });

      Resumen.resumentList.add(Resumen(
          accion: 'Usuario Sincronizados    ',
          cantidad: usuarios.length.toString()));
    } finally {
      client.close();
    }
  }

  // Future subirUsuarios() async {
  //   var usuarios = await DatabaseHelper.instance
  //       .obtenerListaDeUsuariosPendienteASincronizar(compagnia)
  //       .then((value) => (sincronizarUsuarios(value)));
  // }

  // sincronizarUsuarios(List<Usuario> listaDeUsuarios) async {
  //   final url = Uri.https(_baseUrl, 'Usuario.json');

  //   listaDeUsuarios.forEach((element) async {
  //     final resp = await http.post(url, body: json.encode(element.toMap()));
  //     final decodeData = resp.body;
  //     if (decodeData.isNotEmpty) {
  //       DatabaseHelper.instance.actualizarUsarioCargado(element.id as int);
  //     }

  //     //Notificar que el usuario fue cargado
  //     Resumen.resumentList.add(Resumen(
  //         accion: 'Usuario     ', cantidad: listaDeUsuarios.length.toString()));
  //   });
  // }
}
