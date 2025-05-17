part of 'audio_notes_imports.dart';

@RoutePage()
class AudioNotesPage extends StatefulWidget {
  const AudioNotesPage({super.key});

  @override
  State<AudioNotesPage> createState() => _AudioNotesPageState();
}

class _AudioNotesPageState extends State<AudioNotesPage> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<AudioRecording> recordings = [];
  late final RecorderController recorderController;

  String? currentRecordingPath;
  bool isRecording = false;
  bool isPaused = false;
  bool isPlaying = false;
  Duration recordingDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  Timer? recordingTimer;
  int? currentlyPlayingIndex;

  double playbackSpeed = 1.0;
  final List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  Future<String?> _convertM4aToMp3(String m4aPath) async {
    try {
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      final String mp3Path = p.join(appDocumentsDir.path, 'recording_${DateTime.now().millisecondsSinceEpoch}.mp3');
      
      final session = await FFmpegKit.execute('-i $m4aPath -c:a libmp3lame -q:a 2 $mp3Path');
      final returnCode = await session.getReturnCode();
      
      if (returnCode?.isValueSuccess() ?? false) {
        // Delete the original M4A file
        final m4aFile = File(m4aPath);
        if (await m4aFile.exists()) {
          await m4aFile.delete();
        }
        return mp3Path;
      } else {
        debugPrint('FFmpeg conversion failed: ${await session.getOutput()}');
        return null;
      }
    } catch (e) {
      debugPrint('Error converting M4A to MP3: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _loadRecordings();
    audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    });
    audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration ?? Duration.zero;
        });
      }
    });
  }

  Future<void> _initRecorder() async {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100
      ..bitRate = 128000;
  }

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
            final estimatedDuration = await AudioUtils.estimateAudioDuration(file.path);

            loadedRecordings.add(AudioRecording(
              path: file.path,
              name: AudioUtils.getFileNameFromPath(file.path),
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
      final String filePath = p.join(appDocumentsDir.path, 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a');

      // Start recording with RecorderController
      await recorderController.record();

      // Start recording with AudioRecorder
      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      if (mounted) {
        setState(() {
          isRecording = true;
          isPaused = false;
          currentRecordingPath = filePath;
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

  Future<void> _pauseRecording() async {
    try {
      await recorderController.pause();
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

  Future<void> _resumeRecording() async {
    try {
      await recorderController.record();
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

  Future<void> _stopRecording() async {
    try {
      await recorderController.stop();
      String? filePath = await audioRecorder.stop();
      recordingTimer?.cancel();
      
      if (mounted && filePath != null) {
        // Convert M4A to MP3
        final mp3Path = await _convertM4aToMp3(filePath);
        if (mp3Path != null) {
          await audioPlayer.setFilePath(mp3Path);
          final duration = audioPlayer.duration ?? Duration.zero;
          setState(() {
            isRecording = false;
            isPaused = false;
            currentRecordingPath = mp3Path;
            recordings.add(AudioRecording(
              path: mp3Path,
              name: AudioUtils.getFileNameFromPath(mp3Path),
              duration: duration,
              createdAt: DateTime.now(),
            ));
          });
        } else {
          throw Exception('Failed to convert audio to MP3');
        }
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

  Future<void> _cancelRecording() async {
    try {
      await recorderController.stop();
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
      playbackSpeed = 1.0;
    });

    await audioPlayer.setFilePath(recordings[index].path);
    await audioPlayer.setSpeed(playbackSpeed);
    await audioPlayer.play();

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

  Future<void> _seekTo(Duration position) async {
    await audioPlayer.seek(position);
  }

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

  _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final tempPlayer = AudioPlayer();
      try {
        await tempPlayer.setFilePath(file.path!);
        final duration = tempPlayer.duration;
        
        setState(() {
          recordings.add(AudioRecording(
            path: file.path!,
            name: file.name,
            duration: duration ?? Duration.zero,
            createdAt: DateTime.now(),
          ));
        });
      } finally {
        await tempPlayer.stop();
        await tempPlayer.dispose();
      }
    }
  }

  @override
  void dispose() {
    recordingTimer?.cancel();
    recorderController.dispose();
    audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listenWhen: (previous, current) => current is NotesActionState,
      buildWhen: (previous, current) => current is! NotesActionState,
      listener: (context, state) {
        if (state is NotesCreateSuccessActionSate) {
          // Upload all recordings when note is created
          for (var recording in recordings) {
            context.read<NotesBloc>().add(
                  NoteCreateAudioEvent(
                    id: state.id,
                    audioFile: File(recording.path),
                  ),
                );
          }
        } else if (state is NotesCreateAudioSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Audio uploaded successfully');
        } else if (state is NotesCreateAudioErrorActionState) {
          TLoaders.successSnackBar(context, title: 'Error uploaded audio', message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => _uploadFile(),
                    child: Icon(Iconsax.document_download, size: 30),
                  )
                ],
              ),
              if (recordings.isEmpty)
                Expanded(
                  child: Center(child: TEmpty(subTitle: 'Tap microphone to start recording')),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: recordings.length,
                  itemBuilder: (context, index) {
                    final recording = recordings[index];
                    return RecordingListItem(
                      name: 'Audio ${index + 1}',
                      duration: recording.formattedDuration,
                      isPlaying: currentlyPlayingIndex == index && isPlaying,
                      onPlayPause: () => _playRecording(index),
                      onDelete: () => _deleteRecording(index),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: isRecording
              ? RecordingControls(
                  isRecording: isRecording,
                  isPaused: isPaused,
                  recordingDuration: recordingDuration,
                  recorderController: recorderController,
                  onCancel: _cancelRecording,
                  onStop: _stopRecording,
                  onPauseResume: isPaused ? _resumeRecording : _pauseRecording,
                )
              : currentlyPlayingIndex != null
                  ? AudioPlayerControls(
                      fileName: 'Audio ${currentlyPlayingIndex! + 1}',
                      currentPosition: currentPosition,
                      totalDuration: totalDuration,
                      playbackSpeed: playbackSpeed,
                      availableSpeeds: availableSpeeds,
                      isPlaying: isPlaying,
                      onSpeedChanged: (double speed) async {
                        setState(() {
                          playbackSpeed = speed;
                        });
                        await audioPlayer.setSpeed(speed);
                      },
                      onClose: () {
                        audioPlayer.stop();
                        setState(() {
                          currentlyPlayingIndex = null;
                          isPlaying = false;
                          currentPosition = Duration.zero;
                        });
                      },
                      onPlayPause: () => _playRecording(currentlyPlayingIndex!),
                      onSeek: _seekTo,
                      onBackward: () {
                        final newPosition = currentPosition - const Duration(seconds: 15);
                        _seekTo(newPosition.isNegative ? Duration.zero : newPosition);
                      },
                      onForward: () {
                        final newPosition = currentPosition + const Duration(seconds: 15);
                        _seekTo(newPosition > totalDuration ? totalDuration : newPosition);
                      },
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
      },
    );
  }
}
