import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/student.dart';

class StudentService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<Student>> fetchStudents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/students'),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data.map((item) => Student.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch students');
    }
  }

  static Future<void> createStudent({
    required String name,
    required String major,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/students'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'major': major,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create student: ${response.body}');
    }
  }

  static Future<void> uploadImage({
    required int studentId,
    required XFile imageFile,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/students/$studentId/upload'),
    );

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Failed to upload image: ${response.body}');
    }
  }
}