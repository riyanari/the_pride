import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../procedures_shared.dart';

class ProcFlashcardGame extends StatefulWidget {
  const ProcFlashcardGame({super.key});
  @override
  State<ProcFlashcardGame> createState() => _ProcFlashcardGameState();
}

class _ProcFlashcardGameState extends State<ProcFlashcardGame> {
  final _items = kProcVocab;
  final _ctrl = PageController();
  int _known = 0, _unknown = 0;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _mark(bool know) {
    setState(() {
      if (know) _known++; else _unknown++;
    });
    if (_ctrl.hasClients) {
      _ctrl.nextPage(duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Text('Flashcards (tap to reveal meaning)', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Sudah hafal: $_known   •   Belum: $_unknown', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Expanded(
            child: PageView.builder(
              controller: _ctrl,
              itemCount: _items.length,
              itemBuilder: (_, i) => _FlipCard(v: _items[i]),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => _mark(false), icon: const Icon(Icons.close), label: const Text('Belum Hafal'))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton.icon(onPressed: () => _mark(true), icon: const Icon(Icons.check), label: const Text('Sudah Hafal'))),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlipCard extends StatefulWidget {
  final ProcVocab v;
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
        ),
        child: Center(
          child: _front
              ? Text(widget.v.term, style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center, maxLines: 6, overflow: TextOverflow.ellipsis)
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.v.indo, style: primaryTextStyle, textAlign: TextAlign.center, maxLines: 6, overflow: TextOverflow.ellipsis),
              if (widget.v.example != null) ...[
                const SizedBox(height: 8),
                Text('e.g. ${widget.v.example!}', style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700]), textAlign: TextAlign.center, maxLines: 5, overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
