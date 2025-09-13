import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

class AuxVGapFillGame extends StatefulWidget {
  const AuxVGapFillGame({super.key});

  @override
  State<AuxVGapFillGame> createState() => _AuxVGapFillGameState();
}

class _GapItem {
  final List<String> parts;                 // text parts around blanks
  final List<List<String>> optionsPerBlank; // options per blank
  final List<String> answers;               // correct answers
  const _GapItem({required this.parts, required this.optionsPerBlank, required this.answers});
}

class _AuxVGapFillGameState extends State<AuxVGapFillGame> {
  final _rand = Random();
  late List<_GapItem> _items;
  late List<List<String?>> _selected;

  @override
  void initState() { super.initState(); _initData(); }

  void _initData() {
    _items = [
      _GapItem(
        parts: ['___ you like music?', ''],
        optionsPerBlank: [['Do','Does','Are']],
        answers: ['Do'],
      ),
      _GapItem(
        parts: ['She ___ cooking dinner right now.', ''],
        optionsPerBlank: [['is','does','has']],
        answers: ['is'],
      ),
      _GapItem(
        parts: ['They ___ finished their tasks.', ''],
        optionsPerBlank: [['have','are','did']],
        answers: ['have'],
      ),
      _GapItem(
        parts: ['___ he go to school yesterday?', ''],
        optionsPerBlank: [['Did','Does','Is']],
        answers: ['Did'],
      ),
      _GapItem(
        parts: ['We ___ not ready.', ''],
        optionsPerBlank: [['are','do','have']],
        answers: ['are'],
      ),
      _GapItem(
        parts: ['It ___ built in 2005 (passive).', ''],
        optionsPerBlank: [['was','did','has']],
        answers: ['was'],
      ),
    ];

    _items = [..._items]..shuffle(_rand);
    for (final it in _items) { for (final opts in it.optionsPerBlank) { opts.shuffle(_rand); } }
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
          _infoBadge(icon: Icons.extension, text: 'Pilih auxiliary yang paling tepat.'),
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
              _blankDropdown(
                value: sel[b],
                options: item.optionsPerBlank[b],
                onChanged: (v) => setState(() => sel[b] = v),
                color: color,
              ),
              Text(item.parts[b], style: primaryTextStyle),
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
          value: value,
          hint: const Text('…'),
          isDense: true,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
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
      for (int b = 0; b < _selected[i].length; b++) {
        _selected[i][b] = null;
      }
    }
    setState(() {});
  }

  void _submit() {
    int correct = 0;
    for (int i = 0; i < _items.length; i++) {
      if (_isAllCorrect(i)) correct++;
    }
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

  Widget _infoBadge({required IconData icon, required String text, Color? color}) {
    final c = color ?? Colors.indigo;
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha:0.25), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: c, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]))),
        ],
      ),
    );
  }
}
