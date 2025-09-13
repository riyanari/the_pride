import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../question_shared.dart';

enum Mark { neutral, correct, wrong }

class QuestionMatchGame extends StatefulWidget {
  const QuestionMatchGame({super.key});
  @override
  State<QuestionMatchGame> createState() => _QuestionMatchGameState();
}

class _QuestionMatchGameState extends State<QuestionMatchGame> {
  final r = Random();
  late List<Pair> _pairs;
  late List<Choice> _choices;
  late Map<String, Mark> _marks;
  int? _selectedId;

  @override
  void initState() { super.initState(); _setup(); }

  void _setup() {
    final pool = [...kQWVocab]..shuffle(r);
    final take = pool.take(12).toList();
    _pairs = take.map((v) => Pair(left: v.word, right: v.indo, explain: '“${v.word}” artinya “${v.indo}”.')).toList();

    int id = 1;
    _choices = take.map((v) => Choice(id: id++, text: v.indo, key: v.word)).toList()..shuffle(r);
    _marks = {for (final p in _pairs) p.left: Mark.neutral};
    _selectedId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.deepPurple;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Quick Match', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.touch_app, text: 'Pilih ARTI (chips), lalu ketuk KARTU question word yang cocok.'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _pairs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final p = _pairs[i];
                final mark = _marks[p.left] ?? Mark.neutral;
                Color border, bg;
                switch (mark) {
                  case Mark.correct: border = Colors.green; bg = Colors.green.withValues(alpha:0.08); break;
                  case Mark.wrong:   border = Colors.red;   bg = Colors.red.withValues(alpha:0.08);   break;
                  case Mark.neutral: border = Colors.grey.withValues(alpha:0.3); bg = Colors.white;    break;
                }
                return InkWell(
                  onTap: () => _onTap(p),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
                    ),
                    child: ListTile(
                      title: Text(p.left, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                      trailing: Icon(Icons.help_outline, color: color),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih arti:', style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in _choices)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c.text),
                      selected: _selectedId == c.id,
                      onSelected: (_) => setState(() => _selectedId = c.id),
                      selectedColor: color.withValues(alpha:0.2),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(Pair p) {
    if (_selectedId == null) return;
    final choice = _choices.firstWhere((e) => e.id == _selectedId);
    final correct = choice.key == p.left;
    setState(() => _marks[p.left] = correct ? Mark.correct : Mark.wrong);
    if (correct) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(p.explain)));
    }
  }
}
