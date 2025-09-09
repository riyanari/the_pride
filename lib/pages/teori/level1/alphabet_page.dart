import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:the_pride/components/custom_app_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:the_pride/pages/teori/level1/alphabet/mengeja_card.dart';
import 'package:the_pride/theme/theme.dart';

import 'alphabet/alphabet_card.dart';
import 'alphabet/game_card.dart';

class AlphabetPage extends StatefulWidget {
  const AlphabetPage({super.key});

  @override
  State<AlphabetPage> createState() => _AlphabetPageState();
}

class _AlphabetPageState extends State<AlphabetPage> {
  late AudioPlayer _audioPlayer;
  String? _currentlyPlaying;
  bool _isAudioPlayerInitialized = false;
  final Map<String, String> _cachedAudioPaths = {};
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _pageTitles = [
    'A. Abjad dalam Bahasa Inggris',
    'B. Latihan Mengeja',
    'C. Alphabet Game',
  ];

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _preCacheFrequentlyUsedAudio();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    setState(() {
      _isAudioPlayerInitialized = true;
    });
  }

  // Pre-cache audio yang sering digunakan
  Future<void> _preCacheFrequentlyUsedAudio() async {
    final frequentLetters = ['A', 'B', 'C', 'D', 'E'];
    for (final letter in frequentLetters) {
      final audioUrl = _getAudioUrlForLetter(letter);
      await _downloadAndCacheAudio(audioUrl);
    }
  }

  Future<String> _downloadAndCacheAudio(String audioUrl) async {
    if (_cachedAudioPaths.containsKey(audioUrl)) {
      return _cachedAudioPaths[audioUrl]!;
    }

    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/${_getFileNameFromUrl(audioUrl)}';
      final file = File(filePath);

      if (await file.exists()) {
        _cachedAudioPaths[audioUrl] = filePath;
        return filePath;
      }

      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        _cachedAudioPaths[audioUrl] = filePath;
        return filePath;
      }
    } catch (e) {
      print('Error caching audio: $e');
    }

    return audioUrl;
  }

  String _getFileNameFromUrl(String url) {
    return url.split('/').last;
  }

  Future<void> _playSound(String audioUrl) async {
    if (!_isAudioPlayerInitialized) return;

    try {
      setState(() {
        _currentlyPlaying = audioUrl;
      });

      await _audioPlayer.stop();

      String audioSource;
      try {
        audioSource = await _downloadAndCacheAudio(audioUrl);
      } catch (e) {
        audioSource = audioUrl;
      }

      if (audioSource.startsWith('http')) {
        await _audioPlayer.play(UrlSource(audioSource));
      } else {
        await _audioPlayer.play(DeviceFileSource(audioSource));
      }

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.completed) {
          setState(() {
            _currentlyPlaying = null;
          });
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _currentlyPlaying = null;
      });
    }
  }

  String _getAudioUrlForLetter(String letter) {
    return alphabets.firstWhere(
          (alphabet) => alphabet['letter']!.startsWith(letter),
      orElse: () => alphabets[0],
    )['audio']!;
  }

  @override
  void dispose() {
    if (_isAudioPlayerInitialized) {
      _audioPlayer.dispose();
    }
    _pageController.dispose();
    _clearOldCache();
    super.dispose();
  }

  Future<void> _clearOldCache() async {
    try {
      final directory = await getTemporaryDirectory();
      final cacheDir = Directory('${directory.path}/');
      if (await cacheDir.exists()) {
        final files = cacheDir.listSync();
        final now = DateTime.now();

        for (final file in files) {
          if (file is File) {
            final stat = await file.stat();
            final age = now.difference(stat.modified);
            if (age.inDays > 7) {
              await file.delete();
            }
          }
        }
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  // Daftar alphabet dengan pengucapan dan URL audio dari server
  final List<Map<String, String>> alphabets = [
    {
      'letter': 'Aa',
      'sound': '/eɪ/',
      'audio': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'letter': 'Bb',
      'sound': '/biː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-b-1082.mp3',
    },
    {
      'letter': 'Cc',
      'sound': '/siː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-c-1083.mp3',
    },
    {
      'letter': 'Dd',
      'sound': '/diː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-d-1084.mp3',
    },
    {
      'letter': 'Ee',
      'sound': '/iː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-e-1085.mp3',
    },
    {
      'letter': 'Ff',
      'sound': '/ɛf/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-f-1086.mp3',
    },
    {
      'letter': 'Gg',
      'sound': '/dʒiː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-g-1087.mp3',
    },
    {
      'letter': 'Hh',
      'sound': '/eɪtʃ/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-h-1088.mp3',
    },
    {
      'letter': 'Ii',
      'sound': '/aɪ/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-i-1089.mp3',
    },
    {
      'letter': 'Jj',
      'sound': '/dʒeɪ/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-j-1090.mp3',
    },
    {
      'letter': 'Kk',
      'sound': '/keɪ/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-k-1091.mp3',
    },
    {
      'letter': 'Ll',
      'sound': '/ɛl/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-l-1092.mp3',
    },
    {
      'letter': 'Mm',
      'sound': '/ɛm/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-m-1093.mp3',
    },
    {
      'letter': 'Nn',
      'sound': '/ɛn/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-n-1094.mp3',
    },
    {
      'letter': 'Oo',
      'sound': '/oʊ/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-o-1095.mp3',
    },
    {
      'letter': 'Pp',
      'sound': '/piː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-p-1096.mp3',
    },
    {
      'letter': 'Qq',
      'sound': '/kjuː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-q-1097.mp3',
    },
    {
      'letter': 'Rr',
      'sound': '/ɑːr/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-r-1098.mp3',
    },
    {
      'letter': 'Ss',
      'sound': '/ɛs/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-s-1099.mp3',
    },
    {
      'letter': 'Tt',
      'sound': '/tiː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-t-1100.mp3',
    },
    {
      'letter': 'Uu',
      'sound': '/juː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-u-1101.mp3',
    },
    {
      'letter': 'Vv',
      'sound': '/viː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-v-1102.mp3',
    },
    {
      'letter': 'Ww',
      'sound': '/ˈdʌbəl.juː/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-w-1103.mp3',
    },
    {
      'letter': 'Xx',
      'sound': '/ɛks/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-x-1104.mp3',
    },
    {
      'letter': 'Yy',
      'sound': '/waɪ/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-y-1105.mp3',
    },
    {
      'letter': 'Zz',
      'sound': '/zɛd/',
      'audio':
      'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-z-1106.mp3',
    },
  ];

  // Warna-warna untuk container alphabet
  final List<Color> colorPalette = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
    Colors.cyanAccent,
    Colors.limeAccent,
  ];

  final List<Map<String, String>> mengejas = [
    {
      'letter': 'Aa',
      'sound': '/eɪ/',
      'word': 'Apple',
      'image': 'assets/images/apple.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-a-1081.mp3',
    },
    {
      'letter': 'Bb',
      'sound': '/biː/',
      'word': 'Ball',
      'image': 'assets/images/ball.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-b-1082.mp3',
    },
    {
      'letter': 'Cc',
      'sound': '/siː/',
      'word': 'Cat',
      'image': 'assets/images/cat.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-c-1083.mp3',
    },
    {
      'letter': 'Dd',
      'sound': '/diː/',
      'word': 'Dog',
      'image': 'assets/images/dog.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-d-1084.mp3',
    },
    {
      'letter': 'Ee',
      'sound': '/iː/',
      'word': 'Elephant', // Changed from Egg
      'image': 'assets/images/elephant.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-e-1085.mp3',
    },
    {
      'letter': 'Ff',
      'sound': '/ɛf/',
      'word': 'Fish',
      'image': 'assets/images/fish.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-f-1086.mp3',
    },
    {
      'letter': 'Gg',
      'sound': '/dʒiː/',
      'word': 'Goat',
      'image': 'assets/images/goat.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-g-1087.mp3',
    },
    {
      'letter': 'Hh',
      'sound': '/eɪtʃ/',
      'word': 'House', // Changed from Hat
      'image': 'assets/images/house.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-h-1088.mp3',
    },
    {
      'letter': 'Ii',
      'sound': '/aɪ/',
      'word': 'Ice Cream', // Changed from Ice
      'image': 'assets/images/ice_cream.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-i-1089.mp3',
    },
    {
      'letter': 'Jj',
      'sound': '/dʒeɪ/',
      'word': 'Jellyfish', // Changed from Jam
      'image': 'assets/images/jellyfish.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-j-1090.mp3',
    },
    {
      'letter': 'Kk',
      'sound': '/keɪ/',
      'word': 'Kite',
      'image': 'assets/images/kite.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-k-1091.mp3',
    },
    {
      'letter': 'Ll',
      'sound': '/ɛl/',
      'word': 'Lion',
      'image': 'assets/images/lion.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-l-1092.mp3',
    },
    {
      'letter': 'Mm',
      'sound': '/ɛm/',
      'word': 'Monkey', // Changed from Moon
      'image': 'assets/images/monkey.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-m-1093.mp3',
    },
    {
      'letter': 'Nn',
      'sound': '/ɛn/',
      'word': 'Nest',
      'image': 'assets/images/nest.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-n-1094.mp3',
    },
    {
      'letter': 'Oo',
      'sound': '/oʊ/',
      'word': 'Orange',
      'image': 'assets/images/orange.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-o-1095.mp3',
    },
    {
      'letter': 'Pp',
      'sound': '/piː/',
      'word': 'Pencil',
      'image': 'assets/images/pencil.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-p-1096.mp3',
    },
    {
      'letter': 'Qq',
      'sound': '/kjuː/',
      'word': 'Queen',
      'image': 'assets/images/queen.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-q-1097.mp3',
    },
    {
      'letter': 'Rr',
      'sound': '/ɑːr/',
      'word': 'Rabbit', // Changed from Rain
      'image': 'assets/images/rabbit.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-r-1098.mp3',
    },
    {
      'letter': 'Ss',
      'sound': '/ɛs/',
      'word': 'Star', // Changed from Sun
      'image': 'assets/images/star.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-s-1099.mp3',
    },
    {
      'letter': 'Tt',
      'sound': '/tiː/',
      'word': 'Tiger', // Changed from Tree
      'image': 'assets/images/tiger.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-t-1100.mp3',
    },
    {
      'letter': 'Uu',
      'sound': '/juː/',
      'word': 'Umbrella',
      'image': 'assets/images/umbrella.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-u-1101.mp3',
    },
    {
      'letter': 'Vv',
      'sound': '/viː/',
      'word': 'Violin',
      'image': 'assets/images/violin.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-v-1102.mp3',
    },
    {
      'letter': 'Ww',
      'sound': '/ˈdʌbəl.juː/',
      'word': 'Whale', // Changed from Water
      'image': 'assets/images/whale.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-w-1103.mp3',
    },
    {
      'letter': 'Xx',
      'sound': '/ɛks/',
      'word': 'Xylophone',
      'image': 'assets/images/xylophone.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-x-1104.mp3',
    },
    {
      'letter': 'Yy',
      'sound': '/waɪ/',
      'word': 'Yoyo',
      'image': 'assets/images/yoyo.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-y-1105.mp3',
    },
    {
      'letter': 'Zz',
      'sound': '/zɛd/',
      'word': 'Zebra',
      'image': 'assets/images/zebra.png',
      'audio': 'https://assets.mixkit.co/sfx/preview/mixkit-alphabet-z-1106.mp3',
    },
  ];

  Widget _buildAlphabetPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _pageTitles[_currentPage],
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: alphabets.length,
            itemBuilder: (context, index) {
              final alphabet = alphabets[index];
              final colorIndex = index % colorPalette.length;
              final color = colorPalette[colorIndex];

              return AlphabetCard(
                letter: alphabet['letter']!,
                sound: alphabet['sound']!,
                audioUrl: alphabet['audio']!,
                color: color,
                isPlaying: _currentlyPlaying == alphabet['audio'],
                onTap: () => _playSound(alphabet['audio']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMengejaPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _pageTitles[_currentPage],
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: mengejas.length,
            itemBuilder: (context, index) {
              final mengeja = mengejas[index];
              final colorIndex = index % colorPalette.length;
              final color = colorPalette[colorIndex];

              return MengejaCard(
                letter: mengeja['letter']!,
                sound: mengeja['sound']!,
                word: mengeja['word']!,
                imagePath: mengeja['image']!,
                audioUrl: mengeja['audio']!,
                color: color,
                isPlaying: _currentlyPlaying == mengeja['audio'],
                onTap: () => _playSound(mengeja['audio']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGamePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _pageTitles[_currentPage],
            style: primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: mengejas.length,
            itemBuilder: (context, index) {
              final mengeja = mengejas[index];
              final colorIndex = index % colorPalette.length;
              final color = colorPalette[colorIndex];

              return GameCard(
                letter: mengeja['letter']!,
                sound: mengeja['sound']!,
                word: mengeja['word']!,
                imagePath: mengeja['image']!,
                audioUrl: mengeja['audio']!,
                color: color,
                isPlaying: _currentlyPlaying == mengeja['audio'],
                onTap: () => _playSound(mengeja['audio']!),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("The Alphabet In English", iconSize: 14.0),
      body: Column(
        children: [
          // Linear Progress Indicator di luar PageView
          LinearProgressIndicator(
            value: (_currentPage + 1) / _pageTitles.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
            minHeight: 6,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildAlphabetPage(),
                _buildMengejaPage(),
                _buildGamePage()
                // _buildPlaceholderPage(
                //   "C. Alphabet Game",
                //   "Halaman ini sedang dalam pengembangan. Game seru untuk belajar alphabet akan segera tersedia!",
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                // Previous Button - Only show if not on first page
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: kWhiteColor,
                        side: const BorderSide(color: kSecondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        "SEBELUMNYA",
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                if (_currentPage > 0) const SizedBox(width: 16),

                // Next/Finish Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      if (_currentPage < _pageTitles.length - 1) {
                        // Go to next page if not on last page
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Handle finish action on last page
                        // You can add your finish logic here
                        print("Finished alphabet learning!");
                      }
                    },
                    child: Text(
                      _currentPage == _pageTitles.length - 1
                          ? "SELESAI"
                          : "SELANJUTNYA",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}