import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sigalogin/clases/detalledePago.dart';
import 'package:sigalogin/clases/factura.dart';
import 'package:sigalogin/clases/facturaDetalle.dart';
import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../clases/customers.dart';
import '../clases/detalleFactura.dart';
import '../clases/modelos/pagodetalle.dart';
import '../clases/ordenDeventa.dart';

class DatabaseHelper {
  DatabaseHelper._privateConsturctor();
  static final DatabaseHelper instance = DatabaseHelper._privateConsturctor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'sga3.db');
    return await openDatabase(
      path,
      version: 1,
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
      Comment1 TEXT, 
      creadoPor TEXT, 
      creadoEn Text

      )''');

    await db.execute('''CREATE TABLE Usuario(
           id INTEGER PRIMARY KEY AUTOINCREMENT
        ,UsuarioNombre TEXT
        ,UsuarioClave TEXT
        ,Compagnia TEXT
        ,Activo TEXT
        )''');

    await db.execute('''CREATE TABLE InvoiceHeaders(
           id INTEGER PRIMARY KEY AUTOINCREMENT
        ,SALESID TEXT
        ,INVOICEID TEXT
        ,PAYMENT TEXT
        ,INVOICEDATE TEXT
        ,DUEDATE TEXT
        ,INVOICEAMOUNT TEXT
        ,INVOICINGNAME TEXT
        ,PrintCounterDevolution TEXT
        ,PrintCounterCreditNote TEXT
        ,INVOICEACCOUNT TEXT
        ,PayedAmount TEXT
        )''');

    await db.execute('''CREATE TABLE SalesOrders(
          ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,ordenNumero TEXT
        ,Cash TEXT
        ,Change TEXT
        ,CustomerID TEXT
        ,Date TEXT
        ,GPID TEXT
        ,IsDelete TEXT
        ,Totals TEXT
        ,VAT TEXT
        ,UserName TEXT
        ,Status TEXT
        ,Commets TEXT
        )''');

    await db.execute('''CREATE TABLE SalesLines(
    ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,SalesOrdersID TEXT
        ,Price TEXT
        ,Qty TEXT
        ,ProductID TEXT
        ,ProductCode TEXT
        ,Products_ID TEXT
        ,ProductName TEXT
        )''');

    await db.execute('''CREATE TABLE Productos(
        ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,Nombre TEXT
        ,ProductoCodigo TEXT
        ,Qty TEXT
        ,TypeOfSales TEXT
        ,OuM TEXT
        ,Price TEXT
        ,Compagnia TEXT
        ,Sincronizado TEXT
        ,IsDelete TEXT
        )''');

    await db.execute('''CREATE TABLE PaymentOrders(
         ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,VendorID TEXT
        ,Datetime TEXT
        ,Amount TEXT
        ,Method TEXT
        ,BankName TEXT
        ,CheckNumber TEXT
        ,CheckDate TEXT
        ,IsEnabled TEXT
        ,Customer_Code TEXT
        ,IsOpen TEXT
        ,Imported TEXT
        )''');
    await db.execute('''CREATE TABLE PaymentItems(
         ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,PaymentOrderId TEXT
        ,InvoiceNumber TEXT
        ,AmountApply TEXT
        ,InvoiveAmountAtMoment TEXT
        ,IsEnabled TEXT
        )''');

    ///creando 2 tablas Factura y Factura detalle para cambiarle la forma del flujo y que sea mas entendible por los idiomas
    ///

    ///
    await db.execute('''CREATE TABLE Factura(
         ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,FacturaFecha TEXT
        ,FacturaId TEXT
        ,FacturaVencimiento TEXT
        ,MetodoDepago TEXT
        ,clienteId TEXT
        ,MontoFactura TEXT
        ,PedidosId TEXT
        ,TotalPagado TEXT
        
        )''');

    ///
    ///
    await db.execute('''CREATE TABLE FacturaDetalle(
         ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,FacturaNumero TEXT
        ,LineaNumero1 TEXT
        ,Nombre TEXT
        ,PrecioVenta TEXT
        ,ProductoCodigo TEXT
        ,Qty TEXT
        ,montoLinea TEXT
        )''');

    await db.execute('''CREATE TABLE Pago(
         ID INTEGER PRIMARY KEY AUTOINCREMENT
        ,banco TEXT,
        clienteId INTEGER,
        clienteNombre TEXT,
        fechaCheque TEXT,
        formadePago TEXT,
        numeroDeCheque TEXT,
        valordelpago TEXT,
        vendedor TEXT 
        )''');

    await db.execute('''CREATE TABLE DetalleDePago(
         ID INTEGER PRIMARY KEY AUTOINCREMENT
        , fechaEmision TEXT 
        , fechavencimiento TEXT
        , montoPagado TEXT  
        , numeroDeFactura TEXT  
        , pago INTEGER 
        , valorfactura TEXT  
        , valorpendiente TEXT  
        , int activo INTEGER 
        )''');
  }

//Clientes

//Obtener Clientes
  Future<List<Customers>> getCustomers() async {
    Database db = await instance.database;
    var customers = await db.query('Customer', orderBy: 'CustomerName');
    List<Customers> customersList = customers.isNotEmpty
        ? customers.map((c) => Customers.fromMap(c)).toList()
        : [];

    return customersList;
  }

//Obtener Productos
  Future<List<Producto>> getProductos() async {
    Database db = await instance.database;
    var productos = await db.query('Productos', orderBy: 'ProductoCodigo');

    List<Producto> productoLista =
        productos.map((c) => Producto.fromMap(c)).toList();

    return productoLista;
  }

//Agregar Clientes
  Future<int> Add(Customers customers) async {
    String customerCode = customers.CustomerCode;
    Database db = await instance.database;
    return await db.insert('Customer', customers.toMap());
  }

  Future<int> Deletecustomer(Customers customers) async {
    String customerCode = customers.CustomerCode;
    Database db = await instance.database;
    return await db.delete('Customer');
  }

  Future<int> Deleteproducto() async {
    Database db = await instance.database;
    return await db.delete('Productos');
  }

//Actualizar Clientes
  Future<int> update(Customers customers) async {
    Database db = await instance.database;
    int id = customers.toMap()['id'];
    return await db.update('Customers', customers.toMap(),
        where: '$id = ?', whereArgs: [id]);
  }

//Verificar si existe el Cliente antes de sincronizarlo
  Future<int> customerExists(Customers customers) async {
    String customerCode = customers.CustomerCode;
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Customer WHERE CustomerCode= '$customerCode')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      Add(customers);
    }
    return 0;
  }

  Future<int> productoExists(Producto producto) async {
    String codigoProducto = producto.productoCodigo.toString();
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Productos WHERE ProductoCodigo= '$codigoProducto')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      addProduct(producto);
    }
    return 0;
  }

  Future<int> aregarPagoAsincronizar(Pago pago) async {
    var db = await instance.database;
    return await db.insert('Pago', pago.toJson());
  }

  Future<int> aregardetalledePagoAsincronizar(Pagodetalle pago) async {
    var db = await instance.database;
    return await db.insert('DetalleDePago', pago.toJson());
  }

  Future<int> agregarPago(Pago pago) async {
    var db = await instance.database;
    return await db.insert('Pago', pago.toJson());
  }

  Future<List<Pago>> obtenerPagosPorClientes(String cliente) async {
    var db = await instance.database;
    var pagos = await db.query('Pago', orderBy: 'Id');
    List<Pago> listadePagos =
        pagos.isNotEmpty ? pagos.map((e) => Pago.fromMap(e)).toList() : [];

    return listadePagos;
  }

  Future<int> addProduct(Producto producto) async {
    var db = await instance.database;
    return await db.insert('Productos', producto.toMap());
  }

  Future<bool> aregarProductoSiNoExiste(
      String ProductoCodigo, Producto producto) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM Productos WHERE ProductoCodigo = '$ProductoCodigo' and IsDelete = 0");

    if (res.length < 0) {
      addWProduct(producto);
      return false;
    }
    return true;
  }

  Future<int> addWProduct(Producto producto) async {
    Database db = await instance.database;
    return await db.insert('Productos', producto.toMap());
  }

  Future<List<OrdenVenta>> getOrdenes() async {
    Database db = await instance.database;
    var ordenes = await db.query('SalesOrders', orderBy: 'ID');
    // List<OrdenVenta> ordenesLista = ordenes.isNotEmpty
    //     ? ordenes.map((c) => OrdenVenta.fromMap(c)).toList()
    //     : [];

    List<OrdenVenta> ordenesLista = ordenes.isNotEmpty
        ? ordenes.map((c) => OrdenVenta.fromMap(c)).toList()
        : [];
    return ordenesLista;
  }

  // void addProduct(Producto producto) {}

//Pedidos de ventas

  Future<int> AddSales(OrdenVenta pedido) async {
    Database db = await instance.database;
    return await db.insert('SalesOrders', pedido.toMap());
  }

  Future<int> AddSalesWithId(OrdenVenta pedido) async {
    Database db = await instance.database;
    int id = await db.insert('SalesOrders', pedido.toMap());
    return id;
  }

  Future<int> AddSalesDetalle(OrdenVentaDetalle detallePedido) async {
    Database db = await instance.database;
    return await db.insert('SalesLines', detallePedido.toMap());
  }

// //obtener el proximo numero de orden
  Future<String> getNextSalesOrders() async {
    Database db = await instance.database;
    var res = await db
        .rawQuery("SELECT * FROM SalesOrders ORDER BY ID DESC LIMIT 1; ");
    if (res.length == 0) {
      return "1";
    }

    return res.toString();
  }

// Relacionado a las Facturas

  Future<int> AddFactura(Factura factura) async {
    Database db = await instance.database;
    return await db.insert('Factura', factura.toMap());
  }

  Future<List<Factura>> getFacturasporClientes(String clienteId) async {
    Database db = await instance.database;
    var factura = await db
        .rawQuery("SELECT * FROM Factura WHERE clienteId= '$clienteId'");

    List<Factura> facturaList =
        factura.map((c) => Factura.fromJson(c)).toList();

    return facturaList;
  }

  Future<List<Factura>> getFacturas() async {
    Database db = await instance.database;
    var factura = await db.query('Factura', orderBy: 'ID');

    List<Factura> productoLista =
        factura.map((c) => Factura.fromJson(c)).toList();

    return productoLista;
  }

  Future<int> AddDetalleFactura(FacturaDetalleAsync factura) async {
    Database db = await instance.database;
    return await db.insert('FacturaDetalle', factura.toMap());
  }

  Future<int> SincronizarFactura(Factura factura) async {
    String facturaNumero = factura.facturaId.toString();
    Database db = await instance.database;
    var res = await db.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Factura WHERE FacturaId= '$facturaNumero')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      AddFactura(factura);
    }
    return 0;
  }

  Future<int> SincronizarDefalleFactura(FacturaDetalleAsync factura) async {
    String facturaNumero = factura.facturaNumero;
    Database db = await instance.database;
    var res = await db.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM facturaDetalle WHERE FacturaNumero= '$facturaNumero')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      AddDetalleFactura(factura);
    }
    return 0;
  }

  Future<int> actualizarMontoFactura(String id, String totalPagado) async {
    Database db = await instance.database;
    final data = {
      'TotalPagado': totalPagado,
      // 'description': descrption,
      // 'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('Factura', data, where: "FacturaId = ?", whereArgs: [id]);
    return result;
  }
  // Future<int> actualizarMontoFactura(String facturaNumero, id) async {
  //   Database db = await instance.database;
  //   return await db
  //       .update('Factura', factura.toMap(), where: 'id = ?', whereArgs: [id]);
  // }

//Agregar pagos

  // Future<int> AddPagos(Pagos pago) async {
  //   Database db = await instance.database;
  //   return await db.insert('Pago', pago.toMap());
  // }

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

  Future<List<OrdenVentaDetalle>> getDetallesporId(String id) async {
    Database db = await instance.database;
    var detalle = await db
        .rawQuery("SELECT * FROM SalesLines WHERE SalesOrdersID = '$id'");

    List<OrdenVentaDetalle> ordenesDetalleLista = detalle.isNotEmpty
        ? detalle.map((c) => OrdenVentaDetalle.fromMap(c)).toList()
        : [];
    return ordenesDetalleLista;
  }

  Future<List<OrdenVentaDetalle>> getDetalles() async {
    Database db = await instance.database;
    var detallesOrden = await db.query('SalesLines', orderBy: 'ID');

    List<OrdenVentaDetalle> ordenesDetalleLista = detallesOrden.isNotEmpty
        ? detallesOrden.map((c) => OrdenVentaDetalle.fromMap(c)).toList()
        : [];
    return ordenesDetalleLista;
  }

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

//Panel
}
