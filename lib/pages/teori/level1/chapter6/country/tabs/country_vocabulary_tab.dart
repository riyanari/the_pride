import 'package:flutter/material.dart';
import 'package:the_pride/utils/audio_services.dart';
import '../country_shared.dart';

class CountryVocabularyTab extends StatefulWidget {
  const CountryVocabularyTab({super.key});

  @override
  State<CountryVocabularyTab> createState() => _CountryVocabularyTabState();
}

class _CountryVocabularyTabState extends State<CountryVocabularyTab> {
  String _region = R_ASIA;

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final items = byRegion(_region);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Region', Colors.indigo),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final r in kCountryRegions)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(r),
                      selected: _region == r,
                      onSelected: (_) => setState(() => _region = r),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (_, i) => countryTile(items[i], audio: audio),
            ),
          ),
        ],
      ),
    );
  }
}
