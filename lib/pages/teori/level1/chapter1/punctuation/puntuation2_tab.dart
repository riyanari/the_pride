import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';

/// PunctuationSymbolQuizTab
///
/// Cara kerja:
/// - Di atas: grid "gambar simbol" (pakai glyph besar atau image asset jika tersedia).
/// - Di bawah: semua NAMA simbol sebagai ChoiceChips.
/// - Pilih dulu NAMANYA, lalu klik salah satu SIMBOL.
///   Jika benar → kartu simbol menjadi hijau + muncul AwesomeDialog berisi penjelasan.
///   Jika salah → kartu simbol menjadi merah.
/// - Tombol Shuffle & Reset tersedia di header.
class PunctuationSymbolQuizTab extends StatefulWidget {
  const PunctuationSymbolQuizTab({super.key, this.title = 'Punctuation — Match Symbol to Name'});
  final String title;

  @override
  State<PunctuationSymbolQuizTab> createState() => _PunctuationSymbolQuizTabState();
}

class _Item {
  const _Item({
    required this.id,
    required this.display, // apa yang ditampilkan pada kartu (glyph / teks)
    required this.name, // nama yang harus dicocokkan
    required this.desc, // penjelasan singkat
    this.asset, // optional: path asset gambar jika ingin pakai image
  });
  final int id;
  final String display;
  final String name;
  final String desc;
  final String? asset;
}

enum _StateMark { neutral, correct, wrong }

class _PunctuationSymbolQuizTabState extends State<PunctuationSymbolQuizTab> {
  final _rand = Random();
  int? _selectedNameId; // id dari nama yang dipilih user

  // status per-symbol
  late Map<int, _StateMark> _marks = {};

  // ====== DATA ======
  late List<_Item> _items = [
    _Item(id: 1, display: '.', name: 'Period', desc: 'Tanda titik untuk mengakhiri kalimat pernyataan.'),
    _Item(id: 2, display: ',', name: 'Comma', desc: 'Memisahkan elemen dalam daftar atau frasa pengantar.'),
    _Item(id: 3, display: '?', name: 'Question Mark', desc: 'Mengakhiri kalimat tanya langsung.'),
    _Item(id: 4, display: '!', name: 'Exclamation Mark', desc: 'Menunjukkan seruan/emosi kuat.'),
    _Item(id: 5, display: ':', name: 'Colon', desc: 'Memperkenalkan daftar, penjelasan, atau kutipan.'),
    _Item(id: 6, display: ';', name: 'Semicolon', desc: 'Menghubungkan dua klausa independen yang terkait.'),
    _Item(id: 7, display: "'", name: 'Apostrophe', desc: 'Menandai kepemilikan atau kontraksi (don\'t, it\'s).'),
    _Item(id: 8, display: '"', name: 'Quotation Marks', desc: 'Mengapit kutipan langsung atau judul karya.'),
    _Item(id: 9, display: '-', name: 'Hyphen', desc: 'Menyambung kata majemuk (well-known).'),
    _Item(id: 10, display: '–', name: 'En Dash', desc: 'Menandai rentang (2019–2023).'),
    _Item(id: 11, display: '—', name: 'Em Dash', desc: 'Jeda/penekanan—lebih panjang dari en dash.'),
    _Item(id: 12, display: '()', name: 'Parentheses', desc: 'Menambahkan informasi sampingan.'),
    _Item(id: 13, display: '[]', name: 'Brackets', desc: 'Sisipan/penjelasan editorial dalam kutipan.'),
    _Item(id: 14, display: '{}', name: 'Braces', desc: 'Kurung kurawal—jarang dalam prosa umum; sering di matematika/kode.'),
    _Item(id: 15, display: '…', name: 'Ellipsis', desc: 'Menandai penghilangan teks atau jeda ragu.'),
    _Item(id: 16, display: '/', name: 'Slash', desc: 'Menandai pilihan/relasi (and/or, input/output).'),
    _Item(id: 17, display: r'\', name: 'Backslash', desc: 'Umum di path/kode (Windows path, escape).'),
  ];

  // Semua opsi nama (dari _items), tapi dipisah agar bisa di-shuffle terpisah
  late List<_Item> _nameOptions = [];

  @override
  void initState() {
    super.initState();
    _resetMarks();
    _shuffleAll();
  }

  void _resetMarks() {
    _marks = {for (final it in _items) it.id: _StateMark.neutral};
  }

  void _shuffleAll() {
    _items = [..._items]..shuffle(_rand);
    _nameOptions = [..._items]..shuffle(_rand);
    _selectedNameId = null;
    _resetMarks();
    setState(() {});
  }

  void _resetOnlyColors() {
    _resetMarks();
    setState(() {});
  }

  void _onNameSelected(int id) {
    setState(() => _selectedNameId = id);
  }

  void _onSymbolTap(_Item symbol) {
    if (_selectedNameId == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.scale,
        title: 'Pilih nama dulu',
        desc: 'Silakan pilih nama simbol di bagian bawah, lalu klik simbol yang sesuai.',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    final picked = _nameOptions.firstWhere((e) => e.id == _selectedNameId);
    final correct = picked.id == symbol.id;

    setState(() {
      _marks[symbol.id] = correct ? _StateMark.correct : _StateMark.wrong;
    });

    if (correct) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: symbol.name,
        desc: symbol.desc,
        btnOkText: 'Lanjut',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & actions
          Row(
            children: [
              Expanded(
                child: Text(widget.title,
                    style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                tooltip: 'Shuffle semua',
                onPressed: _shuffleAll,
                icon: const Icon(Icons.shuffle),
              ),
              IconButton(
                tooltip: 'Reset warna',
                onPressed: _resetOnlyColors,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            'Instruksi: Pilih nama simbol di bawah, lalu klik simbol yang cocok di grid.',
            style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[700]),
          ),

          const SizedBox(height: 12),

          // Grid simbol (gambar besar)
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final it = _items[index];
                final mark = _marks[it.id] ?? _StateMark.neutral;

                Color borderColor;
                Color bgColor;
                switch (mark) {
                  case _StateMark.correct:
                    borderColor = Colors.green;
                    bgColor = Colors.green.withValues(alpha:0.08);
                    break;
                  case _StateMark.wrong:
                    borderColor = Colors.red;
                    bgColor = Colors.red.withValues(alpha:0.08);
                    break;
                  case _StateMark.neutral:
                    borderColor = Colors.grey.withValues(alpha:0.3);
                    bgColor = Colors.white;
                    break;
                }

                return InkWell(
                  onTap: () => _onSymbolTap(it),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _buildSymbolVisual(it),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Semua NAMA simbol (ChoiceChips)
          Text('Pilih nama simbol:', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final opt in _nameOptions)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(opt.name),
                      selected: _selectedNameId == opt.id,
                      onSelected: (_) => _onNameSelected(opt.id),
                      selectedColor: Colors.blue.withValues(alpha:0.18),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolVisual(_Item it) {
    if (it.asset != null && it.asset!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(it.asset!, fit: BoxFit.contain),
      );
    }
    // Default: tampilkan glyph besar
    return Text(
      it.display,
      textAlign: TextAlign.center,
      style: primaryTextStyle.copyWith(fontSize: 42, fontWeight: FontWeight.bold),
    );
  }
}
