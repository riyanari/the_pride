import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../compapo_shared.dart';

class CompApoGapFillGame extends StatefulWidget {
  const CompApoGapFillGame({super.key});

  @override
  State<CompApoGapFillGame> createState() => _CompApoGapFillGameState();
}

class _GapItem {
  final List<String> parts;
  final List<List<String>> optionsPerBlank;
  final List<String> answers;
  const _GapItem({required this.parts, required this.optionsPerBlank, required this.answers});
}

class _CompApoGapFillGameState extends State<CompApoGapFillGame> {
  final r = Random();
  late List<_GapItem> _items;
  late List<List<String?>> _selected;

  @override
  void initState() { super.initState(); _initData(); }

  void _initData() {
    _items = [
      _GapItem(
        parts: ["I'm ", ' sorry ', ' the delay.'],
        optionsPerBlank: [
          ['really', 'barely', 'sort of'],
          ['for', 'to', 'with'],
        ],
        answers: ['really', 'for'],
      ),
      _GapItem(
        parts: ['Could you ', ' check ', ' issue, please?'],
        optionsPerBlank: [
          ['possibly', 'loudly', 'rarely'],
          ['this', 'those', 'they'],
        ],
        answers: ['possibly', 'this'],
      ),
      _GapItem(
        parts: ['We can ', ' a refund ', ' a replacement.'],
        optionsPerBlank: [
          ['issue', 'ignore', 'delay'],
          ['or', 'but', 'and then cancel'],
        ],
        answers: ['issue', 'or'],
      ),
      _GapItem(
        parts: ['Thanks ', ' your patience.'],
        optionsPerBlank: [
          ['for', 'to', 'on'],
        ],
        answers: ['for'],
      ),
    ];

    _items = [..._items]..shuffle(r);
    for (final it in _items) {
      for (final opts in it.optionsPerBlank) { opts.shuffle(r); }
    }
    _selected = List.generate(_items.length, (i) => List.generate(_items[i].answers.length, (j) => null));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.deepPurple;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Gap Fill', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _initData, icon: const Icon(Icons.shuffle), tooltip: 'Shuffle'),
              IconButton(onPressed: _resetSelections, icon: const Icon(Icons.refresh), tooltip: 'Reset'),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.extension, text: 'Lengkapi kalimat dengan memilih jawaban yang paling natural.'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _gapCard(i, accent),
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
            for (int b = 0; b < item.answers.length; b++) ...[
              Text(item.parts[b], style: primaryTextStyle),
              _blankDropdown(
                value: sel[b],
                options: item.optionsPerBlank[b],
                onChanged: (v) => setState(() => sel[b] = v),
                color: color,
              ),
            ],
            Text(item.parts.last, style: primaryTextStyle),
          ],
        ),
      ),
    );
  }

  Widget _blankDropdown({
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required Color color,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha:0.25)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            menuMaxHeight: 320,
            value: value,
            hint: const Text('…', overflow: TextOverflow.ellipsis),
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
      context: context,
      dialogType: DialogType.success,
      title: 'Skor Gap Fill',
      desc: 'Benar: $correct / ${_items.length}',
      btnOkOnPress: () {},
    ).show();
  }

  void _reveal() {
    for (int i = 0; i < _items.length; i++) {
      for (int b = 0; b < _items[i].answers.length; b++) {
        _selected[i][b] = _items[i].answers[b];
      }
    }
    setState(() {});
  }
}
