import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/pages/teori/level1/chapter4/times/time_shared.dart';

enum Mark { neutral, correct, wrong }

class TimeMatchGame extends StatefulWidget {
  const TimeMatchGame({super.key});
  @override
  State<TimeMatchGame> createState() => _TimeMatchGameState();
}

class _TimeMatchGameState extends State<TimeMatchGame> {
  final r = Random();
  late List<Pair> _pairs;
  late List<Choice> _choices;
  late Map<String, Mark> _marks;
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    final times = <(int h, int m)>[
      (7,0),(7,5),(7,10),(7,15),(7,20),(7,25),(7,30),(7,35),(7,40),(7,45),(7,50),(7,55),
      (12,0),(0,0),(5,15),(9,45),(3,30),(10,20),
    ]..shuffle(r);

    final take = times.take(12).toList();
    _pairs = take.map((t){
      final hh = twoDigits(t.$1);
      final mm = twoDigits(t.$2);
      final digital = '$hh:$mm';
      final phrase = timePhrase(t.$1, t.$2);
      return Pair(left: digital, right: phrase, explain: '$digital dibaca: “$phrase”.');
    }).toList();

    int id = 1;
    _choices = _pairs.map((p) => Choice(id: id++, text: p.right, key: p.left)).toList()..shuffle(r);
    _marks = {for (final p in _pairs) p.left: Mark.neutral};
    _selectedId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.indigo;
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
          infoBadge(icon: Icons.touch_app, text: 'Pilih FRASA (chips), lalu ketuk KARTU jam digital yang cocok.'),
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
                      trailing: Icon(Icons.access_time, color: color),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih frasa:', style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          // chip wrap (grid-ish)
          // Wrap(
          //   spacing: 8, runSpacing: 8,
          //   children: [
          //     for (final c in _choices)
          //       ChoiceChip(
          //         label: Text(c.text),
          //         selected: _selectedId == c.id,
          //         onSelected: (_) => setState(() => _selectedId = c.id),
          //         selectedColor: color.withValues(alpha:0.2),
          //       ),
          //   ],
          // ),
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
