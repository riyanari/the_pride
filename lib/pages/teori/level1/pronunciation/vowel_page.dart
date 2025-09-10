import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_pride/theme/theme.dart';
import 'package:the_pride/data/vowels_data.dart';
import 'package:the_pride/utils/audio_services.dart';

class VowelsTab extends StatefulWidget {
  const VowelsTab({
    super.key,
    required this.audioService,
    this.title = 'English Vowels',
  });

  final AudioService audioService;
  final String title;

  @override
  State<VowelsTab> createState() => _VowelsTabState();
}

class _VowelsTabState extends State<VowelsTab> {
  // Default ke American vowels
  List<Map<String, String>> _currentVowels = VowelsData.americanVowels;
  String _currentAccent = 'American';

  // Grouping helper
  Map<String, List<Map<String, String>>> _groupVowelsByClassification(
      List<Map<String, String>> vowels,
      ) {
    final Map<String, List<Map<String, String>>> grouped = {};
    for (final vowel in vowels) {
      final classification = vowel['klasifikasi'] ?? 'other';
      grouped.putIfAbsent(classification, () => []);
      grouped[classification]!.add(vowel);
    }
    return grouped;
  }

  void _showInfoDialog({
    required String title,
    required String desc,
    required Color color,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      title: title,
      desc: desc,
      btnOkText: 'Tutup',
      btnOkOnPress: () {},
      btnOkColor: color,
    ).show();
  }

  Widget _buildVowelItem(Map<String, String> vowel, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // IPA Symbol
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                vowel['letter']!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),

          // Example word
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              vowel['example']!,
              style: primaryTextStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Sound transcription
          Text(
            vowel['sound']!,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),

          // Play button
          IconButton(
            icon: Icon(Icons.volume_up, size: 16, color: color),
            onPressed: () => widget.audioService.playSound(vowel['audio']!),
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationSection(
      String title,
      List<Map<String, String>> vowels,
      String desc,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title.toUpperCase(),
                  style: primaryTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _showInfoDialog(title: title, desc: desc, color: color);
                  },
                  child: Icon(Icons.info_outline, color: color, size: 18),
                ),
              ],
            ),
          ),

          // Vowels grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: vowels.length,
              itemBuilder: (context, index) {
                final vowel = vowels[index];
                return _buildVowelItem(vowel, color);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedVowels = _groupVowelsByClassification(_currentVowels);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Accent selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: kSecondaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: DropdownButton<String>(
                  value: _currentAccent,
                  icon: const Icon(Icons.arrow_drop_down, size: 16),
                  elevation: 2,
                  style: primaryTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semiBold,
                  ),
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _currentAccent = newValue!;
                      _currentVowels = newValue == 'American'
                          ? VowelsData.americanVowels
                          : VowelsData.britishVowels;
                    });
                  },
                  items: <String>['American', 'British']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sections by classification
          Expanded(
            child: ListView(
              children: [
                if (groupedVowels.containsKey('lax'))
                  _buildClassificationSection(
                    'Lax Vowels',
                    groupedVowels['lax']!,
                    'vokal rileks/kurang tegang. Lidah & otot mulut tidak setegang pada vokal “tense”. Biasanya lebih pendek durasinya dan sering muncul di suku kata tertutup (diakhiri konsonan)',
                    Colors.green,
                  ),
                if (groupedVowels.containsKey('tense'))
                  _buildClassificationSection(
                    'Tense Vowels',
                    groupedVowels['tense']!,
                    'kategori gramatikal waktu. Secara tradisional di pengajaran EFL/ESL, sering diajarkan 12 pola (present/past/future × simple/continuous/perfect/perfect continuous). Secara linguistik ketat, bahasa Inggris terutama menandai past vs non-past, sedangkan “future” biasanya memakai modal (will/going to). Keduanya valid tergantung tujuan belajar.',
                    Colors.blue,
                  ),
                if (groupedVowels.containsKey('long'))
                  _buildClassificationSection(
                    'Long Vowels',
                    groupedVowels['long']!,
                    'vokal ganda dalam satu suku kata: bunyi meluncur dari satu kualitas vokal ke vokal lain (glide).',
                    Colors.purple,
                  ),
                if (groupedVowels.containsKey('short'))
                  _buildClassificationSection(
                    'Short Vowels',
                    groupedVowels['short']!,
                    'vokal ganda dalam satu suku kata: bunyi meluncur dari satu kualitas vokal ke vokal lain (glide).',
                    Colors.orange,
                  ),
                if (groupedVowels.containsKey('diphthong'))
                  _buildClassificationSection(
                    'Diphthongs',
                    groupedVowels['diphthong']!,
                    'vokal ganda dalam satu suku kata: bunyi meluncur dari satu kualitas vokal ke vokal lain (glide).',
                    Colors.red,
                  ),
                if (groupedVowels.containsKey('r-colored'))
                  _buildClassificationSection(
                    'R-Colored Vowels',
                    groupedVowels['r-colored']!,
                    'vokal ganda dalam satu suku kata: bunyi meluncur dari satu kualitas vokal ke vokal lain (glide).',
                    Colors.pink,
                  ),
                if (groupedVowels.containsKey('schwa'))
                  _buildClassificationSection(
                    'Schwa',
                    groupedVowels['schwa']!,
                    'vokal ganda dalam satu suku kata: bunyi meluncur dari satu kualitas vokal ke vokal lain (glide).',
                    Colors.grey,
                  ),
                for (final classification in groupedVowels.keys)
                  if (![
                    'tense',
                    'lax',
                    'long',
                    'short',
                    'diphthong',
                    'r-colored',
                    'schwa',
                  ].contains(classification))
                    _buildClassificationSection(
                      classification,
                      groupedVowels[classification]!,
                      'vokal ganda dalam satu suku kata: bunyi meluncur dari satu kualitas vokal ke vokal lain (glide).',
                      Colors.teal,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
