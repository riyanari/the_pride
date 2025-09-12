import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

class TimeOrderingGame extends StatefulWidget {
  const TimeOrderingGame({super.key});
  @override
  State<TimeOrderingGame> createState() => _TimeOrderingGameState();
}

class _Item { final String time; final String activity; const _Item(this.time, this.activity); }

class _TimeOrderingGameState extends State<TimeOrderingGame> {
  final r = Random();
  late List<_Item> _items;
  bool _checked = false;
  final Set<int> _badIndices = {};

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    _items = [
      const _Item('06:30', 'Wake up'),
      const _Item('07:00', 'Have breakfast'),
      const _Item('08:00', 'Go to school'),
      const _Item('12:00', 'Have lunch'),
      const _Item('16:00', 'Go home'),
      const _Item('19:00', 'Have dinner'),
      const _Item('22:00', 'Go to bed'),
    ]..shuffle(r);
    _checked = false;
    _badIndices.clear();
    setState(() {});
  }

  int _toMinutes(String hhmm) {
    final p = hhmm.split(':');
    final h = int.tryParse(p[0]) ?? 0;
    final m = int.tryParse(p[1]) ?? 0;
    return h * 60 + m;
  }

  void _checkOrder() {
    _badIndices.clear();
    for (var i = 1; i < _items.length; i++) {
      if (_toMinutes(_items[i-1].time) > _toMinutes(_items[i].time)) {
        _badIndices.add(i);
      }
    }
    _checked = true;
    final ok = _badIndices.isEmpty;
    AwesomeDialog(
      context: context,
      dialogType: ok ? DialogType.success : DialogType.info,
      title: ok ? 'Mantap! ✅' : 'Belum urut',
      desc: ok
          ? 'Semua kegiatan sudah berurutan dari paling pagi ke malam.'
          : 'Masih ada yang salah posisi. Coba geser atau gunakan Naikkan/Turunkan.',
      btnOkOnPress: () {},
    ).show();
    setState(() {});
  }

  void _revealSorted() {
    _items.sort((a, b) => _toMinutes(a.time).compareTo(_toMinutes(b.time)));
    _checked = true;
    _badIndices.clear();
    setState(() {});
  }

  // ==== AKSI KLIK: NAIKKAN / TURUNKAN ====
  void _moveUp(int i) {
    if (i <= 0) return;
    setState(() {
      final it = _items.removeAt(i);
      _items.insert(i - 1, it);
      _checked = false; _badIndices.clear();
    });
  }

  void _moveDown(int i) {
    if (i >= _items.length - 1) return;
    setState(() {
      final it = _items.removeAt(i);
      _items.insert(i + 1, it);
      _checked = false; _badIndices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.brown;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Ordering', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle), tooltip: 'Acak'),
            ],
          ),
          const SizedBox(height: 6),
          _infoBadge(icon: Icons.drag_indicator, text: 'Urutkan kegiatan dari pagi → malam. Bisa drag handle (≡) atau klik ⋮ untuk Naikkan/Turunkan.'),
          const SizedBox(height: 8),

          Expanded(
            child: ReorderableListView.builder(
              padding: EdgeInsets.zero,
              buildDefaultDragHandles: false, // kita pakai handle custom
              itemCount: _items.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final it = _items.removeAt(oldIndex);
                  _items.insert(newIndex, it);
                  _checked = false; _badIndices.clear();
                });
              },
              itemBuilder: (_, i) {
                Color border = Colors.transparent;
                Color bg = Colors.white;
                if (_checked) {
                  if (i > 0 && _badIndices.contains(i)) {
                    border = Colors.red;
                    bg = Colors.red.withValues(alpha:0.06);
                  } else {
                    border = Colors.green.withValues(alpha:0.6);
                    bg = Colors.green.withValues(alpha:0.06);
                  }
                }
                final canUp = i > 0;
                final canDown = i < _items.length - 1;

                return Card(
                  key: ValueKey(_items[i].time),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: border),
                  ),
                  color: bg,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha:0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withValues(alpha:0.25)),
                      ),
                      child: Text(_items[i].time, style: primaryTextStyle.copyWith(fontWeight: semiBold)),
                    ),
                    title: Text(_items[i].activity, style: primaryTextStyle),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle drag
                        ReorderableDragStartListener(
                          index: i,
                          child: const Icon(Icons.drag_handle),
                        ),
                        const SizedBox(width: 6),
                        // Menu klik: Naikkan/Turunkan
                        PopupMenuButton<String>(
                          tooltip: 'Opsi',
                          onSelected: (v) {
                            if (v == 'up') _moveUp(i);
                            if (v == 'down') _moveDown(i);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'up',
                              enabled: canUp,
                              child: const Text('Naikkan'),
                            ),
                            PopupMenuItem(
                              value: 'down',
                              enabled: canDown,
                              child: const Text('Turunkan'),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _checkOrder,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Cek Urutan'),
                ),
              ),
              // const SizedBox(width: 10),
              // OutlinedButton.icon(
              //   onPressed: _revealSorted,
              //   icon: const Icon(Icons.sort),
              //   label: const Text('Jawaban (Sort)'),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBadge({required IconData icon, required String text, Color? color}) {
    final c = color ?? Colors.indigo;
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha:0.25), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.06), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: c, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]))),
        ],
      ),
    );
  }
}
