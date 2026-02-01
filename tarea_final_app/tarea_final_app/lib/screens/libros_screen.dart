import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'libro_form_screen.dart';
import 'libro_detail_screen.dart'; // <--- IMPORTANTE: Importamos la pantalla de detalle

class LibrosScreen extends StatefulWidget {
  const LibrosScreen({super.key});

  @override
  State<LibrosScreen> createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  List<dynamic> libros = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    var resultado = await ApiService.getLibros();
    setState(() {
      libros = resultado;
      cargando = false;
    });
  }

  // Función para borrar
  void _borrarLibro(int id) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Eliminar"),
            content: const Text("¿Seguro que deseas eliminar este libro?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await ApiService.deleteLibro(id);
      cargarDatos(); // Recargar la lista
    }
  }

  // Navegar al formulario (Crear o Editar)
  void _irAFormulario({Map<String, dynamic>? libro}) async {
    bool? recargar = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LibroFormScreen(libro: libro)),
    );
    if (recargar == true) {
      cargarDatos(); // Si guardamos algo, recargamos la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Libros"),
        backgroundColor: Colors.indigo,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: libros.length,
              itemBuilder: (context, index) {
                final libro = libros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    // --- NUEVO: AL TOCAR EL LIBRO, ABRE EL DETALLE ---
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LibroDetailScreen(libro: libro),
                        ),
                      );
                    },
                    // -------------------------------------------------
                    leading: Image.network(
                      libro['imagen'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => const Icon(
                        Icons.book,
                        size: 40,
                        color: Colors.indigo,
                      ),
                    ),
                    title: Text(
                      libro['titulo'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(libro['autor']),

                    // BOTONES DE ACCIÓN (Editar / Borrar)
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _irAFormulario(libro: libro),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _borrarLibro(libro['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _irAFormulario(), // Crear Nuevo
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
