import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:the_pride/theme/theme.dart';

class GreetingsGapFillGame extends StatefulWidget {
  const GreetingsGapFillGame({super.key});
  @override
  State<GreetingsGapFillGame> createState() => _GreetingsGapFillGameState();
}

class _GreetingsGapFillGameState extends State<GreetingsGapFillGame> {
  final r = Random();
  late List<String> phrases;
  late List<List<String?>> selected;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    phrases = [
      '___ morning!',
      '___ are you?',
      'How’s ___ going?',
      '___ you later!',
    ];

    selected = [
      [null, null],
      [null, null],
      [null, null],
      [null, null],
    ];

    setState(() {});
  }

  bool _isCorrectRow(int i) {
    return selected[i][0] == 'Good' && selected[i][1] == 'morning';
  }

  void _checkAnswer() {
    if (_isCorrectRow(0)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Correct!',
        desc: 'Great job!',
        btnOkOnPress: () {
          setState(() {});
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Fill the Gaps with Correct Words',
            style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < phrases.length; i++)
            Row(
              children: [
                Text(phrases[i], style: primaryTextStyle.copyWith(fontSize: 16)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selected[i][0],
                  items: ['Good', 'Hello', 'Take', 'How', 'What']
                      .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selected[i][0] = value;
                    });
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selected[i][1],
                  items: ['morning', 'you', 'it', 'later']
                      .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selected[i][1] = value;
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkAnswer,
            child: const Text('Check Answer'),
          ),
        ],
      ),
    );
  }
}
