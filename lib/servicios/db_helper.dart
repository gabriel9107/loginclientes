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
    String path = join(documentsDirectory.path, '82.db');
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
        clienteNombre TEXT,
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
         , compagnia INTEGER 
             )''');

    await db.execute('''CREATE TABLE Usuario(
           id INTEGER PRIMARY KEY AUTOINCREMENT, 
           Nombre TEXT, 
           Apellido TEXT       
        ,UsuarioNombre TEXT
        ,UsuarioClave TEXT
        ,Compagnia INTEGER
        ,Activo INTEGER
        , sincronizado INTEGER 
        )''');
  }

//Agregar Clientes
  Future<int> agregarUsuario(Usuario usuario) async {
    Database db = await instance.database;
    return await db.insert('Usuario', usuario.toMap());
  }

  Future<int> agregarUsuarioActualizadoFire(Usuario usuario) async {
    Database db = await instance.database;
    return await db.insert('Usuario', usuario.toMapFireActualizado());
  }

  ///0 - El usuario no existe
  ///1 - Clave  inccorrecta
  ///2 - Seccion inicada

  Future<int> obtenerUsuario(
      String usuario, String clave, int compagnia) async {
    var user = usuario;
    var password = clave;

    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Usuario WHERE usuarioNombre= '$user'and Compagnia=$compagnia)");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 1) {
      var validar = await dbClient.rawQuery(
          "SELECT EXISTS(SELECT 1 FROM Usuario WHERE usuarioNombre= '$user' and usuarioClave = '$password' and Compagnia=$compagnia)");
      int? iniciando = Sqflite.firstIntValue(validar);
      if (iniciando == 1) return 2;

      return 1;
    }
    return 0;
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    final db = await database;

    await db.update(
      'Usuario',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> actualizarUsarioCargado(int id) async {
    Database db = await instance.database;
    final data = {
      'sincronizado': 1,
    };

    final result =
        await db.update('Usuario', data, where: "ID = ?", whereArgs: [id]);
    return result;
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

  Future<List<Usuario>> obtenerInformacionUsuario(
      int compagnia, String usuarioNombre) async {
    Database db = await instance.database;
    var usuarios = await db.query(
      'Usuario',
      // orderBy: 'UsuarioNombre',
      where: " Compagnia = ? and UsuarioNombre =?",
      whereArgs: [compagnia, usuarioNombre],
    );
    List<Usuario> usuariosList = usuarios.isNotEmpty
        ? usuarios.map((c) => Usuario.fromMapSql(c)).toList()
        : [];

    return usuariosList;
  }

  Future<List<Usuario>> obtenerListaDeUsuariosPendienteASincronizar(
      int compagnia) async {
    Database db = await instance.database;
    var usuarios = await db.query(
      'Usuario',
      orderBy: 'UsuarioNombre',
      where: " Compagnia = ? and sincronizado = ?",
      whereArgs: [compagnia, 0],
    );
    List<Usuario> usuariosList = usuarios.isNotEmpty
        ? usuarios.map((c) => Usuario.fromMapSql(c)).toList()
        : [];

    return usuariosList;
  }

  Future<List<Usuario>> obtenerListaDeUsuarios(int compagnia) async {
    Database db = await instance.database;
    var usuarios = await db.query(
      'Usuario',
      orderBy: 'UsuarioNombre',
      where: " Compagnia = ?",
      whereArgs: [compagnia],
    );
    List<Usuario> usuariosList = usuarios.isNotEmpty
        ? usuarios.map((c) => Usuario.fromMapSql(c)).toList()
        : [];

    return usuariosList;
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

//obtiene los clientes nuevos, que tienen pedidos
// No : 0
// Si : 1

  Future<List<Cliente>> obtenerClientesNuevos() async {
    Database db = await instance.database;
    var clientes = await db.rawQuery(
        "SELECT Clientes.* FROM Clientes INNER JOIN Pedidos  ON Clientes.codigo = Pedidos.ClienteId where Clientes.sincronizado =0 and  Pedidos.Sincronizado = 0;");
    // var clientes = await db.rawQuery("SELECT Clientes.* FROM Clientes INNER JOIN Pedidos ON Clientes.codigo = Pedidos.ClienteId where Clientes.sincronizado   = 0 and  Pedidos.Sincronizado = 0");

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
    var clientes = await db.rawQuery(
        "SELECT * FROM Clientes    where   codigoVendedor = '$vendedor' and   compagnia = $compagnia");
    //  "SELECT * FROM Clientes where codigoVendedor = '$vendedor' and compagnia = $compagnia");

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
    var productos = await db.query('Productos',
        orderBy: 'Codigo', where: 'compagnia =?', whereArgs: [compagnia]);

    List<Producto> productoLista =
        productos.map((c) => Producto.fromMap(c)).toList();

    return productoLista;
  }

  Future<int> productoExists(Producto producto) async {
    String codigoProducto = producto.codigo.toString();
    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Productos WHERE Codigo= '$codigoProducto' and compagnia =$compagnia");

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
    return await db.insert('PagoDetalle', pago.toInsertSql());
    PagoTemporal.limpiarDetalle();
    PagoTemporal.pagos.clear();
  }

  Future<int> aregardetalledePago(PagoDetalle pago) async {
    var db = await instance.database;
    return await db.insert('PagoDetalle', pago.toJson());
  }

  Future<int> agregarPagoconID(Pago pago) async {
    Database db = await instance.database;

    int id = await db.insert('Pago', pago.toJsonsql2());
    return id;
  }

  Future<int> AgregarPagoDescargado(Pago pago) async {
    var idFirebase = pago.idFirebase.toString().trim();

    var dbClient = await instance.database;
    var res = await dbClient.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Pago WHERE idfirebase= '$idFirebase' and compagni = $compagnia )");

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
        "SELECT Pago.id, pago.fechaPago, PagoDetalle.facturaId, Pago.MetodoDePago, Pago.montoPagado, Pago.Estado FROM Pago INNER JOIN PagoDetalle ON Pago.Id = PagoDetalle.pagoId Where pago.id ='$pagoId' and Pago.compagni =$compagnia");

    List<PagoDetalleLista> listadePagos = detalle.isNotEmpty
        ? detalle.map((e) => PagoDetalleLista.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<PagoDetalleLista>> obtenerDetalleDePagoPorCliente(
      String cliente) async {
    Database db = await instance.database;
    var detalle = await db.rawQuery(
        "SELECT Pago.id, pago.fechaPago, PagoDetalle.facturaId, Pago.MetodoDePago, Pago.montoPagado, Pago.Estado, Pago.compagni FROM Pago INNER JOIN PagoDetalle ON Pago.Id = PagoDetalle.pagoId Where clienteId ='$cliente' and Pago.compagni =$compagnia order by fechaPago desc");

    List<PagoDetalleLista> listadePagos = detalle.isNotEmpty
        ? detalle.map((e) => PagoDetalleLista.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosASincornizar() async {
    Database db = await instance.database;
    var pagos = await db.rawQuery(
        "SELECT * FROM Pago  where compagni =$compagnia and sincronizado = 0");

    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<PagoDetalle>> obtenerPagoDetallessASincornizarPorId(
      int pagoId) async {
    Database db = await instance.database;
    var pagos = await db.rawQuery(
        "SELECT PagoDetalle.* FROM Pago INNER JOIN PagoDetalle ON Pago.Id = PagoDetalle.pagoId Where pago.id ='$pagoId' and Pago.compagni =$compagnia");

    List<PagoDetalle> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => PagoDetalle.fromJsontofire(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<PagoDetalle>> obtenerPagoDetallessASincornizar() async {
    Database db = await instance.database;
    var pagos = await db.rawQuery(
        "SELECT * FROM PagoDetalle where sincronizado =1 and compagnia =$compagnia");

    List<PagoDetalle> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => PagoDetalle.fromJsontofire(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosPorClientes(String cliente) async {
    Database db = await instance.database;
    var pagos = await db.rawQuery(
        "SELECT * FROM Pago where clienteId ='$cliente' and compagni = $compagnia");

    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosPorFecha() async {
    Database db = await instance.database;
    var pagos =
        await db.rawQuery("SELECT * FROM Pago where compagni = $compagnia");

    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosPorFechaParaReporte(
      String fechaInicio, String fechaFin) async {
    Database db = await instance.database;

    var pagos =
        await db.rawQuery("SELECT * FROM Pago where compagni = $compagnia");

    // var pagos = await db.rawQuery(
    //     "SELECT * FROM Pago where compagni = $compagnia and fechaPago BETWEEN $fechaInicio and $fechaFin and vendorId = $usuario");
    List<Pago> listadePagos = pagos.isNotEmpty
        ? pagos.map((e) => Pago.fromMapSqlLiteWitId(e)).toList()
        : [];

    return listadePagos;
  }

  Future<List<Pago>> obtenerPagosPorClientesConNumeroDeFactura(
      String cliente) async {
    Database db = await instance.database;
    var pagos = await db.rawQuery(
        "SELECT * FROM Pago inner join where clienteId ='$cliente' and compagni = $compagnia");

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
        "SELECT * FROM Productos WHERE Codigo = '$ProductoCodigo' and IsDelete = 0 and compagnia = $compagnia");

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
        "SELECT * FROM Pedidos where Sincronizado = 0 and  IsDelete = 0 and compagnia =$compagnia");

    List<Pedido> ordenesLista =
        res.isNotEmpty ? res.map((c) => Pedido.fromMapsqlite(c)).toList() : [];
    return ordenesLista;
  }

  Future<List<PedidoDetalle>>
      obtenerDetallePedidosPendienteDeSincornizacion() async {
    Database db = await instance.database;

    var res = await db.rawQuery(
        "SELECT * FROM PedidoDetalle where Sincronizado = 0 and compagnia = $compagnia");

    List<PedidoDetalle> ordenesLista = res.isNotEmpty
        ? res.map((c) => PedidoDetalle.toMapSqli(c)).toList()
        : [];
    return ordenesLista;
  }

  Future<List<Pedido>> obtenerPedidosPorClient(String clienteid) async {
    Database db = await instance.database;

    var res = await db.rawQuery(
        "SELECT * FROM Pedidos where clienteId = '$clienteid' and compagnia = $compagnia order by fechaOrden desc");

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

  Future<List<PedidoLista>> getPedidosClientescompletoNoSincronizado() async {
    Database db = await instance.database;
    var pedido = await db.rawQuery(
        "select Pedidos.*, Clientes.nombre clienteNombre from Pedidos inner join Clientes where Pedidos.ClienteId = Clientes.codigo and Pedidos.Compagnia  = Clientes.compagnia and Pedidos.vendorId = '$usuario' and Pedidos.Compagnia =$compagnia");

    List<PedidoLista> pedidoLista =
        pedido.map((c) => PedidoLista.fromMapsqlite(c)).toList();
    return pedidoLista;
  }

  Future<List<PedidoLista>> getPedidosClientescompleto() async {
    Database db = await instance.database;
    var pedido = await db.rawQuery(
        "select Pedidos.*, Clientes.nombre clienteNombre from Pedidos inner join Clientes where Pedidos.ClienteId = Clientes.codigo and Pedidos.Compagnia  = Clientes.compagnia and Pedidos.vendorId = '$usuario'");

    List<PedidoLista> pedidoLista =
        pedido.map((c) => PedidoLista.fromMapsqlite(c)).toList();
    return pedidoLista;
  }

  Future<List<Pedido>> getOrdenesPorvendedor() async {
    Database db = await instance.database;
    var ordenes = await db.query('Pedidos',
        orderBy: 'fechaOrden DESC',
        where: 'vendorId = ?',
        whereArgs: [usuario]);
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
        "SELECT EXISTS(SELECT 1 FROM Pedidos WHERE idfirebase= '$idFirebase' and compagnia =$compagnia)");

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
        "SELECT EXISTS(SELECT 1 FROM PedidoDetalle WHERE idfirebase= '$idfirebase'and compagnia = $compagnia)");

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
    final data = {'sincronizado': 1, 'idfirebase': idFire};

    final result =
        await db.update('Pago', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> actualizarClientesCargado(int id) async {
    Database db = await instance.database;
    final data = {
      'Sincronizado': 1,
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
    final data = {'Sincronizado': 1, 'idfirebase': idfire};

    final result =
        await db.update('Pedidos', data, where: "ID = ?", whereArgs: [id]);
    return result;
  }

  Future<int> actualizarPedidoDetalleCargado(int id, String idfire) async {
    Database db = await instance.database;
    final data = {
      'Sincronizado': 1,
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
    var factura = await db.rawQuery(
        "SELECT * FROM Factura WHERE clienteId= '$clienteId' and MontoPendiente > 3 order by facturaFecha desc");

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
    return await db.insert('FacturaDetalle', factura.toMapSql());
  }

  Future<int> SincronizarFactura(Factura factura) async {
    String facturaNumero = factura.facturaId.toString();
    Database db = await instance.database;
    var res = await db.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Factura WHERE FacturaId= '$facturaNumero')");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      AddFactura(factura);
    } else {
      actualizarFactura(factura);
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
    var detalle = await db.rawQuery(
        "SELECT * FROM PedidoDetalle WHERE PedidoId = '$id' and Compagnia =$compagnia");
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

  Future<int> verificarUsuarioASincronizar(Usuario element) async {
    var usuario = element.usuarioNombre;
    int company = element.compania;
    Database db = await instance.database;
    var res = await db.rawQuery(
        "SELECT EXISTS(SELECT 1 FROM Usuario WHERE usuarioNombre= '$usuario' and Compagnia = $company)");

    int? exists = Sqflite.firstIntValue(res);
    if (exists == 0) {
      agregarUsuarioActualizadoFire(element);
    }
    return 1;
  }

  Future<int> actualizarFactura(Factura factura) async {
    Database db = await instance.database;
    final data = {
      'totalPagado': factura.totalPagado,
      'MontoPendiente': factura.montoPendiente
      // 'description': descrption,
      // 'createdAt': DateTime.now().toString()
    };

    final result = await db.update('Factura', data,
        where: "FacturaId = ?", whereArgs: [factura.facturaId]);
    return result;
  }
}
