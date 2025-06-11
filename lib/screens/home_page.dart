import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_gym/models/exercicio.dart'; // Make sure this import is correct

class HomePage extends StatefulWidget {
  const HomePage({super.key});

 @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Exercicio> _exercicios = [];
  bool _showWeeklyData = true; // Toggle for weekly/monthly view

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<File> _getExercisesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/exercises.json');
  }

  Future<void> _loadExercises() async {
    try {
      final file = await _getExercisesFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        setState(() {
          _exercicios = jsonList.map((json) => Exercicio.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  // Calculate data for the pie chart based on the selected period
  Map<String, double> _getChartData() {
    final now = DateTime.now();
    final startOfPeriod = _showWeeklyData
        ? now.subtract(Duration(days: now.weekday - 1)) // Start of the current week
        : DateTime(now.year, now.month, 1); // Start of the current month

    final Map<String, double> data = {};

    for (var exercicio in _exercicios) {
      if (exercicio.date.isAfter(startOfPeriod) && exercicio.date.isBefore(now.add(Duration(days: 1)))) {
        final group = exercicio.muscleGroup;
        final value = _showWeeklyData ? 1.0 : (exercicio.duration ?? 0).toDouble(); // Use 1 for frequency, duration for time
        data[group] = (data[group] ?? 0) + value;
      }
    }
    return data;
  }

  List<PieChartSectionData> _getSections() {
    final data = _getChartData();
    if (data.isEmpty) {
      return [];
    }

    return data.entries.map((entry) {
      const double radius = 80;
      const double titleFontSize = 14;
      const FontWeight titleFontWeight = FontWeight.bold;
      const Color textColor = Colors.white;

      // Simple color assignment (you might want a more sophisticated approach)
      Color sectionColor;
      switch (entry.key) {
        case 'Peito':
          sectionColor = Colors.red;
          break;
        case 'Costas':
          sectionColor = Colors.blue;
          break;
        case 'Pernas':
          sectionColor = Colors.green;
          break;
        case 'Braços':
          sectionColor = Colors.orange;
          break;
        case 'Ombros':
          sectionColor = Colors.purple;
          break;
        default:
          sectionColor = Colors.grey;
      }

      return PieChartSectionData(
        color: sectionColor,
        value: entry.value,
        title: entry.key,
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: titleFontSize,
          fontWeight: titleFontWeight,
          color: textColor,
        ),
        // Optional: Show value on the slice
        badgeWidget: Text(
          entry.value.toStringAsFixed(0), // Display value without decimals
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        badgePositionedOffset: 10,
      );
    }).toList();
  }

  void _toggleView() {
    setState(() {
      _showWeeklyData = !_showWeeklyData;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('MyGym'),
        backgroundColor: Colors.black,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _selectedDay != null
                ? 'Treino selecionado: ${_selectedDay!.toLocal().toString().split(' ')[0]}'
                : 'Selecione um dia para ver ou adicionar treino',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _toggleView,
                child: Text(_showWeeklyData ? 'Mostrar Mensal' : 'Mostrar Semanal'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: _getSections(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  // Optional: Add touches or other features
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastro').then((_) {
                // Refresh data when returning from the cadastro screen
                _loadExercises();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Cadastrar Exercício',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adicionar treino')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
