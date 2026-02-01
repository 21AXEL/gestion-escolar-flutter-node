import 'package:flutter/material.dart';

class LibroDetailScreen extends StatelessWidget {
  final Map<String, dynamic> libro;

  const LibroDetailScreen({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro['titulo']),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Imagen en grande
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                image: DecorationImage(
                  image: NetworkImage(libro['imagen']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Título y Autor
            Text(
              libro['titulo'],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Autor: ${libro['autor']}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.indigo,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Divider(height: 30),

            // 3. LA DESCRIPCIÓN (El detalle que faltaba)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sinopsis:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              libro['descripcion'] ??
                  "No hay descripción disponible para este libro.",
              style: const TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
