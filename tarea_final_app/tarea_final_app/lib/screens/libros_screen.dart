import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'libro_form_screen.dart';
import 'libro_detail_screen.dart'; // Asegúrate de importar la pantalla de detalle

class LibrosScreen extends StatefulWidget {
  const LibrosScreen({super.key});

  @override
  State<LibrosScreen> createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  // 1. DOS LISTAS: Una de respaldo (completa) y otra para mostrar (filtrada)
  List<dynamic> librosCompleto = [];
  List<dynamic> librosFiltrados = [];

  bool cargando = true;
  TextEditingController searchController =
      TextEditingController(); // Controlador del buscador

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    var resultado = await ApiService.getLibros();
    setState(() {
      librosCompleto = resultado;
      librosFiltrados = resultado; // Al principio mostramos todo
      cargando = false;
    });
  }

  // 2. LÓGICA DEL BUSCADOR (Filtrado)
  void _filtrarBusqueda(String texto) {
    setState(() {
      if (texto.isEmpty) {
        // Si borran el texto, restauramos la lista completa
        librosFiltrados = librosCompleto;
      } else {
        // Filtramos si el TÍTULO o el AUTOR contienen el texto
        librosFiltrados = librosCompleto.where((libro) {
          final titulo = libro['titulo'].toString().toLowerCase();
          final autor = libro['autor'].toString().toLowerCase();
          final busqueda = texto.toLowerCase();

          return titulo.contains(busqueda) || autor.contains(busqueda);
        }).toList();
      }
    });
  }

  void _borrar(int id) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Eliminar"),
            content: const Text("¿Eliminar este libro?"),
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
      cargarDatos();
    }
  }

  void _irAFormulario({Map<String, dynamic>? libro}) async {
    bool? recargar = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LibroFormScreen(libro: libro)),
    );
    if (recargar == true) cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Libros"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // 3. BARRA DE BÚSQUEDA
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: _filtrarBusqueda, // Cada letra que escribas, filtra
              decoration: InputDecoration(
                labelText: "Buscar por título o autor...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // 4. LISTA (Usando librosFiltrados)
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : librosFiltrados.isEmpty
                ? const Center(child: Text("No se encontraron libros"))
                : ListView.builder(
                    itemCount: librosFiltrados.length,
                    itemBuilder: (context, index) {
                      final libro = librosFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LibroDetailScreen(libro: libro),
                              ),
                            );
                          },
                          leading: Image.network(
                            libro['imagen'],
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.book,
                                  size: 50,
                                  color: Colors.indigo,
                                ),
                          ),
                          title: Text(
                            libro['titulo'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(libro['autor']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _irAFormulario(libro: libro),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _borrar(libro['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _irAFormulario(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
