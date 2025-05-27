import 'package:flutter/material.dart';

class ExercicioForm extends StatefulWidget {
  final Function(String, String, String) onSubmit;

  const ExercicioForm({super.key, required this.onSubmit});

  @override
  _ExercicioFormState createState() => _ExercicioFormState();
}

class _ExercicioFormState extends State<ExercicioForm> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _grupoController = TextEditingController();

  void _submit() {
    final nome = _nomeController.text;
    final descricao = _descricaoController.text;
    final grupo = _grupoController.text;

    if (nome.isEmpty || descricao.isEmpty || grupo.isEmpty) return;

    widget.onSubmit(nome, descricao, grupo);

    _nomeController.clear();
    _descricaoController.clear();
    _grupoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(_nomeController, 'Nome do Exercício'),
        const SizedBox(height: 10),
        _buildTextField(_descricaoController, 'Descrição'),
        const SizedBox(height: 10),
        _buildTextField(_grupoController, 'Grupo Muscular'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Salvar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

 Widget _buildTextField(TextEditingController controller, String label) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFFFF176), // Amarelo mais claro
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
    ),
  );
}
}
