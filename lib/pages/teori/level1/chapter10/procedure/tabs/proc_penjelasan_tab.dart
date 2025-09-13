import 'package:flutter/material.dart';
import '../procedures_shared.dart';

class ProcPenjelasanTab extends StatelessWidget {
  const ProcPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      Tip('Imperatives', 'Gunakan bentuk dasar (V1) untuk perintah: “Mix…”, “Press…”. Negatif: “Do not/Don’t + V1”.'),
      Tip('Sequencers', 'first, next, then, after that, meanwhile, finally → membantu urutan langkah.'),
      Tip('Clarity & Safety', 'Gunakan kata wajib/saran: must, should, warning, caution untuk menekankan keselamatan.'),
      Tip('Detail Teknis', 'Sebutkan alat, bahan, unit waktu/suhu agar instruksi presisi: “boil for 10 minutes at 100°C”.'),
      Tip('Visual', 'Bullet/numbered list dan gambar akan meningkatkan keterbacaan prosedur.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Rangkuman', Colors.indigo),
          const SizedBox(height: 8),
          for (final t in items) infoBadge(icon: Icons.checklist_rounded, text: '${t.title}: ${t.text}', color: Colors.indigo),
        ],
      ),
    );
  }
}
