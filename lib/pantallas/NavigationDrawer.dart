import 'package:flutter/material.dart';
import 'package:sigalogin/clases/global.dart';
import 'package:sigalogin/pantallas/DashboardScreen.dart';
import 'package:sigalogin/pantallas/pedidos/PedidosVentas.dart';
import 'package:sigalogin/pantallas/pedidos/ordenesDeventa.dart';
import 'package:sigalogin/pantallas/pedidos/pedidos.dart';
import 'package:sigalogin/pantallas/pedidosLista.dart';
import 'package:sigalogin/pantallas/productos/products_screen.dart';
import 'package:sigalogin/pantallas/sincronizar/products_screen.dart';
import 'package:sigalogin/pantallas/user_screen.dart';

import '../clases/themes.dart';
import 'clientes/listaClientes.dart';
import 'login/IniciarUsuario.dart';

class navegacions extends StatelessWidget {
  // const NavigationDrawer({Key? key}) : super(key: key)

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ])),
      );

  Widget buildHeader(BuildContext context) => Material(
      // Container(

      // color: Colors.blue.shade700,
      color: Color.fromARGB(255, 61, 64, 238),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserPage(),
          ));
        },
        child: Container(
          padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/21/21104.png'),
              ),
              SizedBox(height: 12),
              // Text(
              //   'Gabriel Montero ',
              //   style: TextStyle(fontSize: 28, color: Colors.white),
              // ),
              Text(
                usuario.replaceAll('@gmail.com', ''),
                style: TextStyle(fontSize: 28, color: Colors.white),
              )
            ],
          ),
        ),
      ));

  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24), //espacio del padding
      child: Wrap(
        runSpacing: 16, //espacio entre ellos
        children: [
          ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DashboardScreen()
                      // builder: (context) => HomeScreen(),
                      ))),
          ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Clientes'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    // builder: (context) => CustomerList(),
                    builder: (context) => clienteLista(),
                  ))),
          ListTile(
              leading: const Icon(Icons.point_of_sale_sharp),
              title: const Text('Pedidos de Venta'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    // builder: (context) => pedidop(),
                    builder: (context) => pedidosLista(),
                  ))),
          ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text('Productos'),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProductsList(),
                    // builder: (context) => DashboardScreen(),
                  ))),
          ListTile(
            leading: const Icon(Icons.padding_outlined),
            title: const Text('Reporte'),
            onTap: () {},
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Sincronizar'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                // builder: (context) => pedidop(),
                builder: (context) => Cart(),
              ));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text('Perfil'),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_outlined),
            title: const Text('Salir'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                // builder: (context) => pedidop(),
                builder: (context) => LoginScreen(),
              ));
            },
          ),
        ],
      ));
}
