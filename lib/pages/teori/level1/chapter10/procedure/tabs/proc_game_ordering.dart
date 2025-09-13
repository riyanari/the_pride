import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

class ProcOrderingGame extends StatefulWidget {
  const ProcOrderingGame({super.key});
  @override
  State<ProcOrderingGame> createState() => _ProcOrderingGameState();
}

class _Item { final int order; final String step; const _Item(this.order, this.step); }

class _ProcOrderingGameState extends State<ProcOrderingGame> {
  final r = Random();
  late List<_Item> _items;

  @override
  void initState() { super.initState(); _setup(); }

  void _setup() {
    final data = <_Item>[
      const _Item(1, 'First, boil water.'),
      const _Item(2, 'Next, add noodles.'),
      const _Item(3, 'Then, stir for 3 minutes.'),
      const _Item(4, 'After that, drain the water.'),
      const _Item(5, 'Finally, serve and enjoy.'),
    ]..shuffle(r);
    _items = data;
    setState(() {});
  }

  bool _isOrdered() {
    for (int i = 1; i < _items.length; i++) {
      if (_items[i-1].order > _items[i].order) return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    // final color = Colors.brown;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('Ordering', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold))),
              IconButton(onPressed: _setup, icon: const Icon(Icons.shuffle)),
            ],
          ),
          const SizedBox(height: 6),
          _infoBadge(icon: Icons.drag_indicator, text: 'Urutkan langkah dari awal sampai akhir (drag & drop).'),
          const SizedBox(height: 8),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: _items.length,
              buildDefaultDragHandles: false, // ⬅️ pakai handle kita sendiri
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final it = _items.removeAt(oldIndex);
                  _items.insert(newIndex, it);
                });
              },
              itemBuilder: (_, i) => Card(
                key: ValueKey(_items[i].order),
                child: ListTile(
                  title: Text(_items[i].step, style: primaryTextStyle),
                  trailing: ReorderableDragStartListener(
                    index: i,
                    child: const Icon(Icons.drag_handle),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final ok = _isOrdered();
                    AwesomeDialog(
                      context: context,
                      dialogType: ok ? DialogType.success : DialogType.info,
                      title: ok ? 'Urutan Benar!' : 'Belum Tepat',
                      desc: ok ? 'Mantap. Kamu menyusun langkah dengan benar.' : 'Coba urutkan lagi sesuai alur proses.',
                      btnOkOnPress: () {},
                    ).show();
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Cek Urutan'),
                ),
              ),
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
