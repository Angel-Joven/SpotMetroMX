import 'package:flutter/material.dart';

class inicioBienvenida extends StatefulWidget {
  const inicioBienvenida({Key? key}) : super(key: key);

  @override
  _inicioBienvenidaState createState() => _inicioBienvenidaState();
}

class _inicioBienvenidaState extends State<inicioBienvenida> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        backgroundColor: const Color.fromARGB(255, 254, 126, 27),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text(
                '¡Gracias por usar nuestra aplicación!\nPor favor, selecciona una opción del menú inferior.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
