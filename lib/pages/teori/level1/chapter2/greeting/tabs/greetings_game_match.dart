import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:the_pride/theme/theme.dart';

class GreetingsMatchGame extends StatefulWidget {
  const GreetingsMatchGame({super.key});

  @override
  State<GreetingsMatchGame> createState() => _GreetingsMatchGameState();
}

class _GreetingsMatchGameState extends State<GreetingsMatchGame> {
  final r = Random();
  late List<String> phrases;
  late List<String> responses;
  late List<String?> selectedResponses;
  int? selectedPhraseIndex; // Menyimpan indeks sapaan yang dipilih
  bool _isCheckingAnswer = false;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  // Menyiapkan permainan dengan mencampur sapaan dan respons
  void _setupGame() {
    phrases = ['Hello', 'Good morning', 'Hey', 'Goodbye', 'Cheers'];
    responses = ['Hi!', 'Good morning!', 'Yo!', 'Bye!', 'Cheers!'];
    selectedResponses = List.filled(phrases.length, null); // Respons yang dipilih untuk masing-masing sapaan
    phrases.shuffle(r);
    responses.shuffle(r);
    selectedPhraseIndex = null; // Tidak ada sapaan yang dipilih pada awalnya
    setState(() {});
  }

  // Memeriksa apakah semua pasangan benar
  bool _isAllCorrect() {
    for (int i = 0; i < phrases.length; i++) {
      if (selectedResponses[i] != responses[i]) {
        return false;
      }
    }
    return true;
  }

  // Cek jawaban dan tampilkan dialog
  void _checkAnswer() {
    setState(() {
      _isCheckingAnswer = true;
    });
    if (_isAllCorrect()) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Correct!',
        desc: 'Great job! You matched all greetings correctly.',
        btnOkOnPress: _setupGame,
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Incorrect!',
        desc: 'Some matches are wrong. Try again!',
        btnOkOnPress: () {},
      ).show();
    }
    setState(() {
      _isCheckingAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Text(
              'Match the Greetings with the Response',
              style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Row untuk kotak sapaan di kiri dan respons di kanan
            Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: phrases.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 3,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: _isCheckingAnswer
                            ? null
                            : () {
                          setState(() {
                            selectedPhraseIndex = index; // Menyimpan sapaan yang dipilih
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: selectedPhraseIndex == index
                                ? Colors.blue.withValues(alpha:0.5)
                                : Colors.blue.withValues(alpha:0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedPhraseIndex == index
                                  ? Colors.blue
                                  : Colors.blue.withValues(alpha:0.5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              phrases[index],
                              style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: responses.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 3,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: _isCheckingAnswer || selectedPhraseIndex == null
                            ? null
                            : () {
                          setState(() {
                            // Menyimpan respons yang dipilih untuk sapaan yang sudah dipilih
                            selectedResponses[selectedPhraseIndex!] = responses[index];
                          });
                          if (selectedResponses.every((response) => response != null)) {
                            // Memeriksa semua pasangan jika semua sapaan sudah dipilih
                            _checkAnswer();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: selectedResponses.contains(responses[index])
                                ? Colors.green
                                : Colors.orange.withValues(alpha:0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedResponses.contains(responses[index])
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              responses[index],
                              style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isCheckingAnswer ? null : _checkAnswer,
              child: const Text('Check Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
