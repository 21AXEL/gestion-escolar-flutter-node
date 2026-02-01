import 'package:flutter/material.dart';
import 'libros_screen.dart'; // Importamos pantalla libros
import 'estudiantes_screen.dart'; // Importamos pantalla estudiantes
import 'login_screen.dart'; // Importamos login para cerrar sesión

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú Principal"),
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Administrador"),
              accountEmail: Text("admin@puce.edu.ec"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              decoration: BoxDecoration(color: Colors.indigo),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Gestión de Libros"),
              onTap: () {
                Navigator.pop(context); // Cierra el menú lateral
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LibrosScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Gestión de Estudiantes"),
              onTap: () {
                Navigator.pop(context); // Cierra el menú lateral
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EstudiantesScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text("Cerrar Sesión"),
              onTap: () {
                // Regresar al Login y borrar historial
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.dashboard, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              "Seleccione una opción del menú",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
