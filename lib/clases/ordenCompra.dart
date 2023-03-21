class Orden_Compra {
  final int id;
  final String nombre;
  final String imagen;
  final double precio;
  int cantidad;

  Orden_Compra(
      {required this.id,
      required this.nombre,
      this.cantidad = 0,
      required this.imagen,
      required this.precio});

  final List<Orden_Compra> ordenCompra = [
    Orden_Compra(
        id: 1,
        nombre: 'Tv',
        imagen:
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
        precio: 1500.5),
    Orden_Compra(
        id: 1,
        nombre: 'cama',
        imagen:
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
        precio: 534.5),
    Orden_Compra(
        id: 1,
        nombre: 'telefono',
        imagen:
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
        precio: 155.5),
    Orden_Compra(
        id: 1,
        nombre: 'taza',
        imagen:
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
        precio: 5.5),
  ];
}
