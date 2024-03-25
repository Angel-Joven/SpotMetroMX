import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mostrarImagenVentana extends StatelessWidget {
  final String rutaImagenBD;

  mostrarImagenVentana({required this.rutaImagenBD});

  final Map<String, String> esquemasLineaMapa = {
    //Lo que devuelve rutaImagenBD                Si es igual a lo que hay aqui, entonces si hay esquema
    'assets/metrocdmx/esquemasLineas/linea1.png': 'assets/metrocdmx/esquemasLineas/linea1.png',
    'assets/metrocdmx/esquemasLineas/linea2.png': 'assets/metrocdmx/esquemasLineas/linea2.png',
    'assets/metrocdmx/esquemasLineas/linea3.png': 'assets/metrocdmx/esquemasLineas/linea3.png',
    'assets/metrocdmx/esquemasLineas/linea4.png': 'assets/metrocdmx/esquemasLineas/linea4.png',
    'assets/metrocdmx/esquemasLineas/linea5.png': 'assets/metrocdmx/esquemasLineas/linea5.png',
    'assets/metrocdmx/esquemasLineas/linea6.png': 'assets/metrocdmx/esquemasLineas/linea6.png',
    'assets/metrocdmx/esquemasLineas/linea7.png': 'assets/metrocdmx/esquemasLineas/linea7.png',
    'assets/metrocdmx/esquemasLineas/linea8.png': 'assets/metrocdmx/esquemasLineas/linea8.png',
    'assets/metrocdmx/esquemasLineas/linea9.png': 'assets/metrocdmx/esquemasLineas/linea9.png',
    'assets/metrocdmx/esquemasLineas/linea12.png': 'assets/metrocdmx/esquemasLineas/linea12.png',
    'assets/metrocdmx/esquemasLineas/lineaa.png': 'assets/metrocdmx/esquemasLineas/lineaA.png',
    'assets/metrocdmx/esquemasLineas/lineab.png': 'assets/metrocdmx/esquemasLineas/lineaB.png',
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.transparent,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                //rutaImagenBD,
                esquemasLineaMapa[rutaImagenBD] ?? 'assets/metrocdmx/esquemasLineas/placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class pantallaAcercaDe extends StatefulWidget {
  const pantallaAcercaDe({Key? key}) : super(key: key);

  @override
  _pantallaAcercaDeState createState() => _pantallaAcercaDeState();
}

class _pantallaAcercaDeState extends State<pantallaAcercaDe> {
  late Future<QuerySnapshot> infoLineasFuture;
  late Future<DocumentSnapshot> textoMasInfoFuture;

  @override
  void initState() {
    super.initState();
    infoLineasFuture = obtenerInfoLineas();
    textoMasInfoFuture = obtenerMasInfoTexto();
  }

  Future<QuerySnapshot> obtenerInfoLineas() async {
    return FirebaseFirestore.instance.collection('lineasInfo').get();
  }

  Future<DocumentSnapshot> obtenerMasInfoTexto() async {
    final masInfoObtenida = await FirebaseFirestore.instance.collection('masInfoSpotMetroMX').doc('informacion').get();
    return masInfoObtenida;
  }

  final Map<String, String> asignarImagenLineaMap = {
    'Linea 1': 'assets/metrocdmx/iconosLinea/linea1.png',
    'Linea 2': 'assets/metrocdmx/iconosLinea/linea2.png',
    'Linea 3': 'assets/metrocdmx/iconosLinea/linea3.png',
    'Linea 4': 'assets/metrocdmx/iconosLinea/linea4.png',
    'Linea 5': 'assets/metrocdmx/iconosLinea/linea5.png',
    'Linea 6': 'assets/metrocdmx/iconosLinea/linea6.png',
    'Linea 7': 'assets/metrocdmx/iconosLinea/linea7.png',
    'Linea 8': 'assets/metrocdmx/iconosLinea/linea8.png',
    'Linea 9': 'assets/metrocdmx/iconosLinea/linea9.png',
    'Linea 12': 'assets/metrocdmx/iconosLinea/linea12.png',
    'Linea A': 'assets/metrocdmx/iconosLinea/lineaA.png',
    'Linea B': 'assets/metrocdmx/iconosLinea/lineaB.png',
  };

  @override
  Widget build(BuildContext context) {
    //Lista de lineas de METRO existentes
    List<String> numeroLineasMetro = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '12', '999', 'A', 'B'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del MetroCDMX'),
        backgroundColor: const Color.fromARGB(255, 254, 126, 27),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: obtenerMasInfoTexto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}\n¡Asegurese de estar conectado a internet!\nSi el problema persiste, ¡Contacte al administrador de la aplicacion!'),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Error al descargar los datos.\n¡Asegurese de estar conectado a internet!'),
                  );
                }
                if (snapshot.data == null) {
                  return Center(
                    child: Text('La informacion no existe en la Base de Datos.\n¡Favor de contactar al administrador de la aplicacion!'),
                  );
                }
                //Textos de Mas Informacion
                final datosMasInfoBD = snapshot.data as DocumentSnapshot;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      datosMasInfoBD['tituloHorarioServicio'].replaceAll(r'\n', '\n'),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      datosMasInfoBD['horarioServicio'].replaceAll(r'\n', '\n'),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      datosMasInfoBD['tituloComoAccederEstaciones'].replaceAll(r'\n', '\n'),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      datosMasInfoBD['comoAccederEstaciones'].replaceAll(r'\n', '\n').replaceAll(r'\$', '\$'),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      datosMasInfoBD['tituloLineasRed'].replaceAll(r'\n', '\n'),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            //Tabla de lineas de METRO existentes
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('lineasInfo').get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}\n¡Asegurese de estar conectado a internet!\nSi el problema persiste, ¡Contacte al administrador de la aplicacion!'),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Error al descargar los datos.\n¡Asegurese de estar conectado a internet!'),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('La informacion no existe en la Base de Datos.\n¡Favor de contactar al administrador de la aplicacion!'),
                  );
                }
                final obtenerLineasMetroBD = snapshot.data!.docs;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 10.0,
                      dataRowHeight: 120,
                      columns: const [
                        DataColumn(
                            label: Text('Icono\nde la línea',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Línea\nde Metro',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Ruta',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Notas',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        for (String numeroLinea in numeroLineasMetro)...obtenerLineasMetroBD.where((obtenerLineasMetroBD) => obtenerLineasMetroBD.id == 'linea$numeroLinea').map((obtenerLineasMetroBD) {
                          print(numeroLinea);
                          final datosObtenidosLineasMetroBD = obtenerLineasMetroBD.data() as Map<String, dynamic>;
                          print(datosObtenidosLineasMetroBD);
                          return DataRow(cells: [
                            DataCell(
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return mostrarImagenVentana(
                                        rutaImagenBD: 'assets/metrocdmx/esquemasLineas/${datosObtenidosLineasMetroBD['lineaMetro'].replaceAll(' ', '').toLowerCase()}.png',
                                      );
                                    },
                                  );
                                },
                                child: Image.asset(
                                  asignarImagenLineaMap[datosObtenidosLineasMetroBD['lineaMetro']] ?? 'assets/metrocdmx/placeholder.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                            DataCell(Text(datosObtenidosLineasMetroBD['lineaMetro'])),
                            DataCell(Text(datosObtenidosLineasMetroBD['ruta'].replaceAll(r'\n', '\n'))),
                            DataCell(Text(datosObtenidosLineasMetroBD['notas'].replaceAll(r'\n', '\n'))),
                          ]);
                        }),
                      ],
                    ),
                  ),
                );
              },
            )],
        ),
      ),
    );
  }
}
