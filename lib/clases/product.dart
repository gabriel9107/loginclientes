class Product {
  late int id;
  String nombre;
  String codigo;
  String descripcion;
  String costo;

  Product(
      {required this.nombre,
      required this.codigo,
      required this.descripcion,
      required this.costo});

  // Product.WithID(
  //     this._id, this._nombre, this._codigo, this._descripcion, this._costo);

  // int get id => _id;
  // String get nombre => _nombre;
  // String get codigo => _codigo;
  // String get descripcion => _descripcion;
  // String get costo => _costo;

  static List<Product> getProduct() {
    return <Product>[
      Product(
          nombre: 'TVR ARO        ',
          codigo: '160X14                         ',
          descripcion: 'TVR ARO 1.60 X 14 NIQUEL',
          costo: '993.18'),
      Product(
          nombre: 'ARO 1.40 X 17  ',
          codigo: '1.40X17                        ',
          descripcion: 'TVR ARO 1.40 X 17 NIQUEL',
          costo: '863.63'),
      Product(
          nombre: 'JUNTA COMPL AX ',
          codigo: '11400-23830                    ',
          descripcion: 'R.B JUNTA COMPLETO AX100',
          costo: '130.83'),
      Product(
          nombre: 'TORNILLO 6X22  ',
          codigo: '96000-06022                    ',
          descripcion:
              'TVR TORNILLO EXAGONAL 8 1 PUL                                                                        ',
          costo: '4.81'),
      Product(
          nombre: 'SPRING VARILLA ',
          codigo: '95014-73100                    ',
          descripcion:
              'SPRING VARILLA FRENO C70  (10 PC)                                                                    ',
          costo: '3.32'),
      Product(
          nombre: 'BARRA EST C70  ',
          codigo: '50610-087-00                   ',
          descripcion:
              'AVALON, BARRA ESTRIBO C70\/C90 COMP                                                                   ',
          costo: '489.95'),
      Product(
          nombre: 'TVR BANDA FR AX',
          codigo: '54410-01005-000                ',
          descripcion:
              'TVR BANDA FRENO AX100 RACING                                                                         ',
          costo: '179.41'),
      Product(
          nombre: 'PIÑON ENC. JOG ',
          codigo: '3AA-15631-00                   ',
          descripcion:
              'TVR PIÑON ENC. JOG 50 3PCS                                                                           ',
          costo: '190.34'),
      Product(
          nombre: 'CATRE BAJO VERD',
          codigo: '52100-GK4-970A                 ',
          descripcion:
              'CATRE BAJO VERDE PQ-90 COMPL                                                                         ',
          costo: '1124.17'),
      Product(
          nombre: 'TVR CARB. PCUB ',
          codigo: '16100-GB6-00                   ',
          descripcion:
              'TVR CARB. PRES-CUB C90 COMP                                                                          ',
          costo: '1144.86'),
      Product(
          nombre: 'TAZA TIMON CG12',
          codigo: '53200-397-X100                 ',
          descripcion:
              'TVR TAZA TIMON CG125 JGO.                                                                            ',
          costo: '154.29'),
      Product(
          nombre: '167-25387-00   ',
          codigo: '167-25387-00                   ',
          descripcion:
              'EJE MANG. RS\/RX115 C\/TUERC                                                                           ',
          costo: '52.79'),
      Product(
          nombre: 'RB ARO 140X17  ',
          codigo: '140X17COMP RB                  ',
          descripcion:
              'R.B ARO 140 X 17 COMPLETO                                                                            ',
          costo: '1262.08'),
      Product(
          nombre: 'TVR BATERIA YTX',
          codigo: 'YTX5L-TVR                      ',
          descripcion: 'TVR BATERIA 110 GELATINA',
          costo: '1093.65'),
      Product(
          nombre: 'TVR ZOCALO     ',
          codigo: 'D-02757                        ',
          descripcion:
              'TVR ZOCALO DEL. C70  (10-PCS)                                                                        ',
          costo: '442.84'),
      Product(
          nombre: 'KIT PISTON CG12',
          codigo: '13101-383-000                  ',
          descripcion:
              'TVR KIT PISTON CG125\/YAM STD                                                                         ',
          costo: '456.17'),
      Product(
          nombre: 'JS-HS011-AZUL  ',
          codigo: 'HL-08 STEN C                   ',
          descripcion: ' +ESPIGA TIMON BMX MAGN.  AZUL',
          costo: '242.85'),
      Product(
          nombre: 'LAVE ALLEN     ',
          codigo: '1001-000249                    ',
          descripcion: 'R.B LEVA NORMAL CG150   ',
          costo: '162.3'),
      Product(
          nombre: 'CADENA CATAL   ',
          codigo: '43JD01-32366T                  ',
          descripcion:
              'CAD\/CAT 36\/15T CG125  J.T                                                                            ',
          costo: '446.87'),
      Product(
          nombre: 'RB CAT TRA 37T ',
          codigo: '41201-SKG-37T                  ',
          descripcion:
              'R.B CATAL. TRAS. 37T SKG110                                                                          ',
          costo: '343.74'),
      Product(
          nombre: 'CAMPO COMPLETO ',
          codigo: '31120-CG125                    ',
          descripcion:
              'TVR CAMPO 8-BOB CG125 COMPL                                                                          ',
          costo: '804.07'),
      Product(
          nombre: 'CATAL. TRAS. 37',
          codigo: '64511-23460-RE                 ',
          descripcion: 'CATAL. TRAS. 37T AX100  ',
          costo: '227.6'),
      Product(
          nombre: 'FAROL DIR. TRAS',
          codigo: '33600-GK4                      ',
          descripcion:
              'FAROL DIR. TRAS. PRESS-Q JA                                                                          ',
          costo: '111.62'),
      Product(
          nombre: 'FAROL DIR. TRAS',
          codigo: '33600-397-000T                 ',
          descripcion:
              'FAROL DIR. CG125  AMARILLO                                                                           ',
          costo: '64.13'),
      Product(
          nombre: 'FAROL DIR. CG  ',
          codigo: '33600-397-830                  ',
          descripcion:
              'TVR FAROL DIR.CG125 AMARILLO                                                                         ',
          costo: '110.05'),
      Product(
          nombre: 'FAROL STOP AX10',
          codigo: '35710-23430                    ',
          descripcion:
              'TVR FAROL STOP AX100 B\/ NIQUELADA                                                                    ',
          costo: '254.11'),
      Product(
          nombre: 'FAROL STOP AX10',
          codigo: '35710-23400                    ',
          descripcion: 'R.B FAROL STOP AX100    ',
          costo: '241.9'),
      Product(
          nombre: 'SEPARADOR DISCO',
          codigo: '01-00073                       ',
          descripcion:
              'TVR SEPARADOR D\/CLOCHE AX100 (5PCS)                                                                  ',
          costo: '168.41'),
      Product(
          nombre: 'JUNTA CULATA   ',
          codigo: '12251-SKG-000                  ',
          descripcion:
              'JUNTA CULATA SKG110 (10 UND)                                                                         ',
          costo: '200.25'),
      Product(
          nombre: 'RETEN. AX100   ',
          codigo: 'AX100-000                      ',
          descripcion:
              'TVR RETEN. AX100 JGO.6 PCS                                                                           ',
          costo: '110.49'),
      Product(
          nombre: 'FLAPER AX100   ',
          codigo: '13150-23400                    ',
          descripcion: 'FLAPER AX100 JA         ',
          costo: '96.58'),
    ];
  }
}
