import 'package:flutter/material.dart';
import 'package:the_pride/pages/teori/level1/chapter3/family/family_shared.dart';

class FamilyPenjelasanTab extends StatelessWidget {
  const FamilyPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      Tip('Possessive + Family Nouns', 'my/your/his/her + brother/sister/parents.\nContoh: “My brother is 10.”'),
      Tip('Older/Younger vs Elder', 'older/younger lebih umum; elder biasanya untuk keluarga dan sebelum kata benda (my elder sister).'),
      Tip('Grand-, Great-, -in-law', 'grand- (kakek/nenek), great- (buyut), -in-law (mertua/ipar).'),
      Tip('Step- & Half-', 'step- (tiri via pernikahan), half- (saudara se-ayah/ibu kandung).'),
      Tip('Plural & Countable', 'parent(s), cousin(s). Gunakan -s untuk jamak.'),
      Tip('Be + Noun', 'He is my uncle. / They are my grandparents.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Penjelasan Penting', Colors.purple),
          const SizedBox(height: 8),
          for (final t in items) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          infoBadge(icon: Icons.tips_and_updates, text: '“Cousin” tidak membedakan laki/perempuan. Tambahkan penjelasan jika perlu (female cousin).'),
        ],
      ),
    );
  }
}
