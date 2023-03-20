import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sigalogin/servicios/db_helper.dart';

import '../clases/components/card_custom.dart';
import '../clases/components/circle_progress.dart';
import '../clases/components/list_tile_custom.dart';
import '../clases/modelos/clientes.dart';
import '../clases/pedidoDetalle.dart';
import '../clases/themes.dart';
import 'NavigationDrawer.dart';

class DashboardScreen extends StatefulWidget {
  @override
  createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  var nuevosclientes = 0;
  var cantidadDevisitas =
      0; //DatabaseHelper.instance.CantidadDeClientesPorMes();
  int fijos = 105;
  late var ventas = 0; //DatabaseHelper.instance.CantidadDeVentas();
  var cobros = 0; //DatabaseHelper.instance.cantidadDeCobros();
  var puntaje = 0;
  late List<PedidosMasVendidos> productos = [];
  // const DashboardScreen({
  //   Key? key,
  // }) : super(key: key);

  Future obtenerCantidadesDeCleintes() async {
    //here you can call the function and handle the output(return value) as result
    DatabaseHelper.instance.CantidadDeClientesPorMes().then((result) {
      print(result);
      setState(() {
        nuevosclientes = result;
        //DatabaseHelper.instance.CantidadDeVentas();
      });
    }); //you can call handleError method show an alert or to try again
  }

  Future obtenerCantidadesDevisitas() async {
    //here you can call the function and handle the output(return value) as result
    DatabaseHelper.instance.CantidadDevisitas().then((result) {
      print(result);
      setState(() {
        fijos = result;
        //DatabaseHelper.instance.CantidadDeVentas();
      });
    }); //you can call handleError method show an alert or to try again
  }

  Future obtenerCantidadDeventas() async {
    //here you can call the function and handle the output(return value) as result
    DatabaseHelper.instance.CantidadDeVentas().then((result) {
      print(result);
      setState(() {
        ventas = result;
        //DatabaseHelper.instance.CantidadDeVentas();
      });
    }); //you can call handleError method show an alert or to try again
  }

  Future obtenerCantidadDeCobros() async {
    //here you can call the function and handle the output(return value) as result
    DatabaseHelper.instance.cantidadDeCobros().then((result) {
      print(result);
      setState(() {
        cobros = result;
        //DatabaseHelper.instance.CantidadDeVentas();
      });
    }); //you can call handleError method show an alert or to try again
  }

  Future obtenerpuntaje() async {
    //here you can call the function and handle the output(return value) as result
    DatabaseHelper.instance.Puntajes().then((result) {
      print(result);
      setState(() {
        puntaje = result;
        //DatabaseHelper.instance.CantidadDeVentas();
      });
    }); //you can call handleError method show an alert or to try again
  }

  Future obtenerProductosMasVendidos() async {
    //here you can call the function and handle the output(return value) as result
    DatabaseHelper.instance.obtenerProductoMasVendedido().then((result) {
      print(result);
      setState(() {
        productos = result;
        //DatabaseHelper.instance.CantidadDeVentas();
      });
    }); //you can call handleError method show an alert or to try again
  }

  @override
  void initState() {
    obtenerCantidadDeCobros();
    obtenerCantidadDeventas();
    obtenerCantidadesDeCleintes();
    obtenerProductosMasVendidos();
    // obtenerCantidadesDeCleintes();
    // Clients = Client.getClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: navBar,
          elevation: 0.0,
          title: Text('Dashboard')),
      drawer: navegacions(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width / 2 - 20,
                        child: Column(
                          children: [
                            CustomPaint(
                              foregroundPainter: CircleProgress(),
                              child: SizedBox(
                                width: 107,
                                height: 107,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      puntaje.toString(),
                                      style: textBold,
                                    ),
                                    Text(
                                      "Meta",
                                      style: textSemiBold,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_upward_outlined,
                                          color: green,
                                          size: 14,
                                        ),
                                        Text(
                                          "0.1%",
                                          style: textSemiBold,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "Ventas",
                              style: textBold2,
                            ),
                            Text(
                              puntaje > 100
                                  ? "Mejor Vendedor"
                                  : "Sigue avanzando",
                              style: textBold3,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          // width: size.width / 2 - 20,
                          // height: 180,
                          // decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //         image: AssetImage("assets/images/people.png"))),
                          )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 6,
                  color: sparatorColor,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Tus metricas ",
                            style: GoogleFonts.montserrat().copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: purple1),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: " Este Mes",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CardCustom(
                            width: size.width / 2 - 23,
                            height: 88.9,
                            mLeft: 0,
                            mRight: 3,
                            child: ListTileCustom(
                              bgColor: purpleLight,
                              pathIcon: "thumb_up.svg",
                              title: "Visitas",
                              subTitle: cantidadDevisitas.toString(),
                            ),
                          ),
                          CardCustom(
                            width: size.width / 2 - 23,
                            height: 88.9,
                            mLeft: 3,
                            mRight: 0,
                            child: ListTileCustom(
                              bgColor: greenLight,
                              pathIcon: "thumb_up.svg",
                              title: "Ventas",
                              subTitle: ventas.toString(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CardCustom(
                            width: size.width / 2 - 23,
                            height: 88.9,
                            mLeft: 0,
                            mRight: 3,
                            child: ListTileCustom(
                              bgColor: yellowLight,
                              pathIcon: "starts.svg",
                              title: "Nuevos Clientes",
                              subTitle: nuevosclientes.toString(),
                            ),
                          ),
                          CardCustom(
                            width: size.width / 2 - 23,
                            height: 88.9,
                            mLeft: 3,
                            mRight: 0,
                            child: ListTileCustom(
                              bgColor: blueLight,
                              pathIcon: "eyes.svg",
                              title: "Cobros",
                              subTitle: cobros.toString(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          //  ol(
                          //   child: Text('Top 10 Productos mas vendidos'),
                          // ),
                          Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(children: [])),
                          Expanded(
                            child: SizedBox(
                              height: 200.0,
                              child: new ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: productos.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: Text((index + 1).toString()),
                                      trailing: Text(
                                        productos[index].cantidad.toString(),
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 15),
                                      ),
                                      title: Text(
                                          'Articulo : ' +
                                              productos[index]
                                                  .nombre
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic)),
                                      // subtitle: Text('Cantidad : ' +
                                      //     productos[index].cantidad.toString()),
                                    );
                                  }),
                            ),
                          ),
                          // new IconButton(
                          //   icon: Icon(Icons.remove_circle),
                          //   onPressed: () {},
                          // ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: ListView(),
    );
  }
}
