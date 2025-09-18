import 'dart:math';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PuncGapFillGame extends StatefulWidget {
  const PuncGapFillGame({super.key});
  @override
  State<PuncGapFillGame> createState() => _PuncGapFillGameState();
}

class _Item {
  final List<String> parts; // blanks = parts.length - 1
  final List<List<String>> options;
  final List<String> answers;
  final String explain;
  const _Item({required this.parts, required this.options, required this.answers, required this.explain});
}

class _PuncGapFillGameState extends State<PuncGapFillGame> {
  final r = Random();
  late List<_Item> _items;
  late List<List<String?>> _picked;

  @override
  void initState() { super.initState(); _setup(); }

  void _setup() {
    _items = [
      _Item(
        parts: ['Let’s eat', ' grandma!'],
        options: [[',', ';', ':', '—']],
        answers: [','],
        explain: 'Koma memisahkan vokatif: “Let’s eat, grandma!”',
      ),
      _Item(
        parts: ['I have three pets', ' a dog', ', a cat', ', and a turtle.'],
        options: [[':', ',', ';'], [',', ';'], [',', ';']],
        answers: [':', ',', ','],
        explain: 'Colon memperkenalkan daftar; serial comma untuk kejelasan.',
      ),
      _Item(
        parts: ['It’s raining', ' take an umbrella.'],
        options: [[';', ',', ':', '—']],
        answers: [';'],
        explain: 'Semicolon menghubungkan dua independent clause terkait.',
      ),
    ]..shuffle(r);

    for (final it in _items) {
      for (final o in it.options) { o.shuffle(r); }
    }
    _picked = List.generate(_items.length, (i) => List.filled(_items[i].answers.length, null));
    setState(() {});
  }

  bool _isCorrectRow(int i) {
    for (int b = 0; b < _items[i].answers.length; b++) {
      if (_picked[i][b] != _items[i].answers[b]) return false;
    }
    return true;
  }

  void _submit() {
    int ok = 0;
    for (int i = 0; i < _items.length; i++) {
      if (_isCorrectRow(i)) ok++;
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Skor',
      desc: 'Benar: $ok / ${_items.length}',
      btnOkOnPress: () {},
    ).show();
  }

  Widget _inlineDropdown({
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black54)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: value,
          hint: const Text(' '),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _rowCard(int i) {
    final it = _items[i];
    final sel = _picked[i];
    final answered = sel.every((e) => e != null);
    final correct = answered && _isCorrectRow(i);

    Color border = Colors.grey.withValues(alpha:0.3);
    Color bg = Colors.white;
    if (correct) { border = Colors.green; bg = Colors.green.withValues(alpha:0.06); }
    else if (answered) { border = Colors.red; bg = Colors.red.withValues(alpha:0.06); }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (int b = 0; b < it.answers.length; b++) ...[
            if (it.parts[b].isNotEmpty) Text(it.parts[b]),
            _inlineDropdown(
              value: sel[b],
              options: it.options[b],
              onChanged: (v) => setState(() => sel[b] = v),
            ),
          ],
          if (it.parts.last.isNotEmpty) Text(it.parts.last),
          if (answered) Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 6),
            child: Text(it.explain, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Game: Gap Fill', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
              ElevatedButton.icon(onPressed: _submit, icon: const Icon(Icons.check), label: const Text('Submit')),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _rowCard(i),
            ),
          ),
        ],
      ),
    );
  }
}
