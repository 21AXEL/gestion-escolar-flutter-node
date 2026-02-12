const express = require('express');
const cors = require('cors');
const ip = require('ip');

const app = express();
app.use(cors()); // Permite que Flutter se conecte
app.use(express.json()); // Permite recibir JSON

const PORT = 3000;

// --- BASE DE DATOS (En memoria) ---
// AQUÍ ESTÁ EL CAMBIO: Usamos enlaces estables (OpenLibrary y UI-Avatars)

// 2.a) Datos de LIBROS
let libros = [
    { 
        id: 1, 
        titulo: "El Principito", 
        autor: "Antoine de Saint-Exupéry", 
        imagen: "https://covers.openlibrary.org/b/id/8577413-L.jpg", 
        descripcion: "Un clásico de la literatura." 
    },
    { 
        id: 2, 
        titulo: "Clean Code", 
        autor: "Robert C. Martin", 
        imagen: "https://m.media-amazon.com/images/I/41xShlnTZTL._SX218_BO1,204,203,200_QL40_ML2_.jpg", 
        descripcion: "Manual de desarrollo ágil." 
    },
    { 
        id: 3, 
        titulo: "Harry Potter", 
        autor: "J.K. Rowling", 
        imagen: "https://covers.openlibrary.org/b/id/10522833-L.jpg", 
        descripcion: "El niño que vivió." 
    }
];
// 2.b) Datos de ESTUDIANTES
// Use "ui-avatars.com" que genera la foto con las iniciales del nombre automáticamente.
let estudiantes = [
    { 
        id: 1, 
        nombre: "Axel Angulo", 
        matricula: "A001", 
        imagen: "https://ui-avatars.com/api/?name=Axel+Angulo&background=0D8ABC&color=fff&size=150", 
        carrera: "Software" 
    },
    { 
        id: 2, 
        nombre: "Maria Perez", 
        matricula: "A002", 
        imagen: "https://ui-avatars.com/api/?name=Maria+Perez&background=random&size=150", 
        carrera: "Diseño" 
    },
    { 
        id: 3, 
        nombre: "Juan Silva", 
        matricula: "A003", 
        imagen: "https://ui-avatars.com/api/?name=Juan+Silva&background=random&size=150", 
        carrera: "Redes" 
    }
];

// --- ENDPOINTS (RUTAS) - ESTO SIGUE IGUAL ---

// RUTAS LIBROS
app.get('/api/libros', (req, res) => res.json(libros));

app.post('/api/libros', (req, res) => {
    const nuevo = { id: Date.now(), ...req.body };
    // Si no mandan imagen, ponemos una por defecto
    if (!nuevo.imagen) nuevo.imagen = "https://via.placeholder.com/150";
    libros.push(nuevo);
    res.json(nuevo);
});

app.put('/api/libros/:id', (req, res) => {
    const { id } = req.params;
    const index = libros.findIndex(l => l.id == id);
    if (index !== -1) {
        libros[index] = { ...libros[index], ...req.body };
        res.json(libros[index]);
    } else {
        res.status(404).json({ error: "No encontrado" });
    }
});

app.delete('/api/libros/:id', (req, res) => {
    const { id } = req.params;
    libros = libros.filter(l => l.id != id);
    res.json({ message: "Eliminado" });
});

// RUTAS ESTUDIANTES
app.get('/api/estudiantes', (req, res) => res.json(estudiantes));

app.post('/api/estudiantes', (req, res) => {
    const nuevo = { id: Date.now(), ...req.body };
    // Si no mandan imagen, generamos una con sus iniciales
    if (!nuevo.imagen) {
        nuevo.imagen = `https://ui-avatars.com/api/?name=${nuevo.nombre}&background=random`;
    }
    estudiantes.push(nuevo);
    res.json(nuevo);
});

app.put('/api/estudiantes/:id', (req, res) => {
    const { id } = req.params;
    const index = estudiantes.findIndex(e => e.id == id);
    if (index !== -1) {
        estudiantes[index] = { ...estudiantes[index], ...req.body };
        res.json(estudiantes[index]);
    } else {
        res.status(404).json({ error: "No encontrado" });
    }
});

app.delete('/api/estudiantes/:id', (req, res) => {
    const { id } = req.params;
    estudiantes = estudiantes.filter(e => e.id != id);
    res.json({ message: "Eliminado" });
});

// RUTA LOGIN
app.post('/api/login', (req, res) => {
    const { usuario, password } = req.body;
    if (usuario === "admin" && password === "1234") {
        res.json({ success: true, token: "ABC_TOKEN_123", usuario: "Administrador" });
    } else {
        res.status(401).json({ success: false, message: "Datos incorrectos" });
    }
});

// INICIAR
app.listen(PORT, '0.0.0.0', () => {
    console.log(`\n>>> SERVIDOR ENCENDIDO <<<`);
    console.log(`TU API ESTÁ EN: http://${ip.address()}:${PORT}/api/`);
    console.log(`Copia esa IP para usarla en Flutter.\n`);
}); 