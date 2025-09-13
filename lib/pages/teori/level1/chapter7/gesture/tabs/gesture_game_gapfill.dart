import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../gesture_shared.dart';
import 'package:the_pride/theme/theme.dart';

class GestureGapFillGame extends StatefulWidget {
  const GestureGapFillGame({super.key});
  @override
  State<GestureGapFillGame> createState() => _GestureGapFillGameState();
}

class _GapItem {
  final List<String> parts;
  final List<List<String>> optionsPerBlank;
  final List<String> answers;
  const _GapItem({required this.parts, required this.optionsPerBlank, required this.answers});
}

class _GestureGapFillGameState extends State<GestureGapFillGame> {
  final r = Random();
  late List<_GapItem> _items;
  late List<List<String?>> _selected;

  @override
  void initState() { super.initState(); _initData(); }

  void _initData() {
    _items = [
      _GapItem(
        parts: ['He gave me a ', ' after my pitch.'],
        optionsPerBlank: [['thumbs-up','shrug','facepalm']],
        answers: ['thumbs-up'],
      ),
      _GapItem(
        parts: ['She ', ' to show agreement.'],
        optionsPerBlank: [['nodded','shook her head','clapped']],
        answers: ['nodded'],
      ),
      _GapItem(
        parts: ['We greeted each other with a ', ' .'],
        optionsPerBlank: [['handshake','crossed arms','point']],
        answers: ['handshake'],
      ),
      _GapItem(
        parts: ['In Japan, people often ', ' to show respect.'],
        optionsPerBlank: [['bow','beckon','high-five']],
        answers: ['bow'],
      ),
      _GapItem(
        parts: ['Please don’t ', ' at people. It can be rude.'],
        optionsPerBlank: [['point','wave','nod']],
        answers: ['point'],
      ),
    ];

    _items = List<_GapItem>.of(_items)..shuffle(r);
    for (final it in _items) { for (final opts in it.optionsPerBlank) { opts.shuffle(r); } }
    _selected = List.generate(_items.length, (i) => List.generate(_items[i].answers.length, (_) => null));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.deepPurple;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Gap Fill', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _initData, icon: const Icon(Icons.shuffle)),
              IconButton(onPressed: _resetSelections, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.extension, text: 'Lengkapi kalimat dengan pilihan yang paling natural.'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _gapCard(i, color),
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
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _reveal,
                icon: const Icon(Icons.visibility),
                label: const Text('Reveal'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gapCard(int index, Color color) {
    final item = _items[index];
    final sel = _selected[index];

    Color border = Colors.grey.withValues(alpha:0.3);
    Color bg = Colors.white;
    final allAnswered = sel.every((e) => e != null);
    final allCorrect = allAnswered && _isAllCorrect(index);
    if (allCorrect) { border = Colors.green; bg = Colors.green.withValues(alpha:0.06); }
    else if (allAnswered) { border = Colors.red; bg = Colors.red.withValues(alpha:0.06); }

    return Container(
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (int b = 0; b < item.answers.length; b++) ...[
              Text(item.parts[b], style: primaryTextStyle),
              _blankDropdown(
                value: sel[b], options: item.optionsPerBlank[b],
                onChanged: (v) => setState(() => sel[b] = v), color: color,
              ),
            ],
            Text(item.parts.last, style: primaryTextStyle),
          ],
        ),
      ),
    );
  }

  Widget _blankDropdown({
    required String? value, required List<String> options, required ValueChanged<String?> onChanged, required Color color,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.08), borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha:0.25)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true, value: value, hint: const Text('…', overflow: TextOverflow.ellipsis),
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  bool _isAllCorrect(int i) {
    for (int b = 0; b < _items[i].answers.length; b++) {
      if (_selected[i][b] != _items[i].answers[b]) return false;
    }
    return true;
  }

  void _resetSelections() {
    for (int i = 0; i < _selected.length; i++) {
      for (int b = 0; b < _selected[i].length; b++) { _selected[i][b] = null; }
    }
    setState(() {});
  }

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _items.length; i++) { if (_isAllCorrect(i)) correct++; }
    AwesomeDialog(
      context: context, dialogType: DialogType.success,
      title: 'Skor Gap Fill', desc: 'Benar: $correct / ${_items.length}', btnOkOnPress: () {},
    ).show();
  }

  void _reveal() {
    for (int i = 0; i < _items.length; i++) {
      for (int b = 0; b < _items[i].answers.length; b++) { _selected[i][b] = _items[i].answers[b]; }
    }
    setState(() {});
  }
}
