import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../auxv_shared.dart';

class AuxVFlashcardGame extends StatefulWidget {
  const AuxVFlashcardGame({super.key});
  @override
  State<AuxVFlashcardGame> createState() => _AuxVFlashcardGameState();
}

class _AuxVFlashcardGameState extends State<AuxVFlashcardGame> {
  late List<AuxVocab> _queue;
  int _index = 0;
  int _known = 0;

  @override
  void initState() { super.initState(); _reset(); }

  void _reset() {
    _queue = List<AuxVocab>.of(kAuxVocab)..shuffle();
    _index = 0; _known = 0; setState((){});
  }

  void _markKnown() {
    if (_queue.isEmpty) return;
    setState(() { _queue.removeAt(_index); _known++; });
    if (_queue.isEmpty) return;
    _index = _index.clamp(0, _queue.length - 1);
  }

  void _markUnknown() {
    if (_queue.isEmpty) return;
    setState(() {
      final v = _queue.removeAt(_index);
      _queue.add(v);
      _index = _index.clamp(0, _queue.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.indigo;
    final v = _queue.isEmpty ? null : _queue[_index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Flashcards', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: accent.withValues(alpha:0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: accent.withValues(alpha:0.25))),
                child: Text('Hafal: $_known / ${kAuxVocab.length}', style: primaryTextStyle),
              ),
              IconButton(onPressed: _reset, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: v == null
                ? Center(child: Text('Selesai! 🎉', style: primaryTextStyle))
                : _FlipCard(v: v),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _markKnown,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Sudah hafal'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _markUnknown,
                icon: const Icon(Icons.refresh),
                label: const Text('Belum hafal'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlipCard extends StatefulWidget {
  final AuxVocab v;
  const _FlipCard({required this.v});
  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> {
  bool _front = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _front = !_front),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
        ),
        child: Center(
          child: _front
              ? Text(widget.v.aux.toUpperCase(), style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.v.forms, style: primaryTextStyle, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Text(widget.v.function, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700]), textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis),
              if (widget.v.example != null) ...[
                const SizedBox(height: 8),
                Text('e.g. ${widget.v.example!}', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700]), textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
