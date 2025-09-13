import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'pronun_practice_shared.dart';

class WordStressGamePage extends StatefulWidget {
  const WordStressGamePage({super.key});

  @override
  State<WordStressGamePage> createState() => _WordStressGamePageState();
}

class _WordStressGamePageState extends State<WordStressGamePage> {
  final r = Random();
  final bank = <StressItem>[
    const StressItem('banana', ['ba','na','na'], 1),
    const StressItem('computer', ['com','pu','ter'], 1),
    const StressItem('photograph', ['pho','to','graph'], 0),
    const StressItem('Japanese', ['Ja','pa','nese'], 2),
    const StressItem('education', ['e','du','ca','tion'], 2),
    const StressItem('interesting', ['in','ter','est','ing'], 0),
  ];
  int idx = 0; int score = 0;

  @override
  void initState() {
    super.initState();
    bank.shuffle(r);
  }

  void _pick(int i) {
    final it = bank[idx];
    final ok = i == it.stress;
    if (ok) score++;

    final stressed = List.generate(it.syl.length, (n) => n == it.stress ? it.syl[n].toUpperCase() : it.syl[n]).join('-');

    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Benar! 🎉' : 'Belum tepat',
      desc: ok ? 'Stress di: ${it.syl[i].toUpperCase()}' : 'Yang benar: $stressed',
      btnOkOnPress: () {
        if (idx < bank.length - 1) {
          setState(() => idx++);
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Selesai',
            desc: 'Skor: $score / ${bank.length}',
            btnOkText: 'Main Lagi',
            btnOkOnPress: () {
              setState(() { idx = 0; score = 0; bank.shuffle(r); });
            },
          ).show();
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final it = bank[idx];
    const color = Colors.orange;
    return Scaffold(
      // appBar: AppBar(title: const Text('Word Stress')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        children: [
          sectionTitle('Tap suku kata yang mendapat STRESS', color),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.grading, text: 'Pilih suku kata yang ditekan.', color: color),
          const SizedBox(height: 10),
          Center(
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                for (int i = 0; i < it.syl.length; i++)
                  ChoiceChip(label: Text(it.syl[i]), selected: false, onSelected: (_) => _pick(i)),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
