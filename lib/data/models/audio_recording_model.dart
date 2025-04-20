import '../../utils/audio_utils.dart';

class AudioRecording {
  final String path;
  final String name;
  final Duration duration;
  final DateTime createdAt;

  AudioRecording({
    required this.path,
    required this.name,
    required this.duration,
    required this.createdAt,
  });

  String get formattedDuration => AudioUtils.formatDuration(duration);
}