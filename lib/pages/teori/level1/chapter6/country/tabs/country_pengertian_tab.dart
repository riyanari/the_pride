import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../country_shared.dart';

class CountryPengertianTab extends StatelessWidget {
  const CountryPengertianTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    final tips = const [
      Tip('Definisi', 'Topik “Countries” mencakup nama negara, kebangsaan (nationality), bahasa (language), dan ibu kota (capital).'),
      Tip('Tujuan', 'Memperkenalkan asal, kebangsaan, bahasa yang digunakan, serta berbicara tentang negara dan kota di dunia.'),
      Tip('Bentuk', 'Gunakan “from + country” untuk asal, “be + nationality” untuk kebangsaan, dan “speak + language” untuk bahasa.'),
    ];

    final examples = const [
      CountryVocab(country:'Japan', indo:'Jepang', nationality:'Japanese', language:'Japanese', capital:'Tokyo', region:R_ASIA, flag:'🇯🇵', example:'He is Japanese.'),
      CountryVocab(country:'Brazil', indo:'Brasil', nationality:'Brazilian', language:'Portuguese', capital:'Brasília', region:R_AMERICAS, flag:'🇧🇷', example:'They speak Portuguese in Brazil.'),
      CountryVocab(country:'France', indo:'Prancis', nationality:'French', language:'French', capital:'Paris', region:R_EUROPE, flag:'🇫🇷', example:'Paris is the capital of France.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: ListView(
        children: [
          sectionTitle('Konsep Dasar', Colors.blue),
          const SizedBox(height: 8),
          for (final t in tips) tipCard(t, Colors.blue),
          const SizedBox(height: 16),
          sectionTitle('Contoh Ungkapan', Colors.teal),
          const SizedBox(height: 8),
          for (final v in examples) countryTile(v, color: Colors.teal, audio: audio),
          const SizedBox(height: 8),
          infoBadge(icon: Icons.lightbulb_outline, text: 'Pola umum: “I am Indonesian.” / “I am from Indonesia.” / “I speak Indonesian.”'),
        ],
      ),
    );
  }
}
