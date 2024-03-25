import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class pantallaMapaMetro extends StatefulWidget {
  const pantallaMapaMetro({Key? key}) : super(key: key);

  @override
  _pantallaMetroState createState() => _pantallaMetroState();
}

class _pantallaMetroState extends State<pantallaMapaMetro> {
  @override
  void initState() {
    super.initState();
  }

  Future<String?> obtenerURLImagen() async {
    final obtenerImagenURLBD = await FirebaseFirestore.instance.collection('mapas').doc('metrocdmx').get();
    final urlImagen = obtenerImagenURLBD.data()?['mapaurl'];
    return urlImagen;
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
          title: const Text('Mapa del MetroCDMX'),
          backgroundColor: const Color.fromARGB(255, 254, 126, 27),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        body: FutureBuilder<String?>(
          future: obtenerURLImagen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al descargar la imagen.\n¡Asegurese de estar conectado a internet!'),
                );
              } else {
                String? urlImagen = snapshot.data;
                if (urlImagen != null) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(urlImagen),
                        //fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('La URL de la imagen no existe en la Base de Datos. ¡Favor de contactar al administrador de la aplicacion!'),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
