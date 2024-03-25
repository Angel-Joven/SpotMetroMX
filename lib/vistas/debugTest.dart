import 'package:flutter/material.dart';

class pantallaDebug extends StatelessWidget {
  final String textoDebug;

  const pantallaDebug({Key? key, required this.textoDebug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(textoDebug),
      ),
    );
  }
}
