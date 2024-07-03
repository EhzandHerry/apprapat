import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> register(String name, String email,
      String password, String passwordConfirmation, String divisi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'divisi': divisi
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 422) {
      return {'error': jsonDecode(response.body)};
    } else {
      return {'error': 'Failed to register user: ${response.body}'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      return {'error': 'Invalid credentials'};
    } else {
      return {'error': 'Failed to login user: ${response.body}'};
    }
  }
}
