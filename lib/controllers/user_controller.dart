import 'package:flutter/material.dart';
import 'package:apprapat/services/user_service.dart';

class UserController {
  final UserService _userService = UserService();

  Future<void> register(BuildContext context, String name, String email, String password, String passwordConfirmation, String divisi) async {
    final response = await _userService.register(name, email, password, passwordConfirmation, divisi);

    if (response.containsKey('user')) {
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registrasi berhasil, silahkan login!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registrasi gagal: ${response['error']}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    final response = await _userService.login(email, password);

    if (response.containsKey('token')) {
      Navigator.pushReplacementNamed(context, '/user/home');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login berhasil, selamat menikmati!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login gagal: ${response['error']}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }
}
