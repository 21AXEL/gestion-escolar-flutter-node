const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose'); // Importamos Mongoose
const ip = require('ip');
const multer = require('multer'); // Multer para gestión de archivos
const path = require('path');     // Para manejar rutas de carpetas

const app = express();
app.use(cors()); // Permite que Flutter se conecte
app.use(express.json()); // Permite recibir JSON

// ACTUALIZACIÓN: Hacemos pública la carpeta 'uploads' con permisos CORS para la Web
app.use('/uploads', express.static(path.join(__dirname, 'uploads'), {
    setHeaders: (res) => {
        res.set('Access-Control-Allow-Origin', '*'); // Esto permite que Chrome vea las fotos
    }
}));

const PORT = 3000;

// --- 1. CONEXIÓN A MONGODB --- 
mongoose.connect('mongodb://127.0.0.1:27017/sistema_escolar')
    .then(() => console.log('>>> CONECTADO A MONGODB EXITOSAMENTE <<<'))
    .catch(err => console.error('Error conectando a MongoDB:', err));

// --- 2. DEFINICIÓN DE ESQUEMAS (Modelos) ---

const LibroSchema = new mongoose.Schema({
    titulo: String,
    autor: String,
    imagen: String,
    descripcion: String
});
const Libro = mongoose.model('Libro', LibroSchema);

const EstudianteSchema = new mongoose.Schema({
    nombre: String,
    matricula: String,
    carrera: String,
    imagen: String
});
const Estudiante = mongoose.model('Estudiante', EstudianteSchema);


// --- CONFIGURACIÓN MULTER ---
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // Las imágenes van a la carpeta 'uploads'
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
const upload = multer({ storage: storage });


// --- 3. ENDPOINTS (RUTAS) ---

// === RUTAS LIBROS ===

app.get('/api/libros', async (req, res) => {
    try {
        const libros = await Libro.find();
        res.json(libros);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST HÍBRIDO (Crear)
app.post('/api/libros', upload.single('imagen'), async (req, res) => {
    try {
        const datos = req.body;
        if (req.file) {
            datos.imagen = `http://${ip.address()}:${PORT}/uploads/${req.file.filename}`;
        } else if (!datos.imagen) {
            datos.imagen = "https://via.placeholder.com/150";
        }
        
        const nuevoLibro = new Libro(datos);
        await nuevoLibro.save();
        res.json(nuevoLibro);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// PUT HÍBRIDO (Editar) - ACTUALIZADO
app.put('/api/libros/:id', upload.single('imagen'), async (req, res) => {
    try {
        const datos = req.body;
        if (req.file) {
            datos.imagen = `http://${ip.address()}:${PORT}/uploads/${req.file.filename}`;
        }
        const libroActualizado = await Libro.findByIdAndUpdate(req.params.id, datos, { new: true });
        res.json(libroActualizado);
    } catch (error) {
        res.status(500).json({ error: "Error al actualizar o ID no válido" });
    }
});

app.delete('/api/libros/:id', async (req, res) => {
    try {
        await Libro.findByIdAndDelete(req.params.id);
        res.json({ message: "Libro eliminado correctamente" });
    } catch (error) {
        res.status(500).json({ error: "Error al eliminar" });
    }
});


// === RUTAS ESTUDIANTES ===

app.get('/api/estudiantes', async (req, res) => {
    try {
        const estudiantes = await Estudiante.find();
        res.json(estudiantes);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST HÍBRIDO (Crear)
app.post('/api/estudiantes', upload.single('imagen'), async (req, res) => {
    try {
        const datos = req.body;
        if (req.file) {
            datos.imagen = `http://${ip.address()}:${PORT}/uploads/${req.file.filename}`;
        } else if (!datos.imagen) {
            datos.imagen = `https://ui-avatars.com/api/?name=${datos.nombre}&background=random&size=150`;
        }
        
        const nuevoEstudiante = new Estudiante(datos);
        await nuevoEstudiante.save();
        res.json(nuevoEstudiante);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// PUT HÍBRIDO (Editar) - ACTUALIZADO
app.put('/api/estudiantes/:id', upload.single('imagen'), async (req, res) => {
    try {
        const datos = req.body;
        if (req.file) {
            datos.imagen = `http://${ip.address()}:${PORT}/uploads/${req.file.filename}`;
        }
        const estudianteActualizado = await Estudiante.findByIdAndUpdate(req.params.id, datos, { new: true });
        res.json(estudianteActualizado);
    } catch (error) {
        res.status(500).json({ error: "Error al actualizar" });
    }
});

app.delete('/api/estudiantes/:id', async (req, res) => {
    try {
        await Estudiante.findByIdAndDelete(req.params.id);
        res.json({ message: "Estudiante eliminado correctamente" });
    } catch (error) {
        res.status(500).json({ error: "Error al eliminar" });
    }
});


// === RUTA LOGIN ===
app.post('/api/login', (req, res) => {
    const { usuario, password } = req.body;
    if (usuario === "admin" && password === "1234") {
        res.json({ success: true, token: "ABC_TOKEN_MONGODB", usuario: "Administrador" });
    } else {
        res.status(401).json({ success: false, message: "Datos incorrectos" });
    }
});


// --- INICIAR SERVIDOR ---
app.listen(PORT, '0.0.0.0', async () => {
    console.log(`\n>>> SERVIDOR ENCENDIDO (SISTEMA HÍBRIDO TOTAL) <<<`);
    console.log(`TU API ESTÁ EN: http://${ip.address()}:${PORT}/api/`);
    
    const cuenta = await Libro.countDocuments();
    if (cuenta === 0) {
        console.log("Base de datos vacía. Insertando datos de prueba...");
        await Libro.create({ 
            titulo: "El Principito", 
            autor: "Antoine de Saint-Exupéry", 
            imagen: "https://covers.openlibrary.org/b/id/8577413-L.jpg", 
            descripcion: "Un clásico." 
        });
        await Estudiante.create({ 
            nombre: "Axel Angulo", 
            matricula: "A001", 
            carrera: "Software", 
            imagen: "https://ui-avatars.com/api/?name=Axel+Angulo&background=0D8ABC&color=fff&size=150" 
        });
        console.log("¡Datos de prueba insertados!");
    }
});