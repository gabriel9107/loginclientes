import 'package:sigalogin/clases/global.dart';

import '../servicios/db_helper.dart';

class Customers {
  final int? id;
  final String CustomerCode;
  final String CustomerName;
  final String CustomerDir;
  final String Phone1;
  final String Phone2;
  final String Comment1;
  final String creadoEn;
  final String creadoPor;

  Customers(
      {this.id,
      required this.CustomerCode,
      required this.CustomerName,
      required this.CustomerDir,
      required this.Phone1,
      required this.Phone2,
      required this.Comment1,
      required this.creadoEn,
      required this.creadoPor});

  factory Customers.fromMap(Map<String, dynamic> json) => new Customers(
      id: json['id'],
      CustomerCode: json['CustomerCode'],
      CustomerName: json['CustomerName'],
      CustomerDir: json['CustomerDir'],
      Phone1: json['Phone1'],
      Phone2: json['Phone2'],
      Comment1: json['Comment1'],
      creadoEn: json['creadoEn'].toString(),
      creadoPor: json['creadoPor'].toString());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'CustomerName': CustomerName,
      'CustomerCode': CustomerCode,
      'CustomerDir': CustomerDir,
      'Phone1': Phone1,
      'Phone2': Phone2,
      'Comment1': Comment1,
      'creadoEn': creadoEn,
      'creadoPor': creadoPor,
    };
  }

  static Future getCustomers() async {
    var documento =
        await DatabaseHelper.instance.getCustomers() as List<Customers>;

    if (ListaClientes == false) {
      documento.forEach((element) {
        Customers customer = new Customers(
            CustomerCode: element.CustomerCode,
            CustomerName: element.CustomerName,
            CustomerDir: element.CustomerDir,
            Phone1: element.Phone1,
            Phone2: element.Phone2,
            Comment1: element.Comment1,
            creadoEn: element.creadoEn,
            creadoPor: element.creadoPor);
        TodosLosClientes.add(customer);
      });
      ListaClientes = true;
    }
    return documento;
  }
}
