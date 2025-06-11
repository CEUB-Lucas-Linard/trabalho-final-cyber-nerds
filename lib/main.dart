import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/cadastro_exercicio.dart';

void main() {
  runApp(const GymApp());
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyGym',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
      routes: {
        '/cadastro': (ctx) => const CadastroExercicioScreen(),
      },
    );
  }
}
