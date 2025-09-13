import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../procedures_shared.dart';

class ProcGapFillGame extends StatefulWidget {
  const ProcGapFillGame({super.key});
  @override
  State<ProcGapFillGame> createState() => _ProcGapFillGameState();
}

class _GapItem {
  final List<String> parts;                 // teks di antara blank (blanks + 1)
  final List<List<String>> optionsPerBlank; // opsi per blank
  final List<String> answers;               // jawaban benar per blank
  const _GapItem({required this.parts, required this.optionsPerBlank, required this.answers});
}

class _ProcGapFillGameState extends State<ProcGapFillGame> {
  final r = Random();
  late List<_GapItem> _items;
  late List<List<String?>> _selected;

  @override
  void initState() { super.initState(); _initData(); }

  void _initData() {
    _items = [
      _GapItem(
        // Ada 2 blank → parts harus 3 (sebelum, antar, sesudah)
        parts: [
          '', // sebelum blank-1 (kosong karena blank diawal kalimat)
          ', preheat the oven to 180°C and ', // antara blank-1 ↔ blank-2
          ' the tray.', // sesudah blank-2
        ],
        optionsPerBlank: [
          ['First', 'Finally', 'Meanwhile'],
          ['line', 'stir', 'boil'],
        ],
        answers: ['First', 'line'],
      ),

      _GapItem(
        // 1 blank → parts harus 2
        parts: ['Mix the flour and sugar, ', ' add the eggs.'],
        optionsPerBlank: [
          ['then', 'finally', 'warning'],
        ],
        answers: ['then'],
      ),

      _GapItem(
        // 2 blank → parts 3, kosong di awal agar blank menggantikan "____"
        parts: [
          '',
          ', turn off the gas and ',
          ' the pan.',
        ],
        optionsPerBlank: [
          ['Finally', 'First', 'Next'],
          ['unplug', 'remove', 'preheat'],
        ],
        answers: ['Finally', 'remove'],
      ),
    ];


    _items = [..._items]..shuffle(r);
    for (final it in _items) {
      for (final opts in it.optionsPerBlank) { opts.shuffle(r); }
    }
    _selected = List.generate(_items.length, (i) => List.generate(_items[i].answers.length, (j) => null));
    setState(() {});
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

  Widget _inlineDropdown({
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required Color color,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 72), // panjang blank
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black.withValues(alpha:0.35), width: 1),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isDense: true,
            iconSize: 18,
            menuMaxHeight: 320,
            style: primaryTextStyle.copyWith(fontSize: 13),
            hint: const Text(' ', overflow: TextOverflow.ellipsis),
            items: options
                .map((e) => DropdownMenuItem<String>(
                value: e, child: Text(e, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _gapSentence(_GapItem item, List<String?> sel, Color color) {
    final spans = <InlineSpan>[];
    for (int b = 0; b < item.answers.length; b++) {
      // teks sebelum blank-b
      if (item.parts[b].isNotEmpty) {
        spans.add(TextSpan(text: item.parts[b], style: primaryTextStyle));
      }
      // dropdown menggantikan blank
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: _inlineDropdown(
          value: sel[b],
          options: item.optionsPerBlank[b],
          onChanged: (v) => setState(() => sel[b] = v),
          color: color,
        ),
      ));
    }
    // teks sesudah blank terakhir
    if (item.parts.last.isNotEmpty) {
      spans.add(TextSpan(text: item.parts.last, style: primaryTextStyle));
    }

    return Text.rich(
      TextSpan(children: spans),
      softWrap: true,
    );
  }



  @override
  Widget build(BuildContext context) {
    final accent = Colors.deepPurple;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Gap Fill', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(icon: const Icon(Icons.shuffle), onPressed: _initData, tooltip: 'Shuffle'),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _resetSelections, tooltip: 'Reset'),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.extension, text: 'Lengkapi kalimat dengan penanda urutan/kata kerja yang paling natural.'),
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
              Expanded(child: ElevatedButton.icon(onPressed: _submit, icon: const Icon(Icons.check_circle_outline), label: const Text('Submit Skor'))),
              const SizedBox(width: 10),
              OutlinedButton.icon(onPressed: _reveal, icon: const Icon(Icons.visibility), label: const Text('Reveal')),
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
        child: _gapSentence(item, sel, color),
      ),
    );
  }

  Widget _blankDropdown({required String? value, required List<String> options, required ValueChanged<String?> onChanged, required Color color}) {
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
          isExpanded: false,
          menuMaxHeight: 320,
          value: value,
          hint: const Text('…', overflow: TextOverflow.ellipsis),
          items: options.map((e) => DropdownMenuItem<String>(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
