part of '../widget_imports.dart';

class AudioDetailTab extends StatefulWidget {
  const AudioDetailTab({super.key, required this.noteId, required this.permission});

  final String noteId;
  final String permission;

  @override
  State<AudioDetailTab> createState() => _AudioDetailTabState();
}

class _AudioDetailTabState extends State<AudioDetailTab> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioRecorder audioRecorder = AudioRecorder();
  late final RecorderController recorderController;
  bool isPlaying = false;
  bool isRecording = false;
  bool isPaused = false;
  int? currentlyPlayingIndex;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  Duration recordingDuration = Duration.zero;
  double playbackSpeed = 1.0;
  final List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  Timer? recordingTimer;
  String? currentRecordingPath;
  ListAudioNoteModel? _cachedAudioNoteModel;
  String? _selectedViewType;

  @override
  void initState() {
    super.initState();
    _initRecorder();
    context.read<NoteDetailBloc>().add(NoteDetailInitialFetchDataListAudioEvent(noteId: widget.noteId));

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

  Future<void> _startRecording() async {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'You do not have permission to edit this note');
      return;
    }
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

      await recorderController.record();
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
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'You do not have permission to edit this note');
      return;
    }
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
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'You do not have permission to edit this note');
      return;
    }
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
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'You do not have permission to edit this note');
      return;
    }
    try {
      await recorderController.stop();
      String? filePath = await audioRecorder.stop();
      recordingTimer?.cancel();
      if (mounted && filePath != null) {
        context.read<NoteDetailBloc>().add(
              NoteDetailClickButtonCreateAudioEvent(
                id: widget.noteId,
                audioFile: File(filePath),
              ),
            );
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
            content: Text('Error stopping recording: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<void> _cancelRecording() async {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'You do not have permission to edit this note');
      return;
    }
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

  Future<void> _playAudio(int index, String url) async {
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

    await audioPlayer.setUrl(url);
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

  _uploadFile() async {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'You do not have permission to edit this note');
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final tempPlayer = AudioPlayer();
      try {
        await tempPlayer.setFilePath(file.path!);

        setState(() {
          context.read<NoteDetailBloc>().add(NoteDetailClickButtonCreateAudioEvent(
                id: widget.noteId,
                audioFile: File(file.path!),
              ));
        });
      } finally {
        await tempPlayer.stop();
        await tempPlayer.dispose();
      }
    }
  }

  void _deleteAudioWarningPopup (String audioId) {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context, title: 'Error', message: 'You do not have permission to edit this note');
      return;
    }
    TWarningPopup.show(
      context: context,
      title: 'Delete audio',
      message: 'Are you sure you want to delete this audio? This action cannot be undone.',
      onConfirm: () {
        context.read<NoteDetailBloc>().add(NoteDetailClickButtonDeleteAudioEvent(audioId: audioId));
      },
    );
  }

  void _showAudioModalBottomSheet(String audioId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Iconsax.document_text),
                title: Text('View Transcript', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedViewType = 'transcript';
                  });
                  context.read<NoteDetailBloc>().add(NoteDetaiClickButtonNavigationToAudioTranscriptTextEvent(audioId: audioId, permission: widget.permission));
                },
              ),
              ListTile(
                leading: Icon(Iconsax.flash_1),
                title: Text('View Summary', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedViewType = 'summary';
                  });
                  context.read<NoteDetailBloc>().add(NoteDetaiClickButtonNavigationToAudioSummaryTextEvent(audioId: audioId, permission: widget.permission));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    recordingTimer?.cancel();
    recorderController.dispose();
    audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteDetailBloc, NoteDetailState>(
      listenWhen: (previous, current) => current is NoteDetailActionState,
      buildWhen: (previous, current) => current is! NoteDetailActionState,
      listener: (context, state) {
        if (state is NotesCreateAudioDetailSuccessActionState) {
          context.read<NoteDetailBloc>().add(NoteDetailInitialFetchDataListAudioEvent(noteId: widget.noteId));
          TLoaders.successSnackBar(context, title: 'Audio uploaded successfully');
        } else if (state is NotesCreateAudioDetailErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error uploaded audio', message: state.message);
        } else if(state is NoteDeleteAudioSuccessState) {
          TLoaders.successSnackBar(context, title: 'Delete audio successfully');
          context.read<NoteDetailBloc>().add(NoteDetailInitialFetchDataListAudioEvent(noteId: widget.noteId));
        } else if (state is NoteAudioDetailErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Error', message: state.message);
        } else if(state is NoteDetailNavigationToAudioTranscriptionTextPageActionState) {
          AutoRouter.of(context).push(AudioTranscriptScreenRoute(audioId: state.audioId, permission: state.permission));
        } else if(state is NoteDetailNavigationToAudioSummaryTextPageActionState) {
          AutoRouter.of(context).push(AudioSummaryScreenRoute(audioId: state.audioId, permission: state.permission));
        }
      },
      builder: (context, state) {
        if (state is NoteListAudioDetailLoadingState && _cachedAudioNoteModel == null) {
          return const Center(child: LoadingSpinkit.loadingPage);
        }

        if (state is NoteListAudioDetailSuccessState) {
          _cachedAudioNoteModel = state.listAudioNoteModel;
        }

        final audioList = _cachedAudioNoteModel?.data ?? [];

        return Stack(
          children: [
            Column(
              children: [
                if (widget.permission != 'read')
                  Padding(
                    padding: const EdgeInsets.only(top: TSizes.spaceBtwItems),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => _uploadFile(),
                          child: Icon(Iconsax.document_download, size: 30),
                        )
                      ],
                    ),
                  ),
                Expanded(
                  child: audioList.isEmpty
                      ? Center(child: TEmpty(subTitle: 'No audio recordings yet'))
                      : ListView.builder(
                          itemCount: audioList.length,
                          itemBuilder: (context, index) {
                            final audio = audioList[index];
                            return RecordingListItem(
                              name: 'Audio ${index + 1}',
                              duration: 'Create on ${Utils.formatDate(audio.createdAt)}',
                              isPlaying: currentlyPlayingIndex == index && isPlaying,
                              onPlayPause: () => _playAudio(index, audio.fileUrl ?? ''),
                              onDelete: widget.permission == 'read' ? () {} : () => _deleteAudioWarningPopup(audio.id!),
                              showMore: true,
                              onMore: () => _showAudioModalBottomSheet(audio.id!),
                            );
                          },
                        ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isRecording)
                  RecordingControls(
                    isRecording: isRecording,
                    isPaused: isPaused,
                    recordingDuration: recordingDuration,
                    recorderController: recorderController,
                    onCancel: _cancelRecording,
                    onStop: _stopRecording,
                    onPauseResume: isPaused ? _resumeRecording : _pauseRecording,
                  )
                else if (currentlyPlayingIndex != null)
                  AudioPlayerControls(
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
                    onPlayPause: () =>
                        _playAudio(currentlyPlayingIndex!, audioList[currentlyPlayingIndex!].fileUrl ?? ''),
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
                else if (widget.permission != 'read')
                  Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Center(
                      child: AvatarGlow(
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
                    ),
                  ),
              ],
            )
          ],
        );
      },
    );
  }
}
