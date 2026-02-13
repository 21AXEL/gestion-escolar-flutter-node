import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // CONFIGURACIÓN DE IP ACTUALIZADA PARA LA UNIVERSIDAD
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:3000/api';
    return 'http://10.10.64.187:3000/api';
  }

  // --- 1. AUTENTICACIÓN ---
  static Future<bool> login(String usuario, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"usuario": usuario, "password": password}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // --- 2. GESTIÓN DE LIBROS ---
  static Future<List<dynamic>> getLibros() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/libros'));
      return response.statusCode == 200 ? json.decode(response.body) : [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addLibro(
    Map<String, String> data,
    File? imageFile,
  ) async {
    try {
      if (imageFile != null && !kIsWeb) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/libros'),
        );
        request.fields.addAll(data);
        request.files.add(
          await http.MultipartFile.fromPath('imagen', imageFile.path),
        );
        var res = await request.send();
        return res.statusCode == 200;
      } else {
        final res = await http.post(
          Uri.parse('$baseUrl/libros'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );
        return res.statusCode == 200;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateLibro(
    String id,
    Map<String, String> data,
    File? imageFile,
  ) async {
    try {
      if (imageFile != null && !kIsWeb) {
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse('$baseUrl/libros/$id'),
        );
        request.fields.addAll(data);
        request.files.add(
          await http.MultipartFile.fromPath('imagen', imageFile.path),
        );
        var res = await request.send();
        return res.statusCode == 200;
      } else {
        final res = await http.put(
          Uri.parse('$baseUrl/libros/$id'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );
        return res.statusCode == 200;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteLibro(String id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/libros/$id'));
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // --- 3. GESTIÓN DE ESTUDIANTES ---
  static Future<List<dynamic>> getEstudiantes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/estudiantes'));
      return response.statusCode == 200 ? json.decode(response.body) : [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addEstudiante(
    Map<String, String> data,
    File? imageFile,
  ) async {
    try {
      if (imageFile != null && !kIsWeb) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/estudiantes'),
        );
        request.fields.addAll(data);
        request.files.add(
          await http.MultipartFile.fromPath('imagen', imageFile.path),
        );
        var res = await request.send();
        return res.statusCode == 200;
      } else {
        final res = await http.post(
          Uri.parse('$baseUrl/estudiantes'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );
        return res.statusCode == 200;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateEstudiante(
    String id,
    Map<String, String> data,
    File? imageFile,
  ) async {
    try {
      if (imageFile != null && !kIsWeb) {
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse('$baseUrl/estudiantes/$id'),
        );
        request.fields.addAll(data);
        request.files.add(
          await http.MultipartFile.fromPath('imagen', imageFile.path),
        );
        var res = await request.send();
        return res.statusCode == 200;
      } else {
        final res = await http.put(
          Uri.parse('$baseUrl/estudiantes/$id'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );
        return res.statusCode == 200;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteEstudiante(String id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/estudiantes/$id'));
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
