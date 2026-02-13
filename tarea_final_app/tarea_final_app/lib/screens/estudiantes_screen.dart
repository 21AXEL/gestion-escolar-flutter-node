import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'estudiante_form_screen.dart';
import 'estudiante_detail_screen.dart';

class EstudiantesScreen extends StatefulWidget {
  const EstudiantesScreen({super.key});

  @override
  State<EstudiantesScreen> createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  // DOS LISTAS: Una guarda todo, la otra es la que se muestra
  List<dynamic> estudiantesCompleto = [];
  List<dynamic> estudiantesFiltrados = [];

  bool cargando = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    var resultado = await ApiService.getEstudiantes();
    setState(() {
      estudiantesCompleto = resultado;
      estudiantesFiltrados = resultado; // Al inicio, mostramos todos
      cargando = false;
    });
  }

  // --- LÓGICA DEL BUSCADOR ---
  void _filtrarBusqueda(String texto) {
    setState(() {
      if (texto.isEmpty) {
        estudiantesFiltrados = estudiantesCompleto;
      } else {
        estudiantesFiltrados = estudiantesCompleto
            .where(
              (est) => est['nombre'].toString().toLowerCase().contains(
                texto.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  // CAMBIO 1: El ID ahora es String (porque viene de MongoDB)
  void _borrar(String id) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Eliminar"),
            content: const Text("¿Eliminar estudiante?"),
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
      await ApiService.deleteEstudiante(id);
      cargarDatos();
    }
  }

  void _irAFormulario({Map<String, dynamic>? estudiante}) async {
    bool? recargar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EstudianteFormScreen(estudiante: estudiante),
      ),
    );
    if (recargar == true) cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Estudiantes"),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // --- BARRA DE BÚSQUEDA ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: _filtrarBusqueda,
              decoration: InputDecoration(
                labelText: "Buscar estudiante...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // --- LISTA ---
          Expanded(
            child: cargando
                ? const Center(child: CircularProgressIndicator())
                : estudiantesFiltrados.isEmpty
                ? const Center(child: Text("No se encontraron resultados"))
                : ListView.builder(
                    itemCount: estudiantesFiltrados.length,
                    itemBuilder: (context, index) {
                      final est = estudiantesFiltrados[index];
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
                                    EstudianteDetailScreen(estudiante: est),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            backgroundImage: NetworkImage(est['imagen']),
                            onBackgroundImageError: (_, __) {},
                            child:
                                est['imagen'] == "" ||
                                    est['imagen'].contains("placeholder")
                                ? const Icon(Icons.person, color: Colors.indigo)
                                : null,
                          ),
                          title: Text(
                            est['nombre'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${est['carrera']} - ${est['matricula']}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _irAFormulario(estudiante: est),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                // CAMBIO 2: Usamos '_id' en lugar de 'id'
                                onPressed: () => _borrar(est['_id']),
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
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
