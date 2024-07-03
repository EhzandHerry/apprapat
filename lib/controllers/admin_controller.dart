import 'package:flutter/material.dart';
import 'package:apprapat/models/admin.dart';
import 'package:apprapat/services/admin_service.dart';

class AdminController {
  final AdminService _adminService = AdminService();

  Future<void> login(BuildContext context, String email, String password) async {
    final admin = Admin(email: email, password: password);
    final isLoggedIn = await _adminService.loginAdmin(admin);

    if (isLoggedIn) {
      // Jika login berhasil, arahkan ke halaman home admin
      Navigator.pushReplacementNamed(context, '/admin/home');
    } else {
      // Jika login gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }
}
