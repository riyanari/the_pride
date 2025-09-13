import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';
import 'pronun_practice_shared.dart';

class MinimalPairsGamePage extends StatefulWidget {
  final AudioService audioService;
  const MinimalPairsGamePage({super.key, required this.audioService});

  @override
  State<MinimalPairsGamePage> createState() => _MinimalPairsGamePageState();
}

class _MinimalPairsGamePageState extends State<MinimalPairsGamePage> {
  final r = Random();
  final pairs = <MinimalPair>[
    const MinimalPair(aWord: 'ship', bWord: 'sheep', contrast: '/ɪ/ vs /iː/',
        aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    const MinimalPair(aWord: 'full', bWord: 'fool', contrast: '/ʊ/ vs /uː/',
        aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    const MinimalPair(aWord: 'bet', bWord: 'bat', contrast: '/e/ vs /æ/',
        aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
    const MinimalPair(aWord: 'cot', bWord: 'caught', contrast: '/ɒ/ vs /ɔː/',
        aAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        bAudio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  ];

  int idx = 0;
  bool playA = true;
  int score = 0;

  @override
  void initState() {
    super.initState();
    pairs.shuffle(r);
    playA = r.nextBool();
  }

  void _play() {
    final p = pairs[idx];
    widget.audioService.playSound(playA ? p.aAudio : p.bAudio);
  }

  void _answer(bool chooseA) {
    final p = pairs[idx];
    final ok = (chooseA && playA) || (!chooseA && !playA);
    if (ok) score++;

    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Benar! 🎉' : 'Belum tepat',
      desc: ok
          ? 'Kamu mendengar: ${playA ? p.aWord : p.bWord} (${p.contrast})'
          : 'Jawaban benar: ${playA ? p.aWord : p.bWord} (${p.contrast})',
      btnOkOnPress: () {
        if (idx < pairs.length - 1) {
          setState(() { idx++; playA = r.nextBool(); });
          _play();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Selesai',
            desc: 'Skor: $score / ${pairs.length}',
            btnOkText: 'Main Lagi',
            btnOkOnPress: () {
              setState(() { score = 0; idx = 0; pairs.shuffle(r); playA = r.nextBool(); });
              _play();
            },
          ).show();
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final p = pairs[idx];
    const color = Colors.indigo;
    return Scaffold(
      // appBar: AppBar(title: const Text('Minimal Pairs')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        children: [
          sectionTitle('Listen & Choose', color),
          const SizedBox(height: 6),
          infoBadge(icon: Icons.hearing, text: 'Dengar audio, lalu pilih kata yang kamu dengar. Kontras: ${p.contrast}', color: color),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: _play, icon: const Icon(Icons.volume_up), label: const Text('Play'))),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: color.withValues(alpha:0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha:0.25))),
                child: Text('Skor: $score', style: primaryTextStyle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10, runSpacing: 10, alignment: WrapAlignment.center,
            children: [bigChoiceButton(p.aWord, () => _answer(true)), bigChoiceButton(p.bWord, () => _answer(false))],
          ),
        ],
      ),
    );
  }
}
