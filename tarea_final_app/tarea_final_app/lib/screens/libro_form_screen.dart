import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LibroFormScreen extends StatefulWidget {
  final Map<String, dynamic>?
  libro; // Si es null, es CREAR. Si tiene datos, es EDITAR.

  const LibroFormScreen({super.key, this.libro});

  @override
  State<LibroFormScreen> createState() => _LibroFormScreenState();
}

class _LibroFormScreenState extends State<LibroFormScreen> {
  final _tituloCtrl = TextEditingController();
  final _autorCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si venimos a EDITAR, llenamos los campos
    if (widget.libro != null) {
      _tituloCtrl.text = widget.libro!['titulo'];
      _autorCtrl.text = widget.libro!['autor'];
      _imgCtrl.text = widget.libro!['imagen'];
    }
  }

  void _guardar() async {
    final data = {
      "titulo": _tituloCtrl.text,
      "autor": _autorCtrl.text,
      "imagen": _imgCtrl.text.isNotEmpty
          ? _imgCtrl.text
          : "https://via.placeholder.com/150", // Imagen por defecto
      "descripcion": "Descripción genérica",
    };

    bool exito;
    if (widget.libro == null) {
      // MODO CREAR
      exito = await ApiService.addLibro(data);
    } else {
      // MODO EDITAR
      exito = await ApiService.updateLibro(widget.libro!['id'], data);
    }

    if (exito && mounted) {
      Navigator.pop(
        context,
        true,
      ); // Regresamos y decimos que "sí" hubo cambios
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al guardar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.libro != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? "Editar Libro" : "Nuevo Libro"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: _autorCtrl,
              decoration: const InputDecoration(labelText: "Autor"),
            ),
            TextField(
              controller: _imgCtrl,
              decoration: const InputDecoration(
                labelText: "URL de Imagen (Opcional)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: const Text("GUARDAR"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
