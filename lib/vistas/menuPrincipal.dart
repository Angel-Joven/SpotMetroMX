import 'package:flutter/material.dart';
import 'bienvenida.dart';
import 'ubicarEstaciones.dart';
import 'mapaMetro.dart';
import 'acercaDe.dart';
import 'mostrarCreditos.dart';

class menuPrincipal extends StatefulWidget {
  const menuPrincipal({super.key});

  @override
  State<menuPrincipal> createState() => _menuPrincipalState();
}

class _menuPrincipalState extends State<menuPrincipal> {
  int _indexSeleccionado = 0;

  static final List<Widget> _pagesOptions = <Widget>[
    const inicioBienvenida(),
    const EstacionesCercanas(),
    const pantallaMapaMetro(),
    const pantallaAcercaDe(),
    const pantallaCreditos()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _indexSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotMetro MX',
      theme: ThemeData(
        colorSchemeSeed: Color.fromARGB(255, 255, 77, 0),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      routes: {
        '/bienvenida': (context) => const inicioBienvenida(),
        '/ubicarEstaciones': (context) => const EstacionesCercanas(),
        '/mapaMetro': (context) => const pantallaMapaMetro(),
        '/acercaDe': (context) => const pantallaAcercaDe(),
        '/mostrarCreditos': (context) => const pantallaCreditos()
      },
      home: Scaffold(
        body: _pagesOptions.elementAt(_indexSeleccionado),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Bienvenida'),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: '    Ubicar\nestaciones\n  cercanas'),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '     Mapa\nMetroCDMX\n'),
            BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: '      Mas\ninformacion\n'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Creditos')
          ],
          currentIndex: _indexSeleccionado,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
