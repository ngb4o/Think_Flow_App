part of 'audio_notes_imports.dart';

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

  String get formattedDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}

@RoutePage()
class AudioNotesPage extends StatefulWidget {
  const AudioNotesPage({super.key});

  @override
  State<AudioNotesPage> createState() => _AudioNotesPageState();
}

class _AudioNotesPageState extends State<AudioNotesPage> {
  // Audio recording and playback controllers
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  
  // List to store all audio recordings
  final List<AudioRecording> recordings = [];
  
  // Current recording state variables
  String? currentRecordingPath;
  bool isRecording = false;
  bool isPaused = false;
  bool isPlaying = false;
  Duration recordingDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  Timer? recordingTimer;
  int? currentlyPlayingIndex;
  
  // Playback speed control
  double playbackSpeed = 1.0;
  final List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  // Load all audio recordings from device storage
  Future<void> _loadRecordings() async {
    try {
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> files = await appDocumentsDir.list().toList();
      
      final List<AudioRecording> loadedRecordings = [];
      
      for (var file in files) {
        if (file.path.endsWith('.wav')) {
          final fileExists = await File(file.path).exists();
          if (!fileExists) continue;

          try {
            // Calculate estimated duration based on file size
            // Roughly 1 second = 176400 bytes for 44.1kHz, 16-bit, mono
            final fileSize = await File(file.path).length();
            final estimatedDuration = Duration(seconds: (fileSize / 176400).round());
            
            loadedRecordings.add(AudioRecording(
              path: file.path,
              name: p.basename(file.path),
              duration: estimatedDuration,
              createdAt: File(file.path).lastModifiedSync(),
            ));
          } catch (e) {
            debugPrint('Error processing file ${file.path}: $e');
            continue;
          }
        }
      }
      
      if (mounted) {
        setState(() {
          recordings.clear();
          recordings.addAll(loadedRecordings);
        });
      }
    } catch (e) {
      debugPrint('Error loading recordings: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading recordings: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Start a new audio recording
  Future<void> _startRecording() async {
    try {
      if (!await audioRecorder.hasPermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please grant microphone permission in settings'),
            ),
          );
        }
        return;
      }

      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      final String filePath = p.join(appDocumentsDir.path, 'recording_${DateTime.now().millisecondsSinceEpoch}.wav');

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      if (mounted) {
        setState(() {
          isRecording = true;
          isPaused = false;
          currentRecordingPath = null;
          recordingDuration = Duration.zero;
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting recording: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Start the recording duration timer
  void _startTimer() {
    recordingTimer?.cancel();
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          recordingDuration += const Duration(seconds: 1);
        });
      }
    });
  }

  // Pause the current recording
  Future<void> _pauseRecording() async {
    try {
      await audioRecorder.pause();
      if (mounted) {
        setState(() {
          isPaused = true;
        });
        recordingTimer?.cancel();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error pausing recording: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Resume a paused recording
  Future<void> _resumeRecording() async {
    try {
      await audioRecorder.resume();
      if (mounted) {
        setState(() {
          isPaused = false;
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resuming recording: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Stop and save the current recording
  Future<void> _stopRecording() async {
    try {
      String? filePath = await audioRecorder.stop();
      recordingTimer?.cancel();
      if (mounted && filePath != null) {
        await audioPlayer.setFilePath(filePath);
        final duration = audioPlayer.duration ?? Duration.zero;
        setState(() {
          isRecording = false;
          isPaused = false;
          currentRecordingPath = filePath;
          recordings.add(AudioRecording(
            path: filePath,
            name: p.basename(filePath),
            duration: duration,
            createdAt: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping recording: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Cancel the current recording without saving
  Future<void> _cancelRecording() async {
    try {
      await audioRecorder.stop();
      recordingTimer?.cancel();
      if (mounted) {
        setState(() {
          isRecording = false;
          isPaused = false;
          currentRecordingPath = null;
          recordingDuration = Duration.zero;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error canceling recording: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Play a specific recording
  Future<void> _playRecording(int index) async {
    if (currentlyPlayingIndex == index) {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
      setState(() {
        isPlaying = audioPlayer.playing;
      });
      return;
    }

    if (currentlyPlayingIndex != null) {
      await audioPlayer.stop();
    }

    setState(() {
      currentlyPlayingIndex = index;
      isPlaying = true;
      currentPosition = Duration.zero;
      playbackSpeed = 1.0; // Reset speed when changing audio
    });

    await audioPlayer.setFilePath(recordings[index].path);
    await audioPlayer.setSpeed(playbackSpeed);
    await audioPlayer.play();

    // Listen for playback completion
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            isPlaying = false;
            currentPosition = Duration.zero;
            audioPlayer.seek(Duration.zero);
          });
        }
      }
    });
  }

  // Seek to a specific position in the audio
  Future<void> _seekTo(Duration position) async {
    await audioPlayer.seek(position);
  }

  // Delete a recording
  Future<void> _deleteRecording(int index) async {
    try {
      final recording = recordings[index];
      final file = File(recording.path);
      if (await file.exists()) {
        await file.delete();
      }
      setState(() {
        recordings.removeAt(index);
        if (currentlyPlayingIndex == index) {
          currentlyPlayingIndex = null;
          isPlaying = false;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting recording: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // Format duration to HH:MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    _loadRecordings();
    // Listen to audio player position changes
    audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    });
    // Listen to audio player duration changes
    audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration ?? Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    recordingTimer?.cancel();
    audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: TSizes.spaceBtwItems),
          // List of recordings
          Expanded(
            child: ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                final recording = recordings[index];
                return ListTile(
                  horizontalTitleGap: TSizes.spaceBtwItems,
                  minLeadingWidth: 0,
                  leading: Icon(Iconsax.microphone),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        recording.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: TSizes.xs),
                      Text(
                        recording.formattedDuration,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          currentlyPlayingIndex == index ? Iconsax.pause : Iconsax.play,
                        ),
                        onPressed: () => _playRecording(index),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.trash),
                        onPressed: () => _deleteRecording(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating action button for recording controls or audio player
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isRecording
          ? Container(
              padding: EdgeInsets.only(bottom: TSizes.defaultSpace),
              decoration: BoxDecoration(
                color: TColors.primary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: TColors.grey),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isRecording)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _formatDuration(recordingDuration),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: TColors.white),
                      ),
                    ),
                  SizedBox(height: TSizes.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left side: Empty space
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      // Center: Recording controls
                      FloatingActionButton(
                        backgroundColor: TColors.white,
                        heroTag: 'cancel',
                        onPressed: _cancelRecording,
                        child: const Icon(Iconsax.close_circle),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      FloatingActionButton(
                        backgroundColor: TColors.white,
                        heroTag: 'stop',
                        onPressed: _stopRecording,
                        child: const Icon(Iconsax.stop),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      FloatingActionButton(
                        backgroundColor: TColors.white,
                        heroTag: 'pause',
                        onPressed: isPaused ? _resumeRecording : _pauseRecording,
                        child: Icon(isPaused ? Iconsax.play : Iconsax.pause),
                      ),
                      // Right side: Empty space
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : currentlyPlayingIndex != null
              ? Container(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Audio file name with close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              recordings[currentlyPlayingIndex!].name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TColors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Iconsax.close_circle, color: TColors.white),
                            onPressed: () {
                              audioPlayer.stop();
                              setState(() {
                                currentlyPlayingIndex = null;
                                isPlaying = false;
                                currentPosition = Duration.zero;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      // Progress bar and time display
                      Row(
                        children: [
                          Text(
                            _formatDuration(currentPosition),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TColors.white),
                          ),
                          Expanded(
                            child: totalDuration > Duration.zero
                                ? SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: TColors.white,
                                      inactiveTrackColor: TColors.white.withOpacity(0.3),
                                      thumbColor: TColors.white,
                                      trackHeight: 4,
                                    ),
                                    child: Slider(
                                      value: currentPosition.inSeconds.toDouble(),
                                      max: totalDuration.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        _seekTo(Duration(seconds: value.toInt()));
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          Text(
                            _formatDuration(totalDuration),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TColors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      // Playback controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Left side: Playback speed control
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                PopupMenuButton<double>(
                                  icon: Text(
                                    '${playbackSpeed}x',
                                    style: const TextStyle(color: TColors.white),
                                  ),
                                  onSelected: (double speed) async {
                                    setState(() {
                                      playbackSpeed = speed;
                                    });
                                    await audioPlayer.setSpeed(speed);
                                  },
                                  itemBuilder: (BuildContext context) => availableSpeeds.map((double speed) {
                                    return PopupMenuItem<double>(
                                      value: speed,
                                      child: Text('${speed}x'),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                          // Center: Main playback controls
                          IconButton(
                            icon: const Icon(Iconsax.backward_15_seconds, color: TColors.white),
                            onPressed: () {
                              final newPosition = currentPosition - const Duration(seconds: 15);
                              _seekTo(newPosition.isNegative ? Duration.zero : newPosition);
                            },
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          FloatingActionButton(
                            backgroundColor: TColors.white,
                            child: Icon(
                              audioPlayer.playing ? Iconsax.pause : Iconsax.play,
                              color: TColors.primary,
                            ),
                            onPressed: () => _playRecording(currentlyPlayingIndex!),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          IconButton(
                            icon: const Icon(Iconsax.forward_15_seconds, color: TColors.white),
                            onPressed: () {
                              final newPosition = currentPosition + const Duration(seconds: 15);
                              _seekTo(newPosition > totalDuration ? totalDuration : newPosition);
                            },
                          ),
                          // Right side: Download button
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Iconsax.document_download5, color: TColors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : AvatarGlow(
                  animate: true,
                  glowColor: TColors.primary,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: _startRecording,
                    child: const Icon(Iconsax.microphone),
                  ),
                ),
    );
  }
}
