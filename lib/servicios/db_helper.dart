import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../clases/customers.dart';

class DatabaseHelper {
  DatabaseHelper._privateConsturctor();
  static final DatabaseHelper instance = DatabaseHelper._privateConsturctor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Sigas1.db');
    return await openDatabase(
      path,
      version: 8,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE Customer(
      id INTEGER PRIMARY KEY AUTOINCREMENT,  
      CustomerCode TEXT, 
      CustomerName TEXT, 
      CustomerDir TEXT, 
      Phone1 TEXT, 
      Phone2 TEXT, 
      Comment1 TEXT
      )''');

    //   await db.execute('''CREATE TABLE Usuario(
    //        id INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,UsuarioNombre TEXT
    //     ,UsuarioClave TEXT
    //     ,Compagnia TEXT
    //     ,Activo TEXT
    //     )''');

    //   await db.execute('''CREATE TABLE InvoiceHeaders(
    //        id INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,SALESID TEXT
    //     ,INVOICEID TEXT
    //     ,PAYMENT TEXT
    //     ,INVOICEDATE TEXT
    //     ,DUEDATE TEXT
    //     ,INVOICEAMOUNT TEXT
    //     ,INVOICINGNAME TEXT
    //     ,PrintCounterDevolution TEXT
    //     ,PrintCounterCreditNote TEXT
    //     ,INVOICEACCOUNT TEXT
    //     ,PayedAmount TEXT
    //     )''');

    //   //tablas correspondiente a las ordenes
    //   //SalesOrders tiene la cabezera y
    //   //SalesLine el detalle de los productos

    //   await db.execute('''CREATE TABLE SalesOrders(
    //       ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,ordenNumero TEXT
    //     ,Cash TEXT
    //     ,Change TEXT
    //     ,CustomerID TEXT
    //     ,Date TEXT
    //     ,GPID TEXT
    //     ,IsDelete TEXT
    //     ,Totals TEXT
    //     ,VAT TEXT
    //     ,UserName TEXT
    //     ,Status TEXT
    //     ,Commets TEXT
    //     )''');

    //   await db.execute('''CREATE TABLE SalesLines(
    // ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,SalesOrdersID TEXT
    //     ,Price TEXT
    //     ,Qty TEXT
    //     ,ProductID TEXT
    //     ,ProductCode TEXT
    //     ,Products_ID TEXT
    //     ,ProductName TEXT
    //     )''');

    //   await db.execute('''CREATE TABLE Products(
    //     ID INTEGER PRIMARY KEY AUTOINCREMENT

    //     ,IsDelete TEXT
    //     ,Price TEXT
    //     ,ProductCode TEXT
    //     ,ProductID TEXT
    //     ,ProductName TEXT
    //     ,Qty TEXT
    //     ,TypeOSales TEXT
    //     ,UoM TEXT
    //     )''');

    //   // await db.execute('''CREATE TABLE PaymentOrders(
    //   //    ID INTEGER PRIMARY KEY AUTOINCREMENT

    //   //  Id TEXT
    //   //   ,VendorID TEXT
    //   //   ,Datetime TEXT
    //   //   ,Amount TEXT
    //   //   ,Method TEXT
    //   //   ,BankName TEXT
    //   //   ,CheckNumber TEXT
    //   //   ,CheckDate TEXT
    //   //   ,IsEnabled TEXT
    //   //   ,Customer_Code TEXT
    //   //   ,IsOpen TEXT
    //   //   ,Imported TEXT
    //   //   )''');
    //   // await db.execute('''CREATE TABLE PaymentItems(
    //   //    ID INTEGER PRIMARY KEY AUTOINCREMENT
    //   //   ,PaymentOrderId TEXT
    //   //   ,InvoiceNumber TEXT
    //   //   ,AmountApply TEXT
    //   //   ,InvoiveAmountAtMoment TEXT
    //   //   ,IsEnabled TEXT
    //   //   )''');
  }

//Clientes
  Future<List<Customers>> getCustomers() async {
    Database db = await instance.database;
    var customers = await db.query('Customer', orderBy: 'CustomerName');
    List<Customers> customersList = customers.isNotEmpty
        ? customers.map((c) => Customers.fromMap(c)).toList()
        : [];
    return customersList;
  }

  Future<int> Add(Customers customers) async {
    Database db = await instance.database;
    return await db.insert('Customer', customers.toMap());
  }

  Future<int> update(Customers customers) async {
    Database db = await instance.database;
    int id = customers.toMap()['id'];
    return await db.update('Customers', customers.toMap(),
        where: '$id = ?', whereArgs: [id]);
  }

//Pedidos de ventas

//   Future<int> AddSales(OrdenVenta pedido) async {
//     Database db = await instance.database;
//     return await db.insert('SalesOrders', pedido.toMap());
//   }

//   Future<int> AddSalesDetalle(OrdenVentaDetalle detallePedido) async {
//     Database db = await instance.database;
//     return await db.insert('SalesLines', detallePedido.toMap());
//   }

// //obtener el proximo numero de orden
//   Future<String> getNextSalesOrders() async {
//     Database db = await instance.database;
//     var res = await db.rawQuery(
//         " SELECT ordenNumero FROM SalesLines WHERE ID = (SELECT MAX(ID) FROM SalesLines); ");
//     if (res.length == 0) {
//       return "1";
//     }

//     return res.toString();
//   }

// //Lista de ordenes para pedidos de venta
//   Future<List<OrdenVenta>> getOrdenes() async {
//     Database db = await instance.database;
//     var ordenes = await db.query('SalesOrders', orderBy: 'ID');
//     // List<OrdenVenta> ordenesLista = ordenes.isNotEmpty
//     //     ? ordenes.map((c) => OrdenVenta.fromMap(c)).toList()
//     //     : [];

//     List<OrdenVenta> ordenesLista = ordenes.isNotEmpty
//         ? ordenes.map((c) => OrdenVenta.fromMap(c)).toList()
//         : [];
//     return ordenesLista;
//   }

//   Future<List<OrdenVentaDetalle>> getDetallesporId(String id) async {
//     Database db = await instance.database;
//     var detalle =
//         await db.rawQuery("SELECT * FROM SalesLines WHERE ID = '$id'");

//     List<OrdenVentaDetalle> ordenesDetalleLista = detalle.isNotEmpty
//         ? detalle.map((c) => OrdenVentaDetalle.fromMap(c)).toList()
//         : [];
//     return ordenesDetalleLista;
//   }

//   Future<List<OrdenVentaDetalle>> getDetalles() async {
//     Database db = await instance.database;
//     var detallesOrden = await db.query('SalesLines', orderBy: 'ID');

//     List<OrdenVentaDetalle> ordenesDetalleLista = detallesOrden.isNotEmpty
//         ? detallesOrden.map((c) => OrdenVentaDetalle.fromMap(c)).toList()
//         : [];
//     return ordenesDetalleLista;
//   }

//   //creando y leyendo los usuarios
//   Future<int> saveUser(Usuario user) async {
//     var dbClient = await instance.database;
//     int res = await dbClient.insert("Usuario", user.toMap());

//     return res;
//   }

//   Future<String> getLogin(String user, String password) async {
//     var dbClient = await instance.database;
//     var res = await dbClient.rawQuery(
//         "SELECT * FROM Usuario WHERE usuarioNombre; = '$user' and usuarioClave = '$password' and Activo = 1");

//     if (res.length > 0) {
//       return 'Si';
//     }
//     return 'NO';
//   }

  // Future<List<User>> getAllUser() async {
  //   var dbClient = await con.db;
  //   var res = await dbClient.query("user");

  //   List<User> list =
  //       res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : null;
  //   return list;
  // }
}
