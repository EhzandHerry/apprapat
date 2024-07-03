import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apprapat/screens/admin_home_screen.dart';
import 'package:apprapat/screens/login_screen.dart';
import 'package:apprapat/screens/register_screen.dart';
import 'package:apprapat/controllers/rapat_controller.dart';
import 'package:apprapat/screens/user_home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RapatController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Clean Architecture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/user/home': (context) => UserHomeScreen(),
          '/admin/home': (context) => AdminHomeScreen(),
        },
      ),
    );
  }
}
