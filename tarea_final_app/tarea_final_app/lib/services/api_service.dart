import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // CONFIGURACIÓN DE IP
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:3000/api';
    return 'http://10.0.2.2:3000/api';
  }

  // --- LOGIN ---
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

  // --- LIBROS (CRUD) ---
  static Future<List<dynamic>> getLibros() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/libros'));
      return response.statusCode == 200 ? json.decode(response.body) : [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addLibro(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/libros'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateLibro(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/libros/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteLibro(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/libros/$id'));
    return response.statusCode == 200;
  }

  // --- ESTUDIANTES (CRUD NUEVO) ---
  static Future<List<dynamic>> getEstudiantes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/estudiantes'));
      return response.statusCode == 200 ? json.decode(response.body) : [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addEstudiante(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/estudiantes'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateEstudiante(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/estudiantes/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteEstudiante(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/estudiantes/$id'));
    return response.statusCode == 200;
  }
}
