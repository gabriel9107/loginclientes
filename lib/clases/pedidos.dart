class Contact {
  Contact({required this.id, required this.name, required this.mobile});

  int id;
  String name;
  String mobile;
}

class pedidos {
  late String Id;
  String OrdenNumero;
  String IdCliente;
  String CodigoProducto;
  String Cantidad;
  String Precio;
  String Descuento;

  pedidos(this.OrdenNumero, this.IdCliente, this.CodigoProducto, this.Cantidad,
      this.Precio, this.Descuento);
}
