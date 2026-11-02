
import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

class CookingModeScreen extends StatefulWidget {

  const CookingModeScreen({super.key, required this.currentMeal});

  final Meal currentMeal;

  @override
  State<CookingModeScreen> createState() {
    return _CookingModeScreenState();
  }

}

class _CookingModeScreenState extends State<CookingModeScreen> {

  late final Meal _currentMeal;
  int _currentInstructionIndex = 0;

  @override
  void initState() {
    super.initState();

    _currentMeal = widget.currentMeal;
  }

  void _previousInstruction() {
    setState(() {
      if (_currentInstructionIndex > 0) _currentInstructionIndex--;
    });
  }

  void _nextInstruction() {
    setState(() {
      if (_currentInstructionIndex < _currentMeal.steps.length - 1) _currentInstructionIndex++;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentMeal.title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _previousInstruction, child: Text('Previous')),
                SizedBox(width: 4),
                ElevatedButton(onPressed: _nextInstruction, child: Text('Next'))
              ]
            ),
            Text(_currentMeal.steps[_currentInstructionIndex], style: TextStyle(color: Colors.white, fontSize: 24)),
          ]
        ),
      ),
    );
  }
}