import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sigalogin/clases/factura.dart';

import 'package:sigalogin/clases/modelos/productos.dart';
import 'package:sigalogin/clases/modelos/pago.dart';
import 'package:sigalogin/clases/pedidoDetalle.dart';
import 'package:sigalogin/clases/pedidos.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/utils/utils.dart';

import '../clases/customers.dart';
import '../clases/detalleFactura.dart';
import '../clases/formatos.dart';
import '../clases/global.dart';
import '../clases/modelos/clientes.dart';
import '../clases/modelos/pagodetalle.dart';
import '../clases/ordenDeventa.dart';
import '../clases/usuario.dart';
import '../pantallas/Pagos/pagosForm.dart';

class DatabaseHelper {
  DatabaseHelper._privateConsturctor();
  static final DatabaseHelper instance = DatabaseHelper._privateConsturctor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, '60.db');
    return await openDatabase(
      path,
      version: 7,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE Clientes(
   ID INTEGER PRIMARY KEY AUTOINCREMENT,
   
        codigo TEXT,
        nombre TEXT,
        direccion TEXT,
        telefono1 TEXT,
        telefono2 TEXT,
        comentario TEXT,
        codigoVendedor TEXT,
        creadoEn TEXT,
        descuento TEXT,
        sincronizado INTEGER,
        compagnia INTEGER,
        activo INTEGER
      )''');

    await db.execute('''CREATE TABLE Productos(
        Id  INTEGER PRIMARY KEY AUTOINCREMENT,
        idfirebase TEXT, 
        Codigo TEXT,
        Nombre TEXT,
        Cantidad  INTEGER,
        Precio  REAL, 
        OuM  TEXT,
        TipodeVenta TEXT,
        Compagnia INTEGER,
        Sincronizado INTEGER,
        IsDelete INTEGER
        )''');

    await db.execute('''CREATE TABLE Pedidos(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        idfirebase TEXT, 
        NumeroOrden TEXT,
        ClienteId TEXT,
        FechaOrden TEXT, 
        Impuestos REAL, 
        TotalAPagar REAL,
        Sincronizado INTEGER,
        Compagnia INTEGER,
        Estado TEXT,
        vendorId TEXT,
        IsDelete INTEGER
                )''');

    await db.execute('''CREATE TABLE PedidoDetalle(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        idfirebase TEXT, 
        Precio REAL,
        Cantidad INTEGER,
        Codigo TEXT, 
        Nombre TEXT, 
        ProductoId INTEGER,
        PedidoId TEXT, 
        Sincronizado INTEGER,
        IsDelete INTEGER,
        Compagnia INTEGER
                )''');

    await db.execute('''CREATE TABLE Factura(
     Id	 INTEGER PRIMARY KEY AUTOINCREMENT
     ,idfirebase TEXT
    ,FacturaId TEXT
    ,PedidoId TEXT
    ,clienteId	 TEXT
    ,clienteNombre TEXT
    ,FacturaFecha TEXT
    ,FacturaVencimiento TEXT
    ,vendedorId TEXT
    ,MetodoDePago TEXT
    ,MontoFactura REAL
    ,totalPagado REAL
    ,MontoPendiente REAL
    ,Sincronizado INTEGER
    ,IsDelete	 INTEGER
    ,Compagnia	 INTEGER
        )''');
    await db.execute('''CREATE TABLE FacturaDetalle(
       ID	INTEGER PRIMARY KEY AUTOINCREMENT 
      ,idfirebase TEXT
      ,FacturaId	 TEXT
      ,LineaNumero	  REAL
      ,ProductoCodigo  TEXT
      ,Nombre	 TEXT
      ,Qty	INTEGER
      ,PrecioVenta REAL
      ,montoLinea	 REAL
      ,Sincronizado INTEGER
      ,IsDelete	INTEGER
      ,Compagnia INTEGER
        )''');

    await db.execute('''CREATE TABLE Pago(
        id  INTEGER PRIMARY KEY AUTOINCREMENT
        ,idfirebase TEXT
        ,Banco TEXT,
        Estado TEXT, 
        clienteId TEXT,
        vendorId TEXT,
        numeroDeCheque TEXT,
        MetodoDePago TEXT,
        fechaDeCheque TEXT,
        fechaPago TEXT,
        montoPagado REAL,
        pendiente INTEGER,
        sincronizado INTEGER,
        habilitado INTEGER,
        compagni INTEGER ,
        isDelete INTEGER 
        )''');

    await db.execute('''CREATE TABLE PagoDetalle(
          ID INTEGER PRIMARY KEY AUTOINCREMENT
          ,idfirebase TEXT
         ,pagoId INTEGER
         ,facturaId TEXT
         ,formaDePago TEXT
         ,montoAplicado REAL
         ,montoDeFacturaAlMomento REAL
         ,sincronizado INTEGER
         ,compagni INTEGER
         ,isDelete INTEGER
         ,activo INTEGER
             )''');

    await db.execute('''CREATE TABLE Usuario(
           id INTEGER PRIMARY KEY AUTOINCREMENT
        ,UsuarioNombre TEXT
        ,UsuarioClave TEXT
        ,Compagnia TEXT
        ,Activo TEXT
        )''');

    // await db.execute('''CREATE TABLE InvoiceHeaders(
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

    // await db.execute('''CREATE TABLE SalesOrders(
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

    // await db.execute('''CREATE TABLE SalesLines(
    // ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,SalesOrdersID TEXT
    //     ,Price TEXT
    //     ,Qty TEXT
    //     ,ProductID TEXT
    //     ,ProductCode TEXT
    //     ,Products_ID TEXT
    //     ,ProductName TEXT
    //     )''');

    // await db.execute('''CREATE TABLE PaymentOrders(
    //      ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,VendorID TEXT
    //     ,Datetime TEXT
    //     ,Amount TEXT
    //     ,Method TEXT
    //     ,BankName TEXT
    //     ,CheckNumber TEXT
    //     ,CheckDate TEXT
    //     ,IsEnabled TEXT
    //     ,Customer_Code TEXT
    //     ,IsOpen TEXT
    //     ,Imported TEXT
    //     )''');
    // await db.execute('''CREATE TABLE PaymentItems(
    //      ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,PaymentOrderId TEXT
    //     ,InvoiceNumber TEXT
    //     ,AmountApply TEXT
    //     ,InvoiveAmountAtMoment TEXT
    //     ,IsEnabled TEXT
    //     )''');

    // ///creando 2 tablas Factura y Factura detalle para cambiarle la forma del flujo y que sea mas entendible por los idiomas
    // ///

    // ///

    // ///
    // ///
    // await db.execute('''CREATE TABLE FacturaDetalle(
    //      ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,FacturaNumero TEXT
    //     ,LineaNumero1 TEXT
    //     ,Nombre TEXT
    //     ,PrecioVenta TEXT
    //     ,ProductoCodigo TEXT
    //     ,Qty TEXT
    //     ,montoLinea TEXT
    //     )''');

    // await db.execute('''CREATE TABLE Pago(
    //      ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     ,banco TEXT,
    //     clienteId INTEGER,
    //     clienteNombre TEXT,
    //     fechaCheque TEXT,
    //     formadePago TEXT,
    //     numeroDeCheque TEXT,
    //     valordelpago TEXT,
    //     vendedor TEXT
    //     )''');

    // await db.execute('''CREATE TABLE DetalleDePago(
    //      ID INTEGER PRIMARY KEY AUTOINCREMENT
    //     , fechaEmision TEXT
    //     , fechavencimiento TEXT
    //     , montoPagado TEXT
    //     , numeroDeFactura TEXT
    //     , pago INTEGER
    //     , valorfactura TEXT
    //     , valorpendiente TEXT
    //     , int activo INTEGER
    //     )''');
  }

//Agregar Clientes
  Future<int> agregarUsuario(Usuario usuario) async {
    Database db = await instance.database;
    return await db.insert('Usuario', usuario.toMapsql());
  }

  Future<int> obtenerUsuario(Usuario usuario) async {
    var user = usuario.usuarioNombre;
    var password = usuario.usuarioClave;
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Usuario WHERE usuarioNombre= '$user' and usuarioClave = '$password')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      return 0;
    }
    return 1;
  }

//Verificar si existe el Cliente antes de sincronizarlo
  Future<int> customerExists(Cliente cliente) async {
    var customerCode = cliente.codigo;
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Clientes WHERE codigo= '$customerCode')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      Add(cliente);
    }
    return 0;
  }

//Obtener Clientes
  Future<List<Cliente>> getCustomers() async {
    Database db = await instance.database;
    var customers = await db.query('Clientes', orderBy: 'nombre');
    List<Cliente> customersList = customers.isNotEmpty
        ? customers.map((c) => Cliente.fromMapSql(c)).toList()
        : [];

    return customersList;
  }

//Agregar Clientes
  Future<int> Add(Cliente customers) async {
    Database db = await instance.database;
    return await db.insert('Clientes', customers.toMapsql());
  }

  Future<int> agregarNuevoCLiente(Cliente customers) async {
    Database db = await instance.database;
    return await db.insert('Clientes', customers.toMapNewInsert());
  }

  Future<List<Cliente>> obtenerClientesNuevos() async {
    Database db = await instance.database;
    var clientes =
        await db.rawQuery("SELECT * FROM Clientes where sincronizado   = '1'");

    List<Cliente> listadeClientes = clientes.isNotEmpty
        ? clientes.map((e) => Cliente.fromMapSql(e)).toList()
        : [];

    return listadeClientes;
  }

  Future<List<Cliente>> obtenerCliente(String vendedor) async {
    Database db = await instance.database;
    var clientes = await db.rawQuery("SELECT * FROM Clientes ");

    List<Cliente> listadeClientes = clientes.isNotEmpty
        ? clientes.map((e) => Cliente.fromMapSql(e)).toList()
        : [];

    return listadeClientes;
  }

  Future<List<Cliente>> obtenerClientesPorVendedor(
      String vendedor, int compagnia) async {
    Database db = await instance.database;
    var clientes = await db
        .rawQuery("SELECT * FROM Clientes where   compagnia = $compagnia");
    // "SELECT * FROM Clientes where codigoVendedor = '$vendedor' and compagnia = $compagnia");

    List<Cliente> listadeClientes = clientes.isNotEmpty
        ? clientes.map((e) => Cliente.fromMapSql(e)).toList()
        : [];

    return listadeClientes;
  }

  Future<int> update(Cliente customers) async {
    Database db = await instance.database;

    final data = {
      'nombre': customers.nombre,
      'codigo': customers.codigo,
      'direccion': customers.direccion,
      'telefono1': customers.telefono1,
      'telefono2': customers.telefono2,
      'comentario': customers.comentario
    };

    final result = await db
        .update('Clientes', data, where: "id = ?", whereArgs: [customers.id]);
    return result;
  }

//Obtener Productos
  Future<List<Producto>> getProductos() async {
    Database db = await instance.database;
    var productos = await db.query('Productos', orderBy: 'Codigo');

    List<Producto> productoLista =
        productos.map((c) => Producto.fromMap(c)).toList();

    return productoLista;
  }

  // Future<int> Deletecustomer(Cliente customers) async {
  //   Database db = await instance.database;
  //   return await db.delete('Customer');
  // }

//Actualizar Clientes

  // Future<int> update(Customers customers) async {
  //   Database db = await instance.database;
  //   int? id = customers.id;

  //   return await db.update('Customer', customers.toMap(),
  //       where: '$id = ?', whereArgs: [id]);
  // }

  Future<int> productoExists(Producto producto) async {
    String codigoProducto = producto.codigo.toString();
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Productos WHERE Codigo= '$codigoProducto')");

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

  Future<int> aregardetalledePagoAsincronizar(PagoDetalle pago) async {
    var db = await instance.database;
    return await db.insert('PagoDetalle', pago.toJson());
    PagoTemporal.limpiarDetalle();
    PagoTemporal.pagos.clear();
  }

  Future<int> aregardetalledePago(PagoDetalle pago) async {
    var db = await instance.database;
    return await db.insert('PagoDetalle', pago.toJson());
  }

  Future<int> agregarPagoconID(Pago pago) async {
    Database db = await instance.database;
    int id = await db.insert('Pago', pago.toJsonsqlinsert());
    return id;
  }

  Future<int> AgregarPagoDescargado(Pago pago) async {
    var idFirebase = pago.idFirebase.toString().trim();

    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Pago WHERE idfirebase= '$idFirebase' )");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      agregarPagoFire(pago);
    }
    return 0;
  }

  Future<int> agregarPagoFire(Pago pago) async {
    var db = await instance.database;
    return await db.insert('Pago', pago.toJsonFire());
  }

  Future<int> agregarPago(Pago pago) async {
    var db = await instance.database;
    return await db.insert('Pago', pago.toJson());
  }

  Future<List<PagoDetalleLista>> obtenerDetalleDePagoPorPagoId(
      int pagoId) async {
    Database db = await instance.database;
    var detalle = await db.rawQuery(
        "SELECT Pago.id, pago.fechaPago, PagoDetalle.facturaId, Pago.MetodoDePago, Pago.montoPagado, Pago.Estado FROM Pago INNER JOIN PagoDetalle ON Pago.Id = PagoDetalle.pagoId Where pago.id ='$pagoId'");

    List<PagoDetalleLista> listadePagos = detalle.isNotEmpty
        ? detalle.map((e) => PagoDetalleLista.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<PagoDetalleLista>> obtenerDetalleDePagoPorCliente(
      String cliente) async {
    Database db = await instance.database;
    var detalle = await db.rawQuery(
        "SELECT Pago.id, pago.fechaPago, PagoDetalle.facturaId, Pago.MetodoDePago, Pago.montoPagado, Pago.Estado FROM Pago INNER JOIN PagoDetalle ON Pago.Id = PagoDetalle.pagoId Where clienteId ='$cliente'");

    List<PagoDetalleLista> listadePagos = detalle.isNotEmpty
        ? detalle.map((e) => PagoDetalleLista.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosASincornizar() async {
    Database db = await instance.database;
    var pagos = await db.rawQuery("SELECT * FROM Pago  ");

    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<PagoDetalle>> obtenerPagoDetallessASincornizarPorId(
      int pagoId) async {
    Database db = await instance.database;
    var pagos =
        await db.rawQuery("SELECT * FROM PagoDetalle where Pagoid =$pagoId");

    List<PagoDetalle> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => PagoDetalle.fromJsontofire(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<PagoDetalle>> obtenerPagoDetallessASincornizar() async {
    Database db = await instance.database;
    var pagos =
        await db.rawQuery("SELECT * FROM PagoDetalle where sincronizado =1");

    List<PagoDetalle> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => PagoDetalle.fromJsontofire(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosPorClientes(String cliente) async {
    Database db = await instance.database;
    var pagos =
        await db.rawQuery("SELECT * FROM Pago where clienteId ='$cliente'");

    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosPorFecha() async {
    Database db = await instance.database;
    var pagos = await db.rawQuery("SELECT * FROM Pago");

    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosPorClientesConNumeroDeFactura(
      String cliente) async {
    Database db = await instance.database;
    var pagos = await db
        .rawQuery("SELECT * FROM Pago inner join where clienteId ='$cliente'");

    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  // Future<List<Pago>> obtenerPagosPorClientes(String cliente) async {
  //   var db = await instance.database;
  //   var pagos = await db.query('Pago', orderBy: 'Id');
  //   List<Pago> listadePagos =
  //       pagos.isNotEmpty ? pagos.map((e) => Pago.fromMap(e)).toList() : [];

  //   return listadePagos;
  // }

  Future<int> addProduct(Producto producto) async {
    var db = await instance.database;
    return await db.insert('Productos', producto.toMap());
  }

  Future<int> eliminarProducto() async {
    var db = await instance.database;
    return await db.delete('Productos');
  }

  Future<bool> aregarProductoSiNoExiste(
      String ProductoCodigo, Producto producto) async {
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM Productos WHERE Codigo = '$ProductoCodigo' and IsDelete = 0");

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

  Future<List<Pedido>> obtenerPedidosPendienteDeSincornizacion() async {
    Database db = await instance.database;

    var res = await db.rawQuery(
        "SELECT * FROM Pedidos where Sincronizado = 1 and  IsDelete = 1");

    List<Pedido> ordenesLista =
        res.isNotEmpty ? res.map((c) => Pedido.fromMapsqlite(c)).toList() : [];
    return ordenesLista;
  }

  Future<List<PedidoDetalle>>
      obtenerDetallePedidosPendienteDeSincornizacion() async {
    Database db = await instance.database;

    var res =
        await db.rawQuery("SELECT * FROM PedidoDetalle where Sincronizado = 1");

    List<PedidoDetalle> ordenesLista = res.isNotEmpty
        ? res.map((c) => PedidoDetalle.toMapSqli(c)).toList()
        : [];
    return ordenesLista;
  }

  Future<List<Pedido>> obtenerPedidosPorClient(String clienteid) async {
    Database db = await instance.database;

    var res = await db
        .rawQuery("SELECT * FROM Pedidos where clienteId = '$clienteid'");

    List<Pedido> ordenesLista =
        res.isNotEmpty ? res.map((c) => Pedido.fromMapsqlite(c)).toList() : [];
    return ordenesLista;
  }

  Future<List<Pedido>> getOrdenes() async {
    Database db = await instance.database;
    var ordenes = await db.query('Pedidos', orderBy: 'ID');
    // List<OrdenVenta> ordenesLista = ordenes.isNotEmpty
    //     ? ordenes.map((c) => OrdenVenta.fromMap(c)).toList()
    //     : [];

    List<Pedido> ordenesLista = ordenes.isNotEmpty
        ? ordenes.map((c) => Pedido.fromMapsqlite(c)).toList()
        : [];
    return ordenesLista;
  }

  Future<List<Pedido>> getOrdenesPorvendedor() async {
    Database db = await instance.database;
    var ordenes = await db.query('Pedidos',
        orderBy: 'ID', where: 'vendorId = ?', whereArgs: [usuario]);
    // List<OrdenVenta> ordenesLista = ordenes.isNotEmpty
    //     ? ordenes.map((c) => OrdenVenta.fromMap(c)).toList()
    //     : [];

    List<Pedido> ordenesLista = ordenes.isNotEmpty
        ? ordenes.map((c) => Pedido.fromMapsqlite(c)).toList()
        : [];
    return ordenesLista;
  }

  // void addProduct(Producto producto) {}

//Pedidos de ventas

  Future<int> AgregarPedidoNoDescargado(Pedido pedido) async {
    var idFirebase = pedido.idfirebase.toString().trim();

    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Pedidos WHERE idfirebase= '$idFirebase' )");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      AgregarPedido(pedido);
    }
    return 0;
  }

  Future<int> AgregarPedido(Pedido pedido) async {
    Database db = await instance.database;
    return await db.insert('Pedidos', pedido.toMapSqli());
  }

//verificar si el detalle de pago ya existen antes de descargar
  Future<int> AgregarPedidoDetalleNoDescargado(PedidoDetalle detalle) async {
    var idfirebase = detalle.idfirebase;

    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM PedidoDetalle WHERE idfirebase= '$idfirebase')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      AgregarPedidoDetalle(detalle);
    }
    return 0;
  }

  Future<int> AgregarPedidoDetalle(PedidoDetalle detalle) async {
    Database db = await instance.database;
    return await db.insert('PedidoDetalle', detalle.toMap());
  }

  // Future<int> actualizarPagoCargado(int id, String idFire) async {
  //   Database db = await instance.database;
  //   final data = {
  //     'sincronizado': 0,
  //     'idfirebase': idFire
  //     // 'description': descrption,
  //     // 'createdAt': DateTime.now().toString()
  //   };

  //   final result =
  //       await db.update('PagoDetalle', data, where: "ID = ?", whereArgs: [id]);
  //   return result;
  // }

  Future<int> actualizarPagoCargado(int id, String idFire) async {
    Database db = await instance.database;
    final data = {'sincronizado': 0, 'idfirebase': idFire};

    final result =
        await db.update('Pago', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> actualizarClientesCargado(int id) async {
    Database db = await instance.database;
    final data = {
      'Sincronizado': 0,
      // 'description': descrption,
      // 'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('Clientes', data, where: "ID = ?", whereArgs: [id]);
    return result;
  }

  Future<List<PedidoDetalle>> obtenerPedidoDetalleEspecificoASincronizar(
      int id) async {
    Database db = await instance.database;

    var res =
        await db.rawQuery("SELECT * FROM PedidoDetalle where    PedidoId =$id");

    List<PedidoDetalle> ordenesLista = res.isNotEmpty
        ? res.map((c) => PedidoDetalle.toMapSqli(c)).toList()
        : [];
    return ordenesLista;
  }

  Future<int> actualizarPedidoCargado(int id, String idfire) async {
    Database db = await instance.database;
    final data = {'Sincronizado': 0, 'idfirebase': idfire};

    final result =
        await db.update('Pedidos', data, where: "ID = ?", whereArgs: [id]);
    return result;
  }

  Future<int> actualizarPedidoDetalleCargado(int id, String idfire) async {
    Database db = await instance.database;
    final data = {
      'Sincronizado': 0,
      'idfirebase': idfire
      // 'description': descrption,
      // 'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('PedidoDetalle', data, where: "PedidoId = ?", whereArgs: [id]);
    return result;
  }

  Future<int> AddSalesWithId(Pedido pedido) async {
    Database db = await instance.database;
    int id = await db.insert('Pedidos', pedido.toMapSql());
    return id;
  }

  Future<int> AddSalesDetalle(PedidoDetalle detallePedido) async {
    Database db = await instance.database;
    return await db.insert('PedidoDetalle', detallePedido.toMapInsert());
  }

// //obtener el proximo numero de orden
  Future<String> getNextSalesOrders() async {
    Database db = await instance.database;
    var res =
        await db.rawQuery("SELECT * FROM Pedidos ORDER BY ID DESC LIMIT 1; ");
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

// .rawQuery("SELECT * FROM Factura WHERE clienteId= '$clienteId' and facturaPagada = 1");
    List<Factura> facturaList = factura.map((c) => Factura.fromMap(c)).toList();
    // Factura.fromJson(c)).toList();

    return facturaList;
  }

  Future<bool> obtenerFacturasPendientesdepago(String clienteId) async {
    Database db = await instance.database;
    var res = await db.rawQuery(
        "SELECT count(*) FROM Factura WHERE clienteId= '$clienteId' and montoPendiente > 0.0 ");
    int count = res.length;
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Pago>> obtenerPagoPorIdyCliente(int id) async {
    Database db = await instance.database;
    var pago = await db.rawQuery("SELECT * FROM Pago where id = '$id'");

    List<Pago> pagos = pago.map((e) => Pago.fromMapSqlLite(e)).toList();

    return pagos;
  }

  Future<List<PagoDetalle>> obtenerPagoDetallePorIdyCliente(int pagoid) async {
    Database db = await instance.database;
    var pago =
        await db.rawQuery("SELECT * FROM PagoDetalle where pagoId = '$pagoid'");

    List<PagoDetalle> pagos = pago.map((e) => PagoDetalle.fromJson(e)).toList();

    return pagos;
  }

  Future<List<FacturaDetalle>> obtenerDetalleDeFactura() async {
    Database db = await instance.database;
    var factura = await db.query('FacturaDetalle', orderBy: 'ID');

    List<FacturaDetalle> productoLista =
        factura.map((e) => FacturaDetalle.fromMap(e)).toList();

    return productoLista;
  }

  Future<List<FacturaDetalle>> obtenerDetalleDeFacturaPorFacturaId(
      String facturaId) async {
    int compa = compagnia;
    Database db = await instance.database;
    var detalleFactura = await db
        .rawQuery("SELECT * FROM FacturaDetalle WHERE FacturaId= '$facturaId'");

    List<FacturaDetalle> productoLista =
        detalleFactura.map((e) => FacturaDetalle.fromMapSql(e)).toList();

    return productoLista;
  }

  Future<List<Factura>> getFacturasById(String clienteId) async {
    Database db = await instance.database;
    var facturas = await db
        .rawQuery("SELECT * FROM Factura where clienteId = '$clienteId' ");
    // )
    // var factura = await db.query('Factura', orderBy: 'ID', where: clienteId);

    List<Factura> facturaLista =
        facturas.map((e) => Factura.fromMap(e)).toList();

    return facturaLista;
  }

  Future<List<Factura>> getFacturas() async {
    Database db = await instance.database;
    var factura = await db.query('Factura', orderBy: 'ID');

    List<Factura> productoLista =
        factura.map((e) => Factura.fromMap(e)).toList();

    return productoLista;
  }

  Future<int> AddDetalleFactura(FacturaDetalle factura) async {
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

  Future<int> SincronizarDefalleFactura(FacturaDetalle factura) async {
    String facturaNumero = factura.facturaId;
    String productoCodigo = factura.productoCodigo;
    Database db = await instance.database;
    var res = await db.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM facturaDetalle WHERE FacturaId= '$facturaNumero' and ProductoCodigo = '$productoCodigo' and IsDelete = 1 )");

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

  Future<List<PedidoDetalle>> getDetallesporId(String id) async {
    Database db = await instance.database;
    var detalle =
        await db.rawQuery("SELECT * FROM PedidoDetalle WHERE PedidoId = '$id'");
    // await db.rawQuery("SELECT * FROM PedidoDetalle");

    List<PedidoDetalle> ordenesDetalleLista = detalle.isNotEmpty
        ? detalle.map((c) => PedidoDetalle.fromMap(c)).toList()
        : [];
    return ordenesDetalleLista;
  }

  Future<int> CantidadDeClientesPorMes() async {
    var mes =
        obtenerMes(DateTime.now().month); // DateTime.now().month.toString();
    var user = usuario;
    var compania = compagnia;
    var dbClient = await instance.database;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery(
        // "SELECT COUNT(*) from  Clientes  WHERE   codigoVendedor ='$user'")) ??
        "SELECT COUNT(*) from  Clientes  WHERE   codigoVendedor ='$user' and  strftime('%m', creadoEn) = '$mes'")) ?? 0;

    // var res = await dbClient.rawQuery(
    //     "SELECT COUNT(*) FROM Pedidos  WHERE vendorId ='$user' and  strftime('%m', FechaOrden) = '$mes'");
    // int count = Sqflite.firstIntValue(res);
    return count;
  }

  Future<int> CantidadDevisitas() async {
    var mes = obtenerMes(DateTime.now().month - 1); //DateTime.now().month;
    // var mesactual = mes - 1;
    var user = usuario;
    var compania = compagnia;
    var dbClient = await instance.database;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery(
            "SELECT * from Clientes INNER JOIN Pedidos  ON Clientes.codigo = Pedidos.ClienteId  WHERE   codigoVendedor ='$user' and  strftime('%m', creadoEn) = '$mes'")) ??
        0;

    // var res = await dbClient.rawQuery(
    //     "SELECT COUNT(*) FROM Pedidos  WHERE vendorId ='$user' and  strftime('%m', FechaOrden) = '$mes'");
    // int count = Sqflite.firstIntValue(res);
    return count;
  }

  Future<int> CantidadDeVentas() async {
    var mes = obtenerMes(DateTime.now().month); //DateTime.now().month;
    var user = usuario;
    var compania = compagnia;
    var dbClient = await instance.database;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery(
            "SELECT COUNT(*) from  Pedidos  WHERE vendorId LIKE '%$user%' and  strftime('%m', FechaOrden) = '$mes' ")) ??
        0;

    return count;
  }

  Future<int> obtenerProductosMasVendidor() async {
    var mes = obtenerMes(DateTime.now().month); //DateTime.now().month;
    var user = usuario;
    var compania = compagnia;
    var dbClient = await instance.database;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery(
            "SELECT COUNT(*) from  Pedidos  WHERE vendorId LIKE '%$user%' and  strftime('%m', FechaOrden) = '$mes' ")) ??
        0;

    return count;
  }

  Future<int> cantidadDeCobros() async {
    var mes = obtenerMes(DateTime.now().month);

    var user = usuario;
    var compania = compagnia;
    var dbClient = await instance.database;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery(
            "SELECT COUNT(*) FROM Pago WHERE vendorId LIKE '%$user%' and  strftime('%m', fechaPago) = '$mes'")) ??
        0;
    return count;
  }

  Future<int> Puntajes() async {
    var mes = obtenerMes(DateTime.now().month);
    var user = usuario;
    var compania = compagnia;
    var dbClient = await instance.database;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery(
            "SELECT COUNT(*) FROM Pago WHERE vendorId = '$user' and  strftime('%m', fechaPago) = '$mes'")) ??
        0;

    var resultado = count / 1105200.00 * 100;
    return count;
  }

  Future<List<PedidosMasVendidos>> obtenerProductoMasVendedido() async {
    var mes = obtenerMes(DateTime.now().month);
    Database db = await instance.database;
    var detalle = await db.rawQuery(
        "SELECT Codigo , Nombre Nombre ,   count(Cantidad) as Cantidad FROM Pedidos al  INNER JOIN PedidoDetalle ar ON ar.PedidoId = al.ID WHERE  strftime('%m', FechaOrden) = '$mes' GROUP BY Nombre ORDER BY count(Nombre) DESC");
    // await db.rawQuery("SELECT * FROM PedidoDetalle");

    List<PedidosMasVendidos> ordenesDetalleLista = detalle.isNotEmpty
        ? detalle.map((c) => PedidosMasVendidos.fromMap(c)).toList()
        : [];
    return ordenesDetalleLista;
  }
}
