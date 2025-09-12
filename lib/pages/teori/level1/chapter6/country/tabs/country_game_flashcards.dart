import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../country_shared.dart';

class CountryFlashcardGame extends StatefulWidget {
  const CountryFlashcardGame({super.key});
  @override
  State<CountryFlashcardGame> createState() => _CountryFlashcardGameState();
}

class _CountryFlashcardGameState extends State<CountryFlashcardGame> {
  final r = Random();
  late List<CountryVocab> _deck;
  int _i = 0;
  int _known = 0;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    _deck = List<CountryVocab>.of(kCountryVocab)..shuffle(r);
    _deck = _deck.take(20).toList();
    _i = 0; _known = 0; _showBack = false;
    setState((){});
  }

  void _next({required bool known}) {
    if (known) _known++;
    if (_i < _deck.length - 1) {
      setState(() { _i++; _showBack = false; });
    } else {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('Selesai'),
        content: Text('Kamu menandai hafal: $_known / ${_deck.length}'),
        actions: [
          TextButton(onPressed: (){ Navigator.pop(context); _setup(); }, child: const Text('Main Lagi')),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.green;
    final v = _deck[_i];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Flashcards', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha:0.25)),
                ),
                child: Text('${_i+1}/${_deck.length} • Known: $_known', style: primaryTextStyle),
              ),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () => setState(() => _showBack = !_showBack),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 480, minHeight: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withValues(alpha:0.25)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
                  ),
                  child: _showBack
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Text(v.flag, style: const TextStyle(fontSize: 28)), const SizedBox(width: 10), Text(v.indo, style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 18))]),
                      const SizedBox(height: 6),
                      Text('Nationality: ${v.nationality}', style: primaryTextStyle),
                      Text('Language: ${v.language}', style: primaryTextStyle),
                      Text('Capital: ${v.capital}', style: primaryTextStyle),
                      if (v.ipa != null) Text(v.ipa!, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                      const Spacer(),
                      Align(alignment: Alignment.bottomRight, child: Text('(tap to flip back)', style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[600]))),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Text(v.flag, style: const TextStyle(fontSize: 28)), const SizedBox(width: 10), Text(v.country, style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 20))]),
                      Text(v.region, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
                      const Spacer(),
                      Align(alignment: Alignment.bottomRight, child: Text('(tap to reveal details)', style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[600]))),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _next(known: false),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Belum Hafal"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _next(known: true),
                  icon: const Icon(Icons.check),
                  label: const Text("Sudah Hafal"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
