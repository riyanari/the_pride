import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import '../sugreq_shared.dart';

class SugReqFlashcardGame extends StatefulWidget {
  const SugReqFlashcardGame({super.key});
  @override
  State<SugReqFlashcardGame> createState() => _SugReqFlashcardGameState();
}

class _SugReqFlashcardGameState extends State<SugReqFlashcardGame> {
  final _all = kSugReqVocab;
  final _ctrl = PageController();

  late List<int> _order;
  int _current = 0;

  final Set<int> _known = {};
  final Set<int> _dontKnow = {};

  bool _reviewUnknownOnly = false;

  @override
  void initState() {
    super.initState();
    _resetAll(shuffle: false);

    // Pastikan controller sudah attached sebelum loncat ke halaman mana pun
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToFirstSafely());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _jumpToFirstSafely() {
    if (!mounted) return;
    if (_ctrl.hasClients && _order.isNotEmpty) {
      _ctrl.jumpToPage(0);
    }
  }

  void _postFrameJumpToFirst() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToFirstSafely());
  }

  void _resetAll({bool shuffle = true}) {
    _known.clear();
    _dontKnow.clear();
    _order = List<int>.generate(_all.length, (i) => i);
    if (shuffle) _order.shuffle();
    _current = 0;
    setState(() {});
    _postFrameJumpToFirst();
  }

  void _shuffle() {
    _order.shuffle();
    _current = 0;
    setState(() {});
    _postFrameJumpToFirst();
  }

  void _toggleReviewUnknown(bool v) {
    _reviewUnknownOnly = v;
    if (_reviewUnknownOnly) {
      _order = _dontKnow.isEmpty ? <int>[] : _dontKnow.toList();
    } else {
      _order = List<int>.generate(_all.length, (i) => i);
    }
    _current = 0;
    setState(() {});
    _postFrameJumpToFirst();
  }

  void _mark(bool known) {
    if (_order.isEmpty) return;
    final idx = _order[_current];
    if (known) {
      _known.add(idx);
      _dontKnow.remove(idx);
    } else {
      _dontKnow.add(idx);
      _known.remove(idx);
    }

    if (_current < _order.length - 1) {
      _current++;
      if (_ctrl.hasClients) {
        _ctrl.nextPage(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
      setState(() {});
    } else {
      _showSummaryDialog();
    }
  }

  void _showSummaryDialog() {
    final total = _all.length;
    final known = _known.length;
    final unknown = total - known;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ringkasan'),
        content: Text('Sudah hafal: $known\nBelum hafal: $unknown\nTotal: $total'),
        actions: [
          if (_dontKnow.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _toggleReviewUnknown(true);
              },
              child: const Text('Review Belum Hafal'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetAll(shuffle: true);
            },
            child: const Text('Main Lagi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showList = _order;
    // final color = Colors.indigo;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Flashcards',
                    style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              _statChip('Hafal: ${_known.length}', Colors.green),
              const SizedBox(width: 6),
              _statChip('Belum: ${_all.length - _known.length}', Colors.orange),
              IconButton(
                tooltip: 'Shuffle',
                onPressed: _shuffle,
                icon: const Icon(Icons.shuffle),
              ),
              IconButton(
                tooltip: 'Reset',
                onPressed: () => _resetAll(shuffle: true),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              FilterChip(
                label: const Text('Review Belum Hafal'),
                selected: _reviewUnknownOnly,
                onSelected: (v) => _toggleReviewUnknown(v),
              ),
              const Spacer(),
              if (showList.isNotEmpty)
                Text('${_current + 1}/${showList.length}', style: primaryTextStyle.copyWith(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: showList.isEmpty
                ? _emptyState()
                : PageView.builder(
              controller: _ctrl,
              onPageChanged: (p) => setState(() => _current = p),
              itemCount: showList.length,
              itemBuilder: (_, i) {
                final v = _all[showList[i]];
                return _FlipCard(key: ValueKey(showList[i]), v: v);
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _mark(false),
                  icon: const Icon(Icons.thumb_down_alt_outlined),
                  label: const Text('Belum hafal'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _mark(true),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Sudah hafal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String text, Color c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha:0.25)),
      ),
      child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12)),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: Colors.grey),
          const SizedBox(height: 6),
          Text(
            _reviewUnknownOnly
                ? 'Tidak ada kartu “Belum Hafal”. Matikan filter untuk melihat semua.'
                : 'Tidak ada data.',
            style: primaryTextStyle.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class _FlipCard extends StatefulWidget {
  final SugReqVocab v;
  const _FlipCard({super.key, required this.v});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> {
  bool _front = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Kartu
        GestureDetector(
          onTap: () => setState(() => _front = !_front),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
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
        ),

        // Hint “tap to reveal meaning”
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: _front ? 1 : 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha:0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo.withValues(alpha:0.25)),
                ),
                child: Text(
                  'Tap to reveal meaning',
                  style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.indigo[700]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
