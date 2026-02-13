import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class EstudianteFormScreen extends StatefulWidget {
  final Map<String, dynamic>? estudiante;
  const EstudianteFormScreen({super.key, this.estudiante});
  @override
  State<EstudianteFormScreen> createState() => _EstudianteFormScreenState();
}

class _EstudianteFormScreenState extends State<EstudianteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _matriculaCtrl = TextEditingController();
  final _carreraCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _imgExistente;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.estudiante != null) {
      _nombreCtrl.text = widget.estudiante!['nombre'];
      _matriculaCtrl.text = widget.estudiante!['matricula'];
      _carreraCtrl.text = widget.estudiante!['carrera'];
      _imgExistente = widget.estudiante!['imagen'];
      if (_imgExistente != null && _imgExistente!.startsWith('http'))
        _urlCtrl.text = _imgExistente!;
    }
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final Map<String, String> data = {
      "nombre": _nombreCtrl.text,
      "matricula": _matriculaCtrl.text,
      "carrera": _carreraCtrl.text,
      "imagen": _urlCtrl.text,
    };
    bool ok = widget.estudiante == null
        ? await ApiService.addEstudiante(data, _imageFile)
        : await ApiService.updateEstudiante(
            widget.estudiante!['_id'],
            data,
            _imageFile,
          );
    setState(() => _isLoading = false);
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.estudiante == null ? "Nuevo Estudiante" : "Editar Estudiante",
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final xFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (xFile != null)
                    setState(() => _imageFile = File(xFile.path));
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.indigo[50],
                  backgroundImage: _obtenerPreview(),
                  child:
                      (_imageFile == null &&
                          _urlCtrl.text.isEmpty &&
                          _imgExistente == null)
                      ? const Icon(Icons.camera, color: Colors.indigo)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _urlCtrl,
                decoration: const InputDecoration(
                  labelText: "URL de la Foto (PC)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Obligatorio" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _matriculaCtrl,
                decoration: const InputDecoration(
                  labelText: "Matrícula",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Obligatorio" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _carreraCtrl,
                decoration: const InputDecoration(
                  labelText: "Carrera",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _guardar,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("GUARDAR"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _obtenerPreview() {
    if (_imageFile != null) return FileImage(_imageFile!);
    if (_urlCtrl.text.isNotEmpty) return NetworkImage(_urlCtrl.text);
    if (_imgExistente != null) return NetworkImage(_imgExistente!);
    return null;
  }
}
