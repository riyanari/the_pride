import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:the_pride/theme/theme.dart';

class GreetingsMCQGame extends StatefulWidget {
  const GreetingsMCQGame({super.key});
  @override
  State<GreetingsMCQGame> createState() => _GreetingsMCQGameState();
}

class _GreetingsMCQGameState extends State<GreetingsMCQGame> {
  final r = Random();
  int _score = 0;
  int _i = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the appropriate greeting for morning?',
      'options': ['Hello', 'Good morning', 'Hey', 'Good night'],
      'correct': 1,
      'explanation': '“Good morning” is commonly used in the morning time.'
    },
    {
      'question': 'What is a casual greeting?',
      'options': ['Hello', 'Good morning', 'Hey', 'Good night'],
      'correct': 2,
      'explanation': '“Hey” is very informal and used among friends.'
    },
    {
      'question': 'What does "Goodbye" mean?',
      'options': ['Good morning', 'Farewell', 'See you later', 'Hello'],
      'correct': 1,
      'explanation': '“Goodbye” is used when parting ways.'
    },
  ];

  void _checkAnswer(int selected) {
    final correct = _questions[_i]['correct'] == selected;
    if (correct) _score++;

    AwesomeDialog(
      context: context,
      dialogType: correct ? DialogType.success : DialogType.info,
      title: correct ? 'Correct! 🎉' : 'Try Again',
      desc: _questions[_i]['explanation'],
      btnOkOnPress: () {
        if (_i < _questions.length - 1) {
          setState(() {
            _i++;
          });
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Game Over',
            desc: 'Your Score: $_score/${_questions.length}',
            btnOkOnPress: () {
              setState(() {
                _i = 0;
                _score = 0;
              });
            },
          ).show();
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_i];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Score: $_score/${_questions.length}',
            style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18),
          ),
          const SizedBox(height: 20),
          Text(
            question['question'],
            style: primaryTextStyle.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < question['options'].length; i++)
            ElevatedButton(
              onPressed: () => _checkAnswer(i),
              child: Text(question['options'][i]),
            ),
        ],
      ),
    );
  }
}
