import 'dart:math';
import 'package:flutter/material.dart';
import '../gesture_shared.dart';
import 'package:the_pride/theme/theme.dart';

class GestureFlashcardGame extends StatefulWidget {
  const GestureFlashcardGame({super.key});
  @override
  State<GestureFlashcardGame> createState() => _GestureFlashcardGameState();
}

class _GestureFlashcardGameState extends State<GestureFlashcardGame> {
  final r = Random();
  late List<GestureVocab> _cards;
  bool _showBack = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    _cards = List<GestureVocab>.of(kGestureVocab)..shuffle(r);
    _showBack = false; _index = 0; setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final v = _cards[_index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Flashcards', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle))
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () => setState(() => _showBack = !_showBack),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 10, offset: const Offset(0,4))],
                  ),
                  child: _showBack
                      ? _Back(v: v)
                      : _Front(v: v),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _showBack = !_showBack),
                  icon: const Icon(Icons.flip),
                  label: const Text('Flip'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    if (_index < _cards.length - 1) { _index++; _showBack = false; }
                    else { _cards.shuffle(r); _index = 0; _showBack = false; }
                  });
                },
                icon: const Icon(Icons.navigate_next),
                label: const Text('Next'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Front extends StatelessWidget {
  const _Front({required this.v});
  final GestureVocab v;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(v.emoji, style: const TextStyle(fontSize: 72)),
        const SizedBox(height: 12),
        Text(v.term, style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
      ],
    );
  }
}

class _Back extends StatelessWidget {
  const _Back({required this.v});
  final GestureVocab v;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${v.emoji}  ${v.term}', style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 8),
        Text('${v.indo} • ${v.meaning}', style: primaryTextStyle),
        if (v.example != null) ...[
          const SizedBox(height: 6),
          Text('e.g. ${v.example!}', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
        ],
        if (v.note != null) ...[
          const SizedBox(height: 6),
          Text('Note: ${v.note!}', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
        ],
      ],
    );
  }
}
