import 'dart:convert';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBD1Qf4ZOj2Shs7azW96Gp5j9zB_Q-WLcY';

  // final storage = new FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    print('usuario');
    print(email);
    print('contraseña');
    print(password);

    final Map<String, dynamic> authDate = {
      'email': email,
      'password': password
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    print('Este es la url : ' + url.toString());

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
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    print('Este es la url : ' + url.toString());

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decoreResp = json.decode(resp.body);

    // final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decoreResp.containsKey('idToken')) {
      //se tiene que guardar en un lugar corrrecto
      // await storage.write(key: 'token', value: decoreResp['idToken']);
      return null;
    } else {
      return decoreResp['error']['message'];
    }
  }

  Future logout() async {
    // await storage.delete(key: 'token');
    return;
  }
}
