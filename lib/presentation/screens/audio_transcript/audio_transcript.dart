part of 'audio_transcript_imports.dart';

@RoutePage()
class AudioTranscriptScreen extends StatefulWidget {
  const AudioTranscriptScreen(
      {super.key, required this.audioId, required this.permission});

  final String audioId;
  final String permission;

  @override
  State<AudioTranscriptScreen> createState() => _AudioTranscriptScreenState();
}

class _AudioTranscriptScreenState extends State<AudioTranscriptScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double playbackSpeed = 1.0;
  final List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  String? currentAudioUrl;
  bool _isEditing = false;
  AudioNoteModel? _cachedAudioNoteModel;
  final TextEditingController _transcriptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AudioTranscriptBloc>().add(
        AudioTranscriptInitialFetchDataAudioEvent(audioId: widget.audioId));

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

    audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
  }

  Future<void> _playAudio(String url) async {
    try {
      if (currentAudioUrl != url) {
        await audioPlayer.setUrl(url);
        currentAudioUrl = url;
      }

      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } catch (e) {
      print('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  Future<void> _seekTo(Duration position) async {
    try {
      await audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  Future<void> _stopAndDisposeAudio() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }

  void _enterEditMode() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    if (_cachedAudioNoteModel?.data?.transcript?.content != null) {
      _transcriptController.text =
          _cachedAudioNoteModel!.data!.transcript!.content!;
    }
    setState(() {
      _isEditing = true;
    });
  }

  void _updateTranscript(String transcriptId) {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    if (_cachedAudioNoteModel?.data?.transcript?.id == null) {
      TLoaders.errorSnackBar(context,
          title: 'Error', message: 'Invalid transcript data');
      return;
    }

    context.read<AudioTranscriptBloc>().add(
          AudioTranscriptClickButtonUpdateSummaryTextEvent(
            transcriptId: transcriptId,
            content: _transcriptController.text,
            audioId: widget.audioId,
          ),
        );
  }

  @override
  void dispose() {
    _stopAndDisposeAudio();
    _transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioTranscriptBloc, AudioTranscriptState>(
      listenWhen: (previous, current) => current is AudioTranscriptActionState,
      buildWhen: (previous, current) => current is! AudioTranscriptActionState,
      listener: (context, state) {
        if (state is AudioTranscriptSuccessState) {
          final audioUrl = state.audioNoteModel?.data?.fileUrl;
          if (audioUrl != null && audioUrl.isNotEmpty) {
            _playAudio(audioUrl);
          }
        } else if (state is AudioTranscriptErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is AudioTranscriptUpdateTextSuccessActionState) {
          setState(() {
            _isEditing = false;
            _cachedAudioNoteModel = null;
            _transcriptController.clear();
          });
        }
      },
      builder: (context, state) {
        if (state is AudioTranscriptLoadingState ||
            state is AudioTranscriptUpdateTextLoadingState) {
          return Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
              title: Text('Audio Transcript'),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Center(child: TLoadingSpinkit.loadingPage)],
            ),
          );
        }

        if (state is AudioTranscriptSuccessState) {
          _cachedAudioNoteModel = state.audioNoteModel;
          final transcriptContent =
              _cachedAudioNoteModel?.data?.transcript?.content;

          return Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
              title: Text('Audio Transcript'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: !_isEditing
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: TSizes.defaultSpace,
                            right: TSizes.defaultSpace,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: transcriptContent == null ||
                                            transcriptContent.isEmpty
                                        ? TCreateWidget(
                                            title: 'Creating audio transcript.',
                                            subTitle: 'You will receive a notification once it\'s done.',
                                          )
                                        : SingleChildScrollView(
                                            child: GestureDetector(
                                              onTap: widget.permission == 'read'
                                                  ? null
                                                  : _enterEditMode,
                                              child: Text(transcriptContent,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: TSizes.defaultSpace,
                                right: TSizes.defaultSpace,
                                bottom: TSizes.defaultSpace,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _transcriptController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: 'Enter transcript...',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state is AudioTranscriptUpdateTextLoadingState)
                              Positioned(
                                bottom: 10,
                                right: 0,
                                child: TLoadingSpinkit.loadingButton,
                              )
                            else
                              Positioned(
                                bottom: TSizes.defaultSpace,
                                right: TSizes.defaultSpace,
                                child: GestureDetector(
                                  onTap: () {
                                    _updateTranscript(_cachedAudioNoteModel!
                                        .data!.transcript!.id
                                        .toString());
                                  },
                                  child: state
                                          is AudioTranscriptUpdateTextLoadingState
                                      ? TLoadingSpinkit.loadingButton
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: TColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: TSizes.md,
                                              vertical: TSizes.sm),
                                          child: Text(
                                            'Save',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: TColors.white),
                                          ),
                                        ),
                                ),
                              ),
                          ],
                        ),
                ),
                AudioPlayerControls(
                  fileName: state.audioNoteModel?.data?.name ?? 'Audio',
                  currentPosition: currentPosition,
                  totalDuration: totalDuration,
                  playbackSpeed: playbackSpeed,
                  availableSpeeds: availableSpeeds,
                  isPlaying: isPlaying,
                  showIconClose: false,
                  onSpeedChanged: (double speed) async {
                    setState(() {
                      playbackSpeed = speed;
                    });
                    await audioPlayer.setSpeed(speed);
                  },
                  onClose: () async {
                    await _stopAndDisposeAudio();
                    setState(() {
                      isPlaying = false;
                      currentPosition = Duration.zero;
                      currentAudioUrl = null;
                    });
                  },
                  onPlayPause: () =>
                      _playAudio(state.audioNoteModel?.data?.fileUrl ?? ''),
                  onSeek: _seekTo,
                  onBackward: () {
                    final newPosition =
                        currentPosition - const Duration(seconds: 15);
                    _seekTo(
                        newPosition.isNegative ? Duration.zero : newPosition);
                  },
                  onForward: () {
                    final newPosition =
                        currentPosition + const Duration(seconds: 15);
                    _seekTo(newPosition > totalDuration
                        ? totalDuration
                        : newPosition);
                  },
                ),
              ],
            ),
          );
        } else if (state is AudioTranscriptErrorActionState) {
          return Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
              title: Text('Audio Transcript'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: TColors.error),
                  SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Failed to load transcript',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
