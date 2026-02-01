import 'package:flutter/material.dart';

class EstudianteDetailScreen extends StatelessWidget {
  final Map<String, dynamic> estudiante;

  const EstudianteDetailScreen({super.key, required this.estudiante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil del Estudiante"),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. FOTO GRANDE (Avatar)
              CircleAvatar(
                radius: 80, // Tamaño grande
                backgroundColor: Colors.indigo.shade100,
                backgroundImage: NetworkImage(estudiante['imagen']),
                onBackgroundImageError: (_, __) {},
                child: estudiante['imagen'] == ""
                    ? const Icon(Icons.person, size: 80, color: Colors.indigo)
                    : null,
              ),
              const SizedBox(height: 30),

              // 2. TARJETA DE DATOS
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _crearDato(
                        "Nombre Completo",
                        estudiante['nombre'],
                        Icons.person,
                      ),
                      const Divider(),
                      _crearDato(
                        "Matrícula / ID",
                        estudiante['matricula'],
                        Icons.badge,
                      ),
                      const Divider(),
                      _crearDato(
                        "Carrera",
                        estudiante['carrera'],
                        Icons.school,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para no repetir código
  Widget _crearDato(String etiqueta, String valor, IconData icono) {
    return ListTile(
      leading: Icon(icono, color: Colors.indigo, size: 30),
      title: Text(
        etiqueta,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      subtitle: Text(
        valor,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
