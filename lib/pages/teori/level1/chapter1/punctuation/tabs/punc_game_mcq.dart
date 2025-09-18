import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class PuncMCQGame extends StatefulWidget {
  const PuncMCQGame({super.key});
  @override
  State<PuncMCQGame> createState() => _PuncMCQGameState();
}

class _Item {
  final String question;
  final List<String> options;
  final int correct;
  final String explain;
  const _Item(this.question, this.options, this.correct, this.explain);
}

class _PuncMCQGameState extends State<PuncMCQGame> {
  final r = Random();
  late List<_Item> _items;
  int _i = 0;
  int _score = 0;

  @override
  void initState() { super.initState(); _setup(); }

  void _setup() {
    _items = [
      _Item(
        'Choose the correct punctuation: “Let’s eat__ grandma!”',
        [',', ';', ':', '—'],
        0,
        'Harus koma: “Let’s eat, grandma!” (menghindari makna yang salah).',
      ),
      _Item(
        'Pick the best: “I bought three things__ apples, oranges, and milk.”',
        [',', ':', ';', '—'],
        1,
        'Colon memperkenalkan daftar setelah klausa lengkap.',
      ),
      _Item(
        'Which is correct for two related independent clauses?',
        ['Use a comma', 'Use a semicolon', 'Use a colon', 'No punctuation'],
        1,
        'Semicolon menghubungkan dua independent clause yang berhubungan.',
      ),
      _Item(
        'Direct speech: She said__ “I’m ready.”',
        [',', ';', ':', '—'],
        0,
        'Koma sebelum kutipan langsung dalam gaya umum AmE.',
      ),
    ]..shuffle(r);
    _i = 0; _score = 0; setState(() {});
  }

  void _answer(int pick) {
    final it = _items[_i];
    final ok = pick == it.correct;
    if (ok) _score++;
    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Benar! 🎉' : 'Belum tepat',
      desc: it.explain,
      btnOkOnPress: () {
        if (_i < _items.length - 1) {
          setState(() => _i++);
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Selesai',
            desc: 'Skor: $_score / ${_items.length}',
            btnOkText: 'Main lagi',
            btnOkOnPress: _setup,
          ).show();
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final it = _items[_i];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Game: MCQ', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
                ),
                child: Text('Skor: $_score'),
              ),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
            ),
            child: Text(it.question),
          ),
          const SizedBox(height: 12),
          ...List.generate(it.options.length, (idx) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () => _answer(idx),
              child: Text(it.options[idx]),
            ),
          )),
        ],
      ),
    );
  }
}
