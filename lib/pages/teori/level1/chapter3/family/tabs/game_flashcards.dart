import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/family_shared.dart';
import 'package:the_pride/theme/theme.dart';

class FamilyFlashcardsGame extends StatefulWidget {
  const FamilyFlashcardsGame({super.key});

  @override
  State<FamilyFlashcardsGame> createState() => _FamilyFlashcardsGameState();
}

class _FamilyFlashcardsGameState extends State<FamilyFlashcardsGame> {
  final rand = Random();
  late List<FamilyVocab> _queue;
  int _idx = 0;
  bool _showBack = false;
  int _know = 0, _again = 0;

  @override
  void initState() {
    super.initState();
    _queue = [...kFamilyVocab]..shuffle(rand);
  }

  void _onKnow() {
    setState(() {
      _know++;
      _showBack = false;
      _queue.removeAt(_idx);
      if (_queue.isEmpty) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Selesai!',
          desc: 'Kata dikuasai: $_know • Ulangi: $_again',
          btnOkOnPress: () {},
        ).show();
      } else if (_idx >= _queue.length) {
        _idx = 0;
      }
    });
  }

  void _onAgain() {
    setState(() {
      _again++;
      final item = _queue.removeAt(_idx);
      _queue.add(item); // kirim ke belakang
      _showBack = false;
      if (_idx >= _queue.length) _idx = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.indigo;
    final empty = _queue.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Flashcards', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              Text('Know: $_know  •  Again: $_again', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 10),
          if (empty)
            Center(child: Text('Semua kartu selesai 🎉', style: primaryTextStyle))
          else
            _card(color, _queue[_idx]),
          const SizedBox(height: 12),
          if (!empty)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _showBack = !_showBack),
                    icon: const Icon(Icons.flip),
                    label: Text(_showBack ? 'Tutup Arti' : 'Lihat Arti'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _onAgain,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Again'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _onKnow,
                  icon: const Icon(Icons.check),
                  label: const Text('Know'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _card(Color color, FamilyVocab v) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha:0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 8, offset: const Offset(0,2))],
      ),
      child: InkWell(
        onTap: () => setState(() => _showBack = !_showBack),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _showBack ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Center(child: Text(v.term, style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold))),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${v.term} → ${v.indo}', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                const SizedBox(height: 8),
                Text(v.example, style: primaryTextStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
