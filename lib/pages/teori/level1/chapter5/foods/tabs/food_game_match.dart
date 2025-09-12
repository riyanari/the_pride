import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../food_shared.dart';

enum Mark { neutral, correct, wrong }

class FoodMatchGame extends StatefulWidget {
  const FoodMatchGame({super.key});
  @override
  State<FoodMatchGame> createState() => _FoodMatchGameState();
}

class _FoodMatchGameState extends State<FoodMatchGame> {
  final r = Random();
  late List<Pair> _pairs;
  late List<Choice> _choices;
  late Map<String, Mark> _marks;
  int? _selected;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    final pool = List<FoodVocab>.of(kFoodVocab)..shuffle(r);
    final take = pool.where((v) => v.category != C_TASTE && v.category != C_COOK).take(12).toList();
    _pairs = take.map((v) => Pair(left: v.term, right: v.indo, explain: '“${v.term}” berarti “${v.indo}”.')).toList();

    int id = 1;
    _choices = _pairs.map((p) => Choice(id: id++, text: p.right, key: p.left)).toList()..shuffle(r);
    _marks = {for (final p in _pairs) p.left: Mark.neutral};
    _selected = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.deepOrange;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Quick Match', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.touch_app, text: 'Pilih arti (chips) lalu ketuk KARTU kosakata bahasa Inggris yang cocok.'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _pairs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final p = _pairs[i];
                final m = _marks[p.left]!;
                Color border, bg;
                switch (m) {
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
                      trailing: Icon(Icons.restaurant, color: color),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih arti:', style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          // wrap (grid-ish) supaya tidak perlu scroll horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in _choices)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c.text),
                      selected: _selected == c.id,
                      onSelected: (_) => setState(() => _selected = c.id),
                      selectedColor: color.withValues(alpha:0.2),
                    ),
                  ),
              ],
            ),
          ),
          // Wrap(
          //   spacing: 8, runSpacing: 8,
          //   children: [
          //     for (final c in _choices)
          //       ChoiceChip(
          //         label: Text(c.text),
          //         selected: _selected == c.id,
          //         onSelected: (_) => setState(() => _selected = c.id),
          //         selectedColor: color.withValues(alpha:0.2),
          //       ),
          //   ],
          // ),
        ],
      ),
    );
  }

  void _onTap(Pair p) {
    if (_selected == null) return;
    final choice = _choices.firstWhere((e) => e.id == _selected);
    final ok = choice.key == p.left;
    setState(() => _marks[p.left] = ok ? Mark.correct : Mark.wrong);
    if (ok) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Benar',
        desc: p.explain,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
