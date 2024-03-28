import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'vistas/menuPrincipal.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SpotMetro MX',
      home: pantallaInicio(),
    );
  }
}

class pantallaInicio extends StatefulWidget {
  const pantallaInicio({Key? key}) : super(key: key);
  @override
  _pantallaInicioState createState() => _pantallaInicioState();
}

class _pantallaInicioState extends State<pantallaInicio> with SingleTickerProviderStateMixin {
  late AnimationController _controlarAnimacion;

  @override
  void initState() {
    super.initState();
    _controlarAnimacion = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _navigateAfterDelay();
  }

  @override
  void liberarRecursos() {
    _controlarAnimacion.dispose();
    super.dispose();
  }

  Future<Position> obtenerUbicacion() async {
    bool servicioOn;
    LocationPermission permiso;

    servicioOn = await Geolocator.isLocationServiceEnabled();
    if (!servicioOn) {
      return Future.error('Servicio de ubicacion deshabilitado');
    }
    permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return Future.error('El permiso fue denegado');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      Future.error(
          'Los servicios de ubicacion estan denegados de forma permantente');
    }
    return Geolocator.getCurrentPosition();
  }

  Future<void> _navigateAfterDelay() async {
    obtenerUbicacion();
    //Tiempo que se queda la imagen en la pantalla
    await Future.delayed(const Duration(seconds: 5));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const menuPrincipal(), // Redirige al widget deseado
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(
            CurvedAnimation(
              parent: _controlarAnimacion,
              curve: Curves.easeOut,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width, // Ancho de la pantalla
            height: MediaQuery.of(context).size.height, // Altura de la pantalla
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 254, 126, 27),
              image: DecorationImage(
                image: AssetImage('assets/metrocdmx/placeholder5.png'),
                //fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
