import 'dart:math';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/utils/audio_services.dart';

const kCountryAudioUrl =
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

/// ===== Models =====
class Tip {
  final String title;
  final String text;

  const Tip(this.title, this.text);
}

class CountryVocab {
  final String country; // EN name
  final String indo; // Indonesian name
  final String nationality; // demonym adj: Indonesian, American, ...
  final String language; // main language(s)
  final String capital; // capital city
  final String region; // ASIA/EUROPE/AMERICAS/AFRICA/OCEANIA/MIDDLE_EAST
  final String flag; // emoji
  final String? ipa; // simple IPA for nationality (opsional)
  final String? example; // example sentence
  final String? audio; // audio url (opsional)

  const CountryVocab({
    required this.country,
    required this.indo,
    required this.nationality,
    required this.language,
    required this.capital,
    required this.region,
    required this.flag,
    this.ipa,
    this.example,
    this.audio,
  });
}

class MCQItem {
  final String prompt;
  final List<String> options;
  final int correct;
  final String explain;

  const MCQItem({
    required this.prompt,
    required this.options,
    required this.correct,
    required this.explain,
  });
}

class Pair {
  final String left;
  final String right;
  final String explain;

  const Pair({required this.left, required this.right, required this.explain});
}

class Choice {
  final int id;
  final String text;
  final String key;

  const Choice({required this.id, required this.text, required this.key});
}

/// ===== Regions =====
const R_ASIA = 'Asia';
const R_EUROPE = 'Europe';
const R_AMERICAS = 'Americas';
const R_AFRICA = 'Africa';
const R_OCEANIA = 'Oceania';
const R_MIDEAST = 'Middle East';

final kCountryRegions = const [
  R_ASIA,
  R_EUROPE,
  R_AMERICAS,
  R_AFRICA,
  R_OCEANIA,
  R_MIDEAST,
];

/// ===== Vocabulary =====
final List<CountryVocab> kCountryVocab = [
  CountryVocab(
    country: 'Indonesia',
    indo: 'Indonesia',
    nationality: 'Indonesian',
    language: 'Indonesian',
    capital: 'Jakarta',
    region: R_ASIA,
    flag: '🇮🇩',
    ipa: '/ˌɪndəˈniːʒ(ə)n/',
    example: 'I am Indonesian.',
  ),
  CountryVocab(
    country: 'United States',
    indo: 'Amerika Serikat',
    nationality: 'American',
    language: 'English',
    capital: 'Washington, D.C.',
    region: R_AMERICAS,
    flag: '🇺🇸',
    ipa: '/əˈmɛrɪkən/',
    example: 'She is American.',
  ),
  CountryVocab(
    country: 'United Kingdom',
    indo: 'Britania Raya',
    nationality: 'British',
    language: 'English',
    capital: 'London',
    region: R_EUROPE,
    flag: '🇬🇧',
    ipa: '/ˈbrɪtɪʃ/',
  ),
  CountryVocab(
    country: 'Australia',
    indo: 'Australia',
    nationality: 'Australian',
    language: 'English',
    capital: 'Canberra',
    region: R_OCEANIA,
    flag: '🇦🇺',
    ipa: '/ɒˈstreɪliən/',
  ),
  CountryVocab(
    country: 'Japan',
    indo: 'Jepang',
    nationality: 'Japanese',
    language: 'Japanese',
    capital: 'Tokyo',
    region: R_ASIA,
    flag: '🇯🇵',
    ipa: '/ˌdʒæpəˈniːz/',
  ),
  CountryVocab(
    country: 'China',
    indo: 'Tiongkok',
    nationality: 'Chinese',
    language: 'Chinese',
    capital: 'Beijing',
    region: R_ASIA,
    flag: '🇨🇳',
    ipa: '/tʃaɪˈniːz/',
  ),
  CountryVocab(
    country: 'South Korea',
    indo: 'Korea Selatan',
    nationality: 'Korean',
    language: 'Korean',
    capital: 'Seoul',
    region: R_ASIA,
    flag: '🇰🇷',
    ipa: '/kəˈriːən/',
  ),
  CountryVocab(
    country: 'India',
    indo: 'India',
    nationality: 'Indian',
    language: 'Hindi, English',
    capital: 'New Delhi',
    region: R_ASIA,
    flag: '🇮🇳',
    ipa: '/ˈɪndɪən/',
  ),
  CountryVocab(
    country: 'Germany',
    indo: 'Jerman',
    nationality: 'German',
    language: 'German',
    capital: 'Berlin',
    region: R_EUROPE,
    flag: '🇩🇪',
    ipa: '/ˈdʒɜːmən/',
  ),
  CountryVocab(
    country: 'France',
    indo: 'Prancis',
    nationality: 'French',
    language: 'French',
    capital: 'Paris',
    region: R_EUROPE,
    flag: '🇫🇷',
    ipa: '/frɛntʃ/',
  ),
  CountryVocab(
    country: 'Italy',
    indo: 'Italia',
    nationality: 'Italian',
    language: 'Italian',
    capital: 'Rome',
    region: R_EUROPE,
    flag: '🇮🇹',
    ipa: '/ɪˈtæliən/',
  ),
  CountryVocab(
    country: 'Spain',
    indo: 'Spanyol',
    nationality: 'Spanish',
    language: 'Spanish',
    capital: 'Madrid',
    region: R_EUROPE,
    flag: '🇪🇸',
    ipa: '/ˈspænɪʃ/',
  ),
  CountryVocab(
    country: 'Canada',
    indo: 'Kanada',
    nationality: 'Canadian',
    language: 'English, French',
    capital: 'Ottawa',
    region: R_AMERICAS,
    flag: '🇨🇦',
    ipa: '/kəˈneɪdiən/',
  ),
  CountryVocab(
    country: 'Brazil',
    indo: 'Brasil',
    nationality: 'Brazilian',
    language: 'Portuguese',
    capital: 'Brasília',
    region: R_AMERICAS,
    flag: '🇧🇷',
    ipa: '/brəˈzɪliən/',
  ),
  CountryVocab(
    country: 'Mexico',
    indo: 'Meksiko',
    nationality: 'Mexican',
    language: 'Spanish',
    capital: 'Mexico City',
    region: R_AMERICAS,
    flag: '🇲🇽',
    ipa: '/ˈmɛksɪkən/',
  ),
  CountryVocab(
    country: 'Egypt',
    indo: 'Mesir',
    nationality: 'Egyptian',
    language: 'Arabic',
    capital: 'Cairo',
    region: R_AFRICA,
    flag: '🇪🇬',
    ipa: '/ɪˈdʒɪpʃən/',
  ),
  CountryVocab(
    country: 'Saudi Arabia',
    indo: 'Arab Saudi',
    nationality: 'Saudi',
    language: 'Arabic',
    capital: 'Riyadh',
    region: R_MIDEAST,
    flag: '🇸🇦',
    ipa: '/ˈsɔːdi/',
  ),
  CountryVocab(
    country: 'Turkey',
    indo: 'Turki',
    nationality: 'Turkish',
    language: 'Turkish',
    capital: 'Ankara',
    region: R_MIDEAST,
    flag: '🇹🇷',
    ipa: '/ˈtɜːkɪʃ/',
  ),
  CountryVocab(
    country: 'Russia',
    indo: 'Rusia',
    nationality: 'Russian',
    language: 'Russian',
    capital: 'Moscow',
    region: R_EUROPE,
    flag: '🇷🇺',
    ipa: '/ˈrʌʃən/',
  ),
  CountryVocab(
    country: 'South Africa',
    indo: 'Afrika Selatan',
    nationality: 'South African',
    language: 'English, Zulu',
    capital: 'Pretoria',
    region: R_AFRICA,
    flag: '🇿🇦',
    ipa: '/saʊθ ˈæfrɪkən/',
  ),
];

/// ===== Helpers UI =====
Widget sectionTitle(String text, Color color) => Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    ),
  ],
);

Widget infoBadge({required IconData icon, required String text, Color? color}) {
  final c = color ?? Colors.indigo;
  return Container(
    margin: const EdgeInsets.only(top: 4, bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: c.withValues(alpha: 0.25), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: c, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: primaryTextStyle.copyWith(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget tipCard(Tip tip, Color color) => Container(
  margin: const EdgeInsets.only(bottom: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha: 0.25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: ListTile(
    leading: Icon(Icons.info_outline, color: color),
    title: Text(
      tip.title,
      style: primaryTextStyle.copyWith(fontWeight: semiBold),
    ),
    subtitle: Text(
      tip.text,
      style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
    ),
  ),
);

Widget countryTile(
    CountryVocab v, {
      Color color = Colors.teal,
      AudioService? audio,
    }) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,                   // ⬅️ penting (tidak minta ruang tak terbatas)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bar atas: bendera + tombol audio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(v.flag, style: const TextStyle(fontSize: 26)),
              if (audio != null)
                SizedBox(
                  width: 32, height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                    tooltip: 'Play',
                    onPressed: () => audio.playSound(v.audio ?? kCountryAudioUrl),
                    icon: Icon(Icons.volume_up, color: color, size: 20),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // Nama negara (EN)
          Text(
            v.country,
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Indo + nationality
          Text(
            '${v.indo} • ${v.nationality}${v.ipa != null ? '  ${v.ipa}' : ''}',
            style: primaryTextStyle.copyWith(fontSize: 12, color: Colors.grey[800]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),

          // Bahasa & ibu kota (wrap supaya gampang turun baris)
          const SizedBox(height: 2),
          Text(
            'Lang: ${v.language} • Capital: ${v.capital}',
            style: primaryTextStyle.copyWith(fontSize: 11, color: Colors.grey[700]),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),

          if (v.example != null) ...[
            const SizedBox(height: 6),
            Text(
              v.example!,
              style: primaryTextStyle.copyWith(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
        ],
      ),
    ),
  );
}


/// Utils
List<CountryVocab> byRegion(String region) =>
    kCountryVocab.where((e) => e.region == region).toList();

T pickOne<T>(List<T> list, Random r) => list[r.nextInt(list.length)];
