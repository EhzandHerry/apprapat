import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apprapat/models/admin.dart';

class AdminService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> loginAdmin(Admin admin) async {
    final url = Uri.parse('$baseUrl/admin/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(admin.toJson()),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return true; // Login successful
    } else {
      print('Failed to login: ${response.body}');
      return false; // Login failed
    }
  }
}