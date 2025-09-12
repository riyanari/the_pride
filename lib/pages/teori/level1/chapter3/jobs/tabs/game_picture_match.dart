import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/jobs/jobs_shared.dart';
import 'package:the_pride/theme/theme.dart';

enum PicMark { neutral, correct, wrong }

class JobsPictureMatchGame extends StatefulWidget {
  const JobsPictureMatchGame({super.key});

  @override
  State<JobsPictureMatchGame> createState() => _JobsPictureMatchGameState();
}

class _JobsPictureMatchGameState extends State<JobsPictureMatchGame> {
  final r = Random();
  late List<JobVocab> _items;       // subset yang punya gambar
  late List<Choice> _labels;        // pilihan label (EN)
  late Map<String, PicMark> _marks; // key: term
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    final withImg = kJobsVocab.where((v) => v.imageAsset != null).toList()..shuffle(r);
    _items = withImg.take(8).toList(); // grid 2x4
    int id = 1;
    _labels = _items.map((v) => Choice(id: id++, text: v.term, key: v.term)).toList()..shuffle(r);
    _marks = {for (final v in _items) v.term: PicMark.neutral};
    _selectedId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.brown;
    final width = MediaQuery.of(context).size.width;
    final narrow = width < 380;
    final cross = narrow ? 2 : 4;
    final extent = 140.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Picture Match', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.image, text: 'Pilih LABEL (chips) lalu ketuk GAMBAR yang sesuai.'),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              itemCount: _items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cross,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: extent,
              ),
              itemBuilder: (_, i) {
                final v = _items[i];
                final mark = _marks[v.term] ?? PicMark.neutral;
                Color border, overlay = Colors.transparent;
                switch (mark) {
                  case PicMark.correct: border = Colors.green; overlay = Colors.green.withValues(alpha:0.08); break;
                  case PicMark.wrong:   border = Colors.red;   overlay = Colors.red.withValues(alpha:0.08);   break;
                  case PicMark.neutral: border = Colors.grey.withValues(alpha:0.3); break;
                }
                return InkWell(
                  onTap: () => _onTap(v),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: v.imageAsset != null
                              ? Image.asset(v.imageAsset!, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.image))))
                              : Container(color: Colors.grey[100]),
                        ),
                        Container(decoration: BoxDecoration(color: overlay, borderRadius: BorderRadius.circular(12))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text('Pilih label:', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in _labels)
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

  void _onTap(JobVocab v) {
    if (_selectedId == null) return;
    final choice = _labels.firstWhere((e) => e.id == _selectedId);
    final correct = choice.key == v.term;
    setState(() => _marks[v.term] = correct ? PicMark.correct : PicMark.wrong);
    if (correct) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Benar',
        desc: '“${v.term}” → ${v.indo}\n${v.example}',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
