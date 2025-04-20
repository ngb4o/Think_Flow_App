import 'dart:io';
import 'package:path/path.dart' as p;

class AudioUtils {
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  static Future<Duration> estimateAudioDuration(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return Duration.zero;

      // Roughly 1 second = 176400 bytes for 44.1kHz, 16-bit, mono
      final fileSize = await file.length();
      return Duration(seconds: (fileSize / 176400).round());
    } catch (e) {
      return Duration.zero;
    }
  }

  static String getFileNameFromPath(String path) {
    return p.basename(path);
  }
} 