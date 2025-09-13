import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'pronun_practice_shared.dart';

class SyllableCountGamePage extends StatefulWidget {
  const SyllableCountGamePage({super.key});

  @override
  State<SyllableCountGamePage> createState() => _SyllableCountGamePageState();
}

class _SyllableCountGamePageState extends State<SyllableCountGamePage> {
  final r = Random();
  final items = <SyllableItem>[
    const SyllableItem('cat', 1),
    const SyllableItem('table', 2),
    const SyllableItem('computer', 3),
    const SyllableItem('photograph', 3),
    const SyllableItem('banana', 3),
    const SyllableItem('university', 5),
  ];
  int idx = 0; int score = 0;

  @override
  void initState() {
    super.initState();
    items.shuffle(r);
  }

  void _answer(int n) {
    final it = items[idx];
    final ok = n == it.count;
    if (ok) score++;

    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Benar! 🎉' : 'Belum tepat',
      desc: ok ? 'Jumlah suku kata: ${it.count}' : 'Yang benar: ${it.count}',
      btnOkOnPress: () {
        if (idx < items.length - 1) {
          setState(() => idx++);
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Selesai',
            desc: 'Skor: $score / ${items.length}',
            btnOkText: 'Main Lagi',
            btnOkOnPress: () {
              setState(() { score = 0; idx = 0; items.shuffle(r); });
            },
          ).show();
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final it = items[idx];
    const color = Colors.deepPurple;
    return Scaffold(
      // appBar: AppBar(title: const Text('Syllable Count')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        children: [
          sectionTitle('Tentukan jumlah suku kata', color),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.touch_app, text: 'Pilih jumlah suku kata untuk kata di bawah.', color: color),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha:0.25)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 6, offset: const Offset(0,2))]),
            child: Center(child: Text(it.word, style: primaryTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10, runSpacing: 10, alignment: WrapAlignment.center,
            children: List.generate(6, (i) => i + 1)
                .map((n) => ChoiceChip(label: Text('$n syllable${n==1?'':'s'}'), selected: false, onSelected: (_) => _answer(n))).toList(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: color.withValues(alpha:0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha:0.25))),
              child: Text('Skor: $score', style: primaryTextStyle),
            ),
          ),
        ],
      ),
    );
  }
}
