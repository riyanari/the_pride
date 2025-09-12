import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../country_shared.dart';

enum Mark { neutral, correct, wrong }

class CountryMatchGame extends StatefulWidget {
  const CountryMatchGame({super.key});
  @override
  State<CountryMatchGame> createState() => _CountryMatchGameState();
}

class _CountryMatchGameState extends State<CountryMatchGame> {
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
    final pool = List<CountryVocab>.of(kCountryVocab)..shuffle(r);
    final take = pool.take(12).toList();
    _pairs = take.map((v) => Pair(
      left: v.country,                       // kartu yang diklik
      right: v.nationality,                  // jawaban benar untuk kartu tsb
      explain: 'People from ${v.country} are “${v.nationality}”.',
    )).toList();

    int id = 1;
    _choices = _pairs.map((p) => Choice(id: id++, text: p.right, key: p.left)).toList()..shuffle(r);
    _marks = {for (final p in _pairs) p.left: Mark.neutral};
    _selected = null;
    setState((){});
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
              Expanded(child: Text('Quick Match (Nationality → Country)', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.touch_app, text: 'Pilih NATIONALITY (chips), lalu ketuk KARTU negara yang cocok.'),
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
                final flag = kCountryVocab.firstWhere((e)=>e.country==p.left).flag;
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
                      leading: Text(flag, style: const TextStyle(fontSize: 24)),
                      title: Text(p.left, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                      trailing: Icon(Icons.public, color: color),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih nationality:', style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
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
