// services/audio_service.dart
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  late AudioPlayer _audioPlayer;
  final Map<String, String> _cachedAudioPaths = {};
  String? _currentlyPlaying;

  factory AudioService() {
    return _instance;
  }

  AudioService._internal() {
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
  }

  Future<String> downloadAndCacheAudio(String audioUrl) async {
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

  Future<void> playSound(String audioUrl) async {
    try {
      _currentlyPlaying = audioUrl;

      await _audioPlayer.stop();

      String audioSource;
      try {
        audioSource = await downloadAndCacheAudio(audioUrl);
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
          _currentlyPlaying = null;
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      _currentlyPlaying = null;
    }
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
    _currentlyPlaying = null;
  }

  String? get currentlyPlaying => _currentlyPlaying;

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  Future<void> clearOldCache() async {
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
}