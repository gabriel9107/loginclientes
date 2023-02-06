import 'dart:ffi';

class OrdenVenta {
  final int? id;
  final ordenNumero;
  final String cash;
  final String change;
  final String customerID;
  final String date;
  final String gPID;
  final String isDelete;
  final String totals;
  final String vAT;
  final String userName;
  //Estatus : 0 Inactivo, 1: Activo
  final String status;
  final String commets;

  OrdenVenta(
      {this.id,
      required this.cash,
      required this.ordenNumero,
      required this.change,
      required this.customerID,
      required this.date,
      required this.gPID,
      required this.isDelete,
      required this.totals,
      required this.userName,
      required this.vAT,
      required this.status,
      required this.commets});

  factory OrdenVenta.fromMap(Map<String, dynamic> json) => OrdenVenta(
      id: json['ID'],
      ordenNumero: json['OrdenNumero'],
      cash: json['Cash'],
      change: json['Change'],
      customerID: json['CustomerID'],
      date: json['Date'],
      gPID: json['GPID'],
      isDelete: json['IsDelete'],
      totals: json['Totals'],
      vAT: json['VAT'],
      status: json['Status'],
      commets: json['Commets'],
      userName: 'gabriel9107@gmail.com');

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'OrdenNumero': ordenNumero,
      'Cash': cash,
      'Change': change,
      'CustomerID': customerID,
      'Date': date,
      'GPID': gPID,
      'IsDelete': isDelete,
      'Totals': totals,
      'VAT': vAT,
      'Status': status,
      'Commets': commets,
      'UserName': userName
    };
  }
}

class OrdenVentaDetalle {
  final Int? iD;
  final String salesOrdersID;
  final double price;
  final int qty;
  final String productCode;
  final String productName;

  OrdenVentaDetalle(
      {this.iD,
      required this.salesOrdersID,
      required this.price,
      required this.qty,
      required this.productCode,
      required this.productName});

  factory OrdenVentaDetalle.fromMap(Map<String, dynamic> json) =>
      OrdenVentaDetalle(
          iD: json['ID'],
          salesOrdersID: json['SalesOrdersID'],
          price: json['Price'],
          qty: json['Qty'],
          productCode: json['ProductCode'],
          productName: json['ProductName']);

  Map<String, dynamic> toMap() {
    return {
      'ID': iD,
      'SalesOrdersID': salesOrdersID,
      'Price': price,
      'Qty': qty,
      'ProductCode': productCode,
      'ProductName': productName,
    };
  }
}
