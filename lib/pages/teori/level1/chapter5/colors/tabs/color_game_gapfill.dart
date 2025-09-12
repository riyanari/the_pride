import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

class ColorGapFillGame extends StatefulWidget {
  const ColorGapFillGame({super.key});
  @override
  State<ColorGapFillGame> createState() => _ColorGapFillGameState();
}

class _Item {
  final List<String> parts;
  final List<List<String>> options;
  final List<String> answers;
  const _Item({required this.parts, required this.options, required this.answers});
}

class _ColorGapFillGameState extends State<ColorGapFillGame> {
  final r = Random();
  late List<_Item> _items;
  late List<List<String?>> _selected;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    _items = [
      _Item(
        parts: ['I prefer ', ' clothes.', ''],
        options: [
          ['black', 'blacks', 'blackes'],
          [' ', 'color', 'colorful'],
        ],
        answers: ['black', ' '],
      ),
      _Item(
        parts: ['She has a ', ' ', ' bag.'],
        options: [
          ['small', 'smaller', 'smalls'],
          ['red', 'reds', 'redy'],
        ],
        answers: ['small', 'red'],
      ),
      _Item(
        parts: ['The shirt is ', ' ', '.'],
        options: [
          ['dark', 'darks', 'darkly'],
          ['blue', 'blues', 'bluey'],
        ],
        answers: ['dark', 'blue'],
      ),
      _Item(
        parts: ['He bought a ', ' jacket with ', ' pattern.'],
        options: [
          ['green', 'greens', 'greeny'],
          ['striped', 'stripe', 'stripes'],
        ],
        answers: ['green', 'striped'],
      ),
    ];
    for (final it in _items) {
      for (final list in it.options) { list.shuffle(r); }
    }
    _selected = List.generate(_items.length, (i) => List.filled(_items[i].answers.length, null));
    setState((){});
  }

  bool _ok(int i) {
    for (int b=0; b<_items[i].answers.length; b++) {
      if (_selected[i][b] != _items[i].answers[b]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.pink;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Gap Fill', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 6),
          _info(icon: Icons.extension, text: 'Lengkapi kalimat dengan pilihan yang paling natural.'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final allAnswered = _selected[i].every((e) => e != null);
                final allCorrect  = allAnswered && _ok(i);
                Color border = Colors.grey.withValues(alpha:0.3);
                Color bg = Colors.white;
                if (allCorrect) { border = Colors.green; bg = Colors.green.withValues(alpha:0.06); }
                else if (allAnswered) { border = Colors.red; bg = Colors.red.withValues(alpha:0.06); }

                final it = _items[i];
                return Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (int b=0; b<it.answers.length; b++) ...[
                          Text(it.parts[b], style: primaryTextStyle),
                          _dd(i, b, it.options[b], color),
                        ],
                        Text(it.parts.last, style: primaryTextStyle),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Submit Skor'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dd(int idxItem, int idxBlank, List<String> options, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha:0.25)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: _selected[idxItem][idxBlank],
          hint: const Text('…'),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(()=>_selected[idxItem][idxBlank]=v),
        ),
      ),
    );
  }

  void _submit() {
    int correct = 0;
    for (int i=0; i<_items.length; i++) {
      if (_ok(i)) correct++;
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Skor Gap Fill',
      desc: 'Benar: $correct / ${_items.length}',
      btnOkOnPress: () {},
    ).show();
  }

  Widget _info({required IconData icon, required String text, Color? color}) {
    final c = color ?? Colors.indigo;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha:0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: c, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
