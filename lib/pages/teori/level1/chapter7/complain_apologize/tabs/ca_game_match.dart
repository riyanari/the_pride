import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../compapo_shared.dart';

enum Mark { neutral, correct, wrong }

class CompApoMatchGame extends StatefulWidget {
  const CompApoMatchGame({super.key});

  @override
  State<CompApoMatchGame> createState() => _CompApoMatchGameState();
}

class _CompApoMatchGameState extends State<CompApoMatchGame> {
  final r = Random();
  late List<Pair> _pairs;
  late List<Choice> _choices;
  late Map<String, Mark> _marks;
  int? _selectedId;

  @override
  void initState() { super.initState(); _setup(); }

  void _setup() {
    final sample = <Pair>[
      const Pair(left: "I'm afraid there's a problem with my order.", right: "I'm really sorry for the inconvenience.", explain: 'Keluhan → permintaan maaf.'),
      const Pair(left: "The service is taking too long.", right: "Let me speed this up for you.", explain: 'Keluhan → solusi.'),
      const Pair(left: "This item arrived damaged.", right: "We can issue a refund or replacement.", explain: 'Masalah barang → tawaran solusi.'),
      const Pair(left: "Could you possibly check it now?", right: "Sure, I\'ll check it right away.", explain: 'Permintaan sopan → persetujuan.'),
    ]..shuffle(r);

    _pairs = sample;
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
          infoBadge(icon: Icons.touch_app, text: 'Pilih RESPON (chips), lalu ketuk KELUHAN yang cocok.'),
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
                      trailing: Icon(Icons.chat_bubble_outline, color: color),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih respon:', style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
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
