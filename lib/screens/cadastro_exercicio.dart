import 'package:flutter/material.dart';
import '../widgets/exercicio_form.dart';
import '../models/exercicio.dart';

class CadastroExercicioScreen extends StatefulWidget {
  const CadastroExercicioScreen({super.key});

  @override
  _CadastroExercicioScreenState createState() => _CadastroExercicioScreenState();
}

class _CadastroExercicioScreenState extends State<CadastroExercicioScreen> {
  final List<Exercicio> _exercicios = [];

  void _addExercicio(String nome, String descricao, String grupo) {
    setState(() {
      _exercicios.add(
        Exercicio(nome: nome, descricao: descricao, grupoMuscular: grupo),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exercício salvo!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Cadastro de Exercícios'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ExercicioForm(onSubmit: _addExercicio),
            const SizedBox(height: 20),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
            const Text(
              'Exercícios cadastrados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _exercicios.length,
                itemBuilder: (ctx, index) {
                  final exercicio = _exercicios[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black),
                    ),
                    color: const Color(0xFFFFF176), // Amarelo claro
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        exercicio.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${exercicio.grupoMuscular} - ${exercicio.descricao}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
