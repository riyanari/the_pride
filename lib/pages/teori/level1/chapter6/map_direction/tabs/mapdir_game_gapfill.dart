import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

class MapDirGapFillGame extends StatefulWidget {
  const MapDirGapFillGame({super.key});
  @override
  State<MapDirGapFillGame> createState() => _MapDirGapFillGameState();
}

class _Item {
  final List<String> parts;
  final List<List<String>> options;
  final List<String> answers;
  const _Item({required this.parts, required this.options, required this.answers});
}

class _MapDirGapFillGameState extends State<MapDirGapFillGame> {
  final r = Random();
  late List<_Item> _items;
  late List<List<String?>> _sel;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    _items = [
      _Item(
        parts: ['Go ', ' for two ', ', then ', ' at the bank.'],
        options: [
          ['straight', 'forwardly', 'directly'],
          ['blocks', 'miles', 'corners'],
          ['turn left', 'go right', 'cross'],
        ],
        answers: ['straight', 'blocks', 'turn left'],
      ),
      _Item(
        parts: ['The bus stop is ', ' the library.'],
        options: [
          ['next to', 'under', 'above'],
        ],
        answers: ['next to'],
      ),
      _Item(
        parts: ['The park is ', ' the school ', ' the hospital.'],
        options: [
          ['between', 'behind', 'across from'],
          ['and', 'or', 'to'],
        ],
        answers: ['between', 'and'],
      ),
      _Item(
        parts: ['Please ', ' the street at the ', '.'],
        options: [
          ['cross', 'pass', 'go'],
          ['crosswalk', 'bridge', 'river'],
        ],
        answers: ['cross', 'crosswalk'],
      ),
    ];
    for (final it in _items) {
      for (final list in it.options) { list.shuffle(r); }
    }
    _sel = List.generate(_items.length, (i) => List<String?>.filled(_items[i].answers.length, null));
    setState((){});
  }

  bool _ok(int i) {
    for (int b=0; b<_items[i].answers.length; b++) {
      if (_sel[i][b] != _items[i].answers[b]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.orange;
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
                final all = _sel[i].every((e) => e != null);
                final ok  = all && _ok(i);
                Color border = Colors.grey.withValues(alpha:0.3);
                Color bg = Colors.white;
                if (ok) { border = Colors.green; bg = Colors.green.withValues(alpha:0.06); }
                else if (all) { border = Colors.red; bg = Colors.red.withValues(alpha:0.06); }

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
          value: _sel[idxItem][idxBlank],
          hint: const Text('…'),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(()=>_sel[idxItem][idxBlank]=v),
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
