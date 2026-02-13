import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class LibroFormScreen extends StatefulWidget {
  final Map<String, dynamic>? libro;
  const LibroFormScreen({super.key, this.libro});
  @override
  State<LibroFormScreen> createState() => _LibroFormScreenState();
}

class _LibroFormScreenState extends State<LibroFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _autorCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _imgExistente;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.libro != null) {
      _tituloCtrl.text = widget.libro!['titulo'];
      _autorCtrl.text = widget.libro!['autor'];
      _descCtrl.text = widget.libro!['descripcion'] ?? '';
      _imgExistente = widget.libro!['imagen'];
      if (_imgExistente != null && _imgExistente!.startsWith('http'))
        _urlCtrl.text = _imgExistente!;
    }
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final Map<String, String> data = {
      "titulo": _tituloCtrl.text,
      "autor": _autorCtrl.text,
      "descripcion": _descCtrl.text,
      "imagen": _urlCtrl.text,
    };
    bool ok = widget.libro == null
        ? await ApiService.addLibro(data, _imageFile)
        : await ApiService.updateLibro(widget.libro!['_id'], data, _imageFile);
    setState(() => _isLoading = false);
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.libro == null ? "Nuevo Libro" : "Editar Libro"),
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
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _mostrarImagen(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _urlCtrl,
                decoration: const InputDecoration(
                  labelText: "URL de la Portada (PC)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Obligatorio" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _autorCtrl,
                decoration: const InputDecoration(
                  labelText: "Autor",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Obligatorio" : null,
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

  Widget _mostrarImagen() {
    if (_imageFile != null) return Image.file(_imageFile!, fit: BoxFit.cover);
    if (_urlCtrl.text.isNotEmpty)
      return Image.network(
        _urlCtrl.text,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    if (_imgExistente != null)
      return Image.network(_imgExistente!, fit: BoxFit.cover);
    return const Icon(Icons.add_a_photo, size: 40, color: Colors.indigo);
  }
}
