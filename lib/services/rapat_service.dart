import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apprapat/models/rapat.dart';

class RapatService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Rapat>> fetchRapats() async {
    final response = await http.get(Uri.parse('$baseUrl/rapats'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((rapat) => Rapat.fromJson(rapat)).toList();
    } else {
      throw Exception('Failed to load rapats');
    }
  }

  Future<Rapat> createRapat(Rapat rapat) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rapats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rapat.toJson()),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return Rapat.fromJson(json.decode(response.body)['rapat']);
    } else {
      throw Exception('Failed to create rapat: ${response.body}');
    }
  }

  Future<Rapat> updateRapat(int id, Rapat rapat) async {
    final response = await http.put(
      Uri.parse('$baseUrl/rapats/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rapat.toJson()),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Rapat.fromJson(json.decode(response.body)['rapat']);
    } else {
      throw Exception('Failed to update rapat: ${response.body}');
    }
  }

  Future<void> deleteRapat(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/rapats/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete rapat');
    }
  }
}
