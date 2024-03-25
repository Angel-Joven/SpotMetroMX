import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

class pantallaCreditos extends StatefulWidget {
  const pantallaCreditos({Key? key}) : super(key: key);

  @override
  _pantallaCreditosState createState() => _pantallaCreditosState();
}

class _pantallaCreditosState extends State<pantallaCreditos> {
  late Future<DocumentSnapshot> infoCreditosFuture;

  @override
  void initState() {
    super.initState();
    infoCreditosFuture = obtenerInfoCreditosBD();
  }

  Future<DocumentSnapshot> obtenerInfoCreditosBD() async {
    final InfoObtenidaCreditosBD = await FirebaseFirestore.instance.collection('creditosSpotMetroMX').doc('informacion').get();
    return InfoObtenidaCreditosBD;
  }

  // Para PC
  void abrirCodigoFuentePC(String url) async {
    const url = 'https://github.com/Angel-Joven/SpotMetroMX'; // Reemplaza con tu URL de GitHub
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  // Para ANDROID
  void abrirCodigoFuenteAndroid(String url) {
    String url = 'https://github.com/Angel-Joven/SpotMetroMX';
    AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: url,
    );
    intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotMetro MX',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 254, 126, 27),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Creditos'),
          backgroundColor: const Color.fromARGB(255, 254, 126, 27),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        body: FutureBuilder(
          future: obtenerInfoCreditosBD(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al obtener la imagen'),
                );
              } else {
                final datosInfoCreditos = snapshot.data as DocumentSnapshot;
                String resumen = datosInfoCreditos['resumen'].replaceAll(r'\n', '\n');
                String tituloPersonas = datosInfoCreditos['tituloPersonas'].replaceAll(r'\n', '\n');
                String listaPersonas = datosInfoCreditos['listaPersonas'].replaceAll(r'\n', '\n');
                String tituloElementosVisuales = datosInfoCreditos['tituloElementosVisuales'].replaceAll(r'\n', '\n');
                String elementosVisuales = datosInfoCreditos['elementosVisuales'].replaceAll(r'\n', '\n');
                String tituloCodigoFuente = datosInfoCreditos['tituloCodigoFuente'].replaceAll(r'\n', '\n');
                String codigoFuenteText = datosInfoCreditos['codigoFuenteText'].replaceAll(r'\n', '\n');
                if (datosInfoCreditos != null) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datosInfoCreditos['tituloResumen'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            resumen,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            tituloPersonas,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            listaPersonas,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            tituloElementosVisuales,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            elementosVisuales,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            tituloCodigoFuente,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            codigoFuenteText,
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                abrirCodigoFuentePC(datosInfoCreditos['codigoFuenteURL']); //PARA PC
                                abrirCodigoFuenteAndroid(datosInfoCreditos['codigoFuenteURL']); //PARA ANDROID
                              },
                              child: Text('Ver Codigo Fuente'),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('La informacion no existe en la Base de Datos. ¡Favor de contactar al administrador de la aplicacion!'),
                  );
                }
              }
            }
          },
        ),
      )
    );
  }
}
