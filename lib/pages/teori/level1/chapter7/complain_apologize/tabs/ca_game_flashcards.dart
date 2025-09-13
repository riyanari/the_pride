import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../compapo_shared.dart';

class CompApoFlashcardGame extends StatefulWidget {
  const CompApoFlashcardGame({super.key});
  @override
  State<CompApoFlashcardGame> createState() => _CompApoFlashcardGameState();
}

class _CompApoFlashcardGameState extends State<CompApoFlashcardGame> {
  late List<CompApoVocab> _queue;     // antrian kartu yang belum hafal
  final PageController _ctrl = PageController();
  int _index = 0;                      // posisi halaman saat ini
  int _known = 0;                      // jumlah yang sudah hafal
  int _total = 0;                      // total awal

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _queue = List<CompApoVocab>.of(kCompApoVocab)..shuffle();
    _index = 0;
    _known = 0;
    _total = _queue.length;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ctrl.hasClients) _ctrl.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _markKnown() {
    if (_queue.isEmpty) return;
    final removeAt = _index;
    setState(() {
      _queue.removeAt(removeAt);
      _known++;
    });

    if (_queue.isEmpty) {
      // selesai
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Selesai 🎉'),
          content: Text('Kamu hafal semua!\nSkor: $_known / $_total'),
          actions: [
            TextButton(onPressed: () { Navigator.pop(context); _reset(); }, child: const Text('Main Lagi')),
          ],
        ),
      );
      return;
    }

    // sesuaikan halaman aman
    final nextIndex = removeAt.clamp(0, _queue.length - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ctrl.hasClients) _ctrl.jumpToPage(nextIndex);
    });
  }

  void _markUnknown() {
    if (_queue.isEmpty) return;
    setState(() {
      final card = _queue.removeAt(_index);
      _queue.add(card);              // kirim ke belakang
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ctrl.hasClients) _ctrl.jumpToPage(_index.clamp(0, _queue.length - 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.indigo;

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
                  color: accent.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent.withValues(alpha:0.25)),
                ),
                child: Text('Hafal: $_known / $_total', style: primaryTextStyle),
              ),
              IconButton(
                tooltip: 'Reset & Acak Ulang',
                onPressed: _reset,
                icon: const Icon(Icons.shuffle),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _queue.isEmpty
                ? Center(child: Text('Semua kartu sudah selesai! 🎉', style: primaryTextStyle))
                : PageView.builder(
              controller: _ctrl,
              itemCount: _queue.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => _FlipCard(v: _queue[i]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _markKnown,
                  icon: const Icon(Icons.check_circle_outline, color: kPrimaryColor,),
                  label: Text('Sudah hafal', style: primaryTextStyle,),
                  // style: ElevatedButton.styleFrom(backgroundColor: kSecondaryColor),
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
  final CompApoVocab v;
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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Center(
          child: _front
              ? Text(
            widget.v.phrase,
            style: primaryTextStyle.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.v.indo,
                style: primaryTextStyle,
                textAlign: TextAlign.center,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.v.example != null) ...[
                const SizedBox(height: 8),
                Text(
                  'e.g. ${widget.v.example!}',
                  style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
