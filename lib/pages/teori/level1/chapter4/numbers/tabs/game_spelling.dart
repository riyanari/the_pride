import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter4/numbers/numbers_shared.dart';
import 'package:the_pride/theme/theme.dart';

class NumbersSpellingGame extends StatefulWidget {
  const NumbersSpellingGame({super.key});

  @override
  State<NumbersSpellingGame> createState() => _NumbersSpellingGameState();
}

class _NumbersSpellingGameState extends State<NumbersSpellingGame> {
  final r = Random();
  late List<NumberVocab> _pool;
  int _idx = 0;
  int _score = 0;
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pool = [...kNumberVocab]..shuffle(r);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    if (_idx >= _pool.length) return;
    final item = _pool[_idx];
    final input = normalizeWords(_ctrl.text);
    final target = normalizeWords(item.word);
    final ok = input == target;

    if (ok) _score++;

    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.error,
      title: ok ? 'Benar!' : 'Jawaban',
      desc: ok ? 'Good job!' : 'Yang benar: “${item.word}”',
      btnOkOnPress: () {
        setState(() {
          _idx++;
          _ctrl.clear();
          if (_idx == _pool.length) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: 'Selesai',
              desc: 'Skor: $_score / ${_pool.length}',
              btnOkOnPress: () {},
            ).show();
          }
        });
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final done = _idx >= _pool.length;
    final v = done ? null : _pool[_idx];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Spelling (Type the Word)', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              Text('Skor: $_score', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.keyboard, text: 'Ketik ejaan Inggris dari angka yang ditampilkan. Hyphen & spasi diabaikan untuk pengecekan.'),
          const SizedBox(height: 12),
          if (done)
            Center(child: Text('Game selesai 🎉', style: primaryTextStyle))
          else ...[
            Center(child: Text(v!.numeral, style: primaryTextStyle.copyWith(fontSize: 42, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Ejaan Inggris (contoh: twenty-one)',
                prefixIcon: Icon(Icons.spellcheck),
              ),
              onSubmitted: (_) => _check(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _check,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Cek'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _idx = min(_idx + 1, _pool.length);
                    _ctrl.clear();
                  }),
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Skip'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Hint Indonesia: ${v.indo}', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
          ],
        ],
      ),
    );
  }
}
