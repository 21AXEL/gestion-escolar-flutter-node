import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EstudianteFormScreen extends StatefulWidget {
  final Map<String, dynamic>? estudiante; // Si es null = Crear nuevo

  const EstudianteFormScreen({super.key, this.estudiante});

  @override
  State<EstudianteFormScreen> createState() => _EstudianteFormScreenState();
}

class _EstudianteFormScreenState extends State<EstudianteFormScreen> {
  final _nombreCtrl = TextEditingController();
  final _matriculaCtrl = TextEditingController();
  final _carreraCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.estudiante != null) {
      _nombreCtrl.text = widget.estudiante!['nombre'];
      _matriculaCtrl.text = widget.estudiante!['matricula'];
      _carreraCtrl.text = widget.estudiante!['carrera'];
      _imgCtrl.text = widget.estudiante!['imagen'];
    }
  }

  void _guardar() async {
    final data = {
      "nombre": _nombreCtrl.text,
      "matricula": _matriculaCtrl.text,
      "carrera": _carreraCtrl.text,
      "imagen": _imgCtrl.text.isNotEmpty
          ? _imgCtrl.text
          : "https://via.placeholder.com/150",
    };

    bool exito;
    if (widget.estudiante == null) {
      exito = await ApiService.addEstudiante(data);
    } else {
      exito = await ApiService.updateEstudiante(widget.estudiante!['id'], data);
    }

    if (exito && mounted) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al guardar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.estudiante == null ? "Nuevo Estudiante" : "Editar Estudiante",
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre Completo"),
            ),
            TextField(
              controller: _matriculaCtrl,
              decoration: const InputDecoration(labelText: "Matrícula / ID"),
            ),
            TextField(
              controller: _carreraCtrl,
              decoration: const InputDecoration(labelText: "Carrera"),
            ),
            TextField(
              controller: _imgCtrl,
              decoration: const InputDecoration(
                labelText: "URL Foto (Opcional)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: const Text("GUARDAR ESTUDIANTE"),
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
