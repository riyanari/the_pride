import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../color_shared.dart';

enum Mark { neutral, correct, wrong }

class ColorMatchGame extends StatefulWidget {
  const ColorMatchGame({super.key});
  @override
  State<ColorMatchGame> createState() => _ColorMatchGameState();
}

class _ColorMatchGameState extends State<ColorMatchGame> {
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
    final pool = List<ColorVocab>.of(kColorVocab.where((v)=>v.hex!=null && (v.category==C_BASIC || v.category==C_EXT)))..shuffle(r);
    final take = pool.take(12).toList();
    _pairs = take.map((v) => Pair(
      left: v.term,
      right: v.hex!.toRadixString(16),
      explain: '“${v.term}” = “${v.indo}”.',
    )).toList();

    int id = 1;
    _choices = _pairs.map((p) => Choice(id: id++, text: p.left, key: p.right)).toList()..shuffle(r);
    _marks = {for (final p in _pairs) p.right: Mark.neutral};
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
              Expanded(child: Text('Quick Match (Name → Swatch)', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.touch_app, text: 'Pilih NAMA warna (chips), lalu ketuk KARTU swatch yang cocok.'),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              itemCount: _pairs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.6,
              ),
              itemBuilder: (_, i) {
                final p = _pairs[i];
                final mark = _marks[p.right] ?? Mark.neutral;
                Color border, bg;
                switch (mark) {
                  case Mark.correct: border = Colors.green; bg = Colors.green.withValues(alpha:0.08); break;
                  case Mark.wrong:   border = Colors.red;   bg = Colors.red.withValues(alpha:0.08);   break;
                  case Mark.neutral: border = Colors.grey.withValues(alpha:0.3); bg = Colors.white;    break;
                }
                final hexInt = int.parse(p.right, radix:16);
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
                      leading: Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(
                          color: Color(hexInt | 0xFF000000),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.black.withValues(alpha:0.08)),
                        ),
                      ),
                      title: Text('Tap swatch', style: primaryTextStyle.copyWith(fontSize: 12)),
                      // trailing: Icon(Icons.palette, color: color, size: 10,),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih nama:', style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700)),
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
    final ok = choice.key == p.right;
    setState(() => _marks[p.right] = ok ? Mark.correct : Mark.wrong);
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
