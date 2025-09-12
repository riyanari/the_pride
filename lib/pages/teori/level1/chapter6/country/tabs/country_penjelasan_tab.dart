import 'package:flutter/material.dart';
import '../country_shared.dart';

class CountryPenjelasanTab extends StatelessWidget {
  const CountryPenjelasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final points = const [
      Tip('Country vs Nationality', 'Country = negara (Indonesia). Nationality = kebangsaan (Indonesian). Contoh: “She is Indonesian.”'),
      Tip('Language', 'Gunakan “speak + language”: “He speaks English.” Beberapa negara memiliki lebih dari satu bahasa resmi.'),
      Tip('Preposisi', 'from (asal): “from Japan”; in (lokasi): “in Germany”; to (tujuan): “go to Canada”.'),
      Tip('Huruf Kapital', 'Nama negara, kebangsaan, bahasa, dan ibu kota ditulis dengan kapital: Indonesia, Indonesian, Indonesian language, Jakarta.'),
    ];

    final patterns = const [
      Tip('Rumus Perkenalan', 'I am [nationality]. / I am from [country].'),
      Tip('Rumus Bahasa', 'I speak [language]. / They speak [language] in [country].'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Poin Penting', Colors.purple),
          const SizedBox(height: 8),
          for (final t in points) tipCard(t, Colors.purple),
          const SizedBox(height: 16),
          sectionTitle('Rumus / Pola', Colors.brown),
          const SizedBox(height: 8),
          for (final t in patterns) tipCard(t, Colors.brown),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.check_circle_outline, text: 'Beberapa nationality berbentuk sama untuk singular/plural: the Japanese, the Chinese. (opsional)'),
        ],
      ),
    );
  }
}
