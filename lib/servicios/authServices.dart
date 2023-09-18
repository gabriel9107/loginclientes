import 'dart:convert';
import 'dart:math';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/clases/usuario.dart';

import 'db_helper.dart';

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBD1Qf4ZOj2Shs7azW96Gp5j9zB_Q-WLcY';

  // final storage = new FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authDate = {
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authDate));
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp.containsKey('idToken')) {
      //se tiene que guardar en un lugar corrrecto
      // await storage.write(key: 'token', value: decodeResp['idToken']);

      return decodeResp['idToken'];
    } else {
      return decodeResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    usuariovalidado _usuarioLocal =
        await verificarUsuarioLocal(email, password);

    usuario = email;

    return _usuarioLocal.mensaje.toString();
  }
}

///0 - El usuario no existe
///1 - Clave  inccorrecta
///2 - Seccion inicada
Future<usuariovalidado> verificarUsuarioLocal(
    String usuario, String clave) async {
  var validarUsuario =
      await DatabaseHelper.instance.obtenerUsuario(usuario, clave);
  if (validarUsuario == 0) {
    return usuariovalidado(0, 'El usuario no existe');
  } else if (validarUsuario == 1) {
    return usuariovalidado(1, ' Clave  inccorrecta');
  }

  // informacionUsuario();
  return usuariovalidado(2, 'validado');
}

Future logout() async {
  // await storage.delete(key: 'token');
  return;
}

informacionUsuario(String usuarionombre) {
  var eusuario = DatabaseHelper.instance
      .obtenerInformacionUsuario(compagnia, usuarionombre);
}

class usuariovalidado {
  int resultado;
  String? mensaje;

  usuariovalidado(this.resultado, this.mensaje);
}
