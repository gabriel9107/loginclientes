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

  UsuarioServicios() {
    this.bajarUsuarios();
    this.subirUsuarios();
  }

  Future bajarUsuarios() async {
    final url = Uri.https(_baseUrl, 'Usuarios.json');
    final resp = await http.get(url);

    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final Map<String, dynamic> usuariosMap = json.decode(resp.body);

    usuariosMap.forEach((key, value) {
      final tempUsuarios = Usuario.fromMapSql(value);
      usuarios.add(tempUsuarios);
    });

    Resumen.resumentList.add(Resumen(
        accion: 'Usuarios Sincrinizados',
        cantidad: usuarios.length.toString()));
  }

  Future subirUsuarios() async {
    var usuarios = await DatabaseHelper.instance
        .obtenerListaDeUsuarios(compagnia)
        .then((value) => (sincronizarUsuarios(value)));
  }

  sincronizarUsuarios(List<Usuario> listaDeUsuarios) async {
    final url = Uri.https(_baseUrl, 'Usuarios.json');

    listaDeUsuarios.forEach((element) async {
      final resp = await http.post(url, body: json.encode(element.toMap()));
      final decodeData = resp.body;
      if (decodeData.isNotEmpty) {
        DatabaseHelper.instance.actualizarUsarioCargado(element.id as int);
      }

      //Notificar que el usuario fue cargado
      Resumen.resumentList.add(Resumen(
          accion: 'Usuario Subidos',
          cantidad: listaDeUsuarios.length.toString()));
    });
  }
}
