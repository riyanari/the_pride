import 'package:flutter/material.dart';
import '../food_shared.dart';

class FoodPenjelasanTab extends StatelessWidget {
  const FoodPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bullets = <Tip>[
      const Tip('Countable vs Uncountable',
          'Countable: an apple, two eggs. Uncountable: rice, water, bread (umumnya tak dihitung tanpa satuan).'),
      const Tip('Quantifiers',
          'some/any, much/many, a few/a little. Contoh: "many apples" (count.), "much rice" (uncount.).'),
      const Tip('Containers/Portions',
          'a cup of tea, a glass of water, a slice of bread, a bowl of soup, a bottle of juice.'),
      const Tip('Preferences',
          'I like/love/prefer…, I don’t like…, I’m allergic to…'),
      const Tip('Ordering & Offering',
          'Could I have…? I’d like…, Would you like…?, Anything else? That’s all, thanks.'),
    ];

    final patterns = const [
      Tip('Rumus: Memesan',
          '[Opener] + [Item] + ([Container/Modifier]) → "Could I have a bowl of soup, please?"'),
      Tip('Rumus: Suka/Preferensi',
          '[Subject] + (really) like/love/prefer + [Food/Drink] → "She prefers tea to coffee."'),
      Tip('Rumus: Deskripsi Rasa',
          '[Food] + is + [Taste Adj] → "The curry is spicy."'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Poin Penting', Colors.purple),
          const SizedBox(height: 8),
          for (final t in bullets) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Rumus / Pola', Colors.brown),
          const SizedBox(height: 8),
          for (final t in patterns) tipCard(t, Colors.brown),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.check_circle_outline, text: 'Untuk uncountable nouns, gunakan satuan: "a bottle of water", bukan "a water".'),
        ],
      ),
    );
  }
}
