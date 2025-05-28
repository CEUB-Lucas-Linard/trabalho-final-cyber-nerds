import 'package:flutter/material.dart';

class ExercicioForm extends StatefulWidget {
  final Function(String, String, String) onSubmit;

  const ExercicioForm({super.key, required this.onSubmit});

  @override
  State<ExercicioForm> createState() => _ExercicioFormState();
}

class _ExercicioFormState extends State<ExercicioForm> {
  final List<String> nomesExercicios = [
    'Agachamento',
    'Supino',
    'Remada',
    'Flexão',
    'Elevação Lateral',
    'Stiff',
  ];

  final List<String> descricoes = [
    'Peso livre',
    'Máquina',
    'Funcional',
  ];

  final Map<String, String> exercicioGrupo = {
    'Agachamento': 'Pernas',
    'Supino': 'Peito',
    'Remada': 'Costas',
    'Flexão': 'Peito',
    'Elevação Lateral': 'Ombros',
    'Stiff': 'Posterior de coxa',
  };

  String? nomeSelecionado;
  String? descricaoSelecionada;
  String? grupoMuscularAtual;

  void _submit() {
    if (nomeSelecionado == null || descricaoSelecionada == null || grupoMuscularAtual == null) return;

    widget.onSubmit(nomeSelecionado!, descricaoSelecionada!, grupoMuscularAtual!);

    setState(() {
      nomeSelecionado = null;
      descricaoSelecionada = null;
      grupoMuscularAtual = null;
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFFF176),
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
      dropdownColor: Colors.white,
      items: options.map((opcao) {
        return DropdownMenuItem(
          value: opcao,
          child: Text(opcao),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          label: 'Nome do Exercício',
          value: nomeSelecionado,
          options: nomesExercicios,
          onChanged: (value) {
            setState(() {
              nomeSelecionado = value;
              grupoMuscularAtual = value != null ? exercicioGrupo[value] : null;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          label: 'Descrição',
          value: descricaoSelecionada,
          options: descricoes,
          onChanged: (value) => setState(() => descricaoSelecionada = value),
        ),
        const SizedBox(height: 20),
        if (grupoMuscularAtual != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Grupo Muscular: $grupoMuscularAtual',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
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
}
