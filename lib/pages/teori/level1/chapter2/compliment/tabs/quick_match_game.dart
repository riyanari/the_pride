import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

import '../compliment_shared.dart';

enum Mark { neutral, correct, wrong }

class QuickMatchGame extends StatefulWidget {
  const QuickMatchGame({super.key});

  @override
  State<QuickMatchGame> createState() => _QuickMatchGameState();
}

class _QuickMatchGameState extends State<QuickMatchGame> {
  final _rand = Random();

  late List<Pair> _pairs = const [
    Pair(
      id: 1,
      compliment: 'Great presentation today!',
      responses: ['Thanks! I really appreciate it.', 'Thank you—glad it was clear.'],
      explain: 'Balasan singkat + apresiasi; boleh tambah detail kecil.',
    ),
    Pair(
      id: 2,
      compliment: 'I love your idea.',
      responses: ['Thanks! I\'m happy you liked it.', 'Thank you—let\'s refine it together.'],
      explain: 'Terima kasih + ajakan/lanjutan kolaborasi juga cocok.',
    ),
    Pair(
      id: 3,
      compliment: 'You did a fantastic job on this report.',
      responses: ['Thank you. The team helped a lot.', 'Thanks—your feedback was super helpful.'],
      explain: 'Boleh memberikan kredit ke tim/penilai.',
    ),
    Pair(
      id: 4,
      compliment: 'Nice outfit!',
      responses: ['Thanks!', 'Thank you—got it as a gift.'],
      explain: 'Topik penampilan: jaga tetap ringan & ramah.',
    ),
  ];

  late List<Choice> _choices;
  int? _selectedChoiceId;
  late Map<int, Mark> _marks;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _marks = {for (final p in _pairs) p.id: Mark.neutral};
    final all = <Choice>[];
    int rid = 1;
    for (final p in _pairs) {
      for (final r in p.responses) {
        all.add(Choice(id: rid++, text: r, pairId: p.id));
      }
    }
    all.shuffle(_rand);
    _choices = all;
    _selectedChoiceId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.indigo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Quick Match', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              IconButton(onPressed: () { _pairs = [..._pairs]..shuffle(_rand); _reset(); }, icon: Icon(Icons.shuffle, color: color)),
              IconButton(onPressed: _reset, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.touch_app, text: 'Pilih RESPON (chips) di bawah, lalu klik kartu KOMPLIMEN yang cocok.'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _pairs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final p = _pairs[i];
                final mark = _marks[p.id] ?? Mark.neutral;
                Color border; Color bg;
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
                      title: Text(p.compliment, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                      trailing: Icon(Icons.chat_bubble_outline, color: color),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih respon:', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
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
                      selected: _selectedChoiceId == c.id,
                      onSelected: (_) => setState(() => _selectedChoiceId = c.id),
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
    if (_selectedChoiceId == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        title: 'Pilih respon dulu',
        desc: 'Tap salah satu respon di bawah, lalu klik komlimen yang ingin kamu jawab.',
        btnOkOnPress: () {},
      ).show();
      return;
    }
    final choice = _choices.firstWhere((e) => e.id == _selectedChoiceId);
    final correct = choice.pairId == p.id;
    setState(() => _marks[p.id] = correct ? Mark.correct : Mark.wrong);
    if (correct) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Nice!',
        desc: p.explain,
        btnOkOnPress: () {},
      ).show();
    }
  }
}
